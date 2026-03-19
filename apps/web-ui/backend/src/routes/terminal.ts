import type { FastifyInstance } from "fastify";
import { spawnPty } from "../pty-runner.js";
import { ptyStore } from "../pty-store.js";

export async function terminalRoutes(fastify: FastifyInstance) {
  // POST /api/terminal — neue PTY-Session anlegen
  fastify.post<{ Body: { cwd?: string } }>("/api/terminal", async (req, reply) => {
    const cwd = req.body?.cwd ?? "/workspace";
    const id = crypto.randomUUID();

    const ptyProcess = spawnPty({
      cwd,
      onData: () => { /* stdout wird direkt per pty.onData in der WS-Route gestreamt */ },
      onExit: (code) => {
        fastify.log.info({ id, code }, "PTY exited");
        ptyStore.delete(id);
      },
    });

    ptyStore.add(id, cwd, ptyProcess.pty);
    return reply.status(201).send({ id, cwd });
  });

  // HEAD /api/terminal/:id — Session-Existenz prüfen
  fastify.head<{ Params: { id: string } }>("/api/terminal/:id", async (req, reply) => {
    const { id } = req.params;
    return ptyStore.get(id)
      ? reply.status(200).send()
      : reply.status(404).send();
  });

  // DELETE /api/terminal/:id — PTY-Session beenden
  fastify.delete<{ Params: { id: string } }>("/api/terminal/:id", async (req, reply) => {
    const { id } = req.params;
    if (!ptyStore.get(id)) {
      return reply.status(404).send({ error: "Session nicht gefunden" });
    }
    ptyStore.delete(id);
    return { deleted: true };
  });

  // WebSocket: /ws/terminal/:id/stream — bidirektional
  // Browser → Server: { type: "input", data: "..." } | { type: "resize", cols: N, rows: N }
  // Server → Browser: raw PTY output (string)
  fastify.get(
    "/ws/terminal/:id/stream",
    { websocket: true },
    (socket, req) => {
      const id = (req.params as { id: string }).id;
      const session = ptyStore.get(id);

      if (!session) {
        socket.send(JSON.stringify({ type: "error", error: "Session nicht gefunden" }));
        socket.close();
        return;
      }

      // PTY stdout → WebSocket
      const dataListener = session.pty.onData((data: string) => {
        if (socket.readyState === 1 /* OPEN */) {
          socket.send(data);
        }
      });

      // PTY exit → WebSocket schließen
      const exitListener = session.pty.onExit(() => {
        if (socket.readyState === 1) socket.close();
      });

      // WebSocket → PTY stdin
      socket.on("message", (raw: Buffer | string) => {
        ptyStore.touch(id);
        const text = raw.toString();

        // Resize-Event: {"type":"resize","cols":120,"rows":40}
        if (text.startsWith("{")) {
          try {
            const msg = JSON.parse(text) as { type: string; data?: string; cols?: number; rows?: number };
            if (msg.type === "resize" && msg.cols && msg.rows) {
              session.pty.resize(msg.cols, msg.rows);
              return;
            }
            if (msg.type === "input" && msg.data) {
              session.pty.write(msg.data);
              return;
            }
          } catch { /* kein JSON → als raw input behandeln */ }
        }

        // Raw-Text direkt in PTY-stdin schreiben
        session.pty.write(text);
      });

      socket.on("close", () => {
        dataListener.dispose();
        exitListener.dispose();
        ptyStore.touch(id);
      });
    }
  );
}
