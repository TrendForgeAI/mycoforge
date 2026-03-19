import type { FastifyInstance } from "fastify";
import { sessionStore } from "../session-store.js";
import { runClaude } from "../claude-runner.js";

// Speichert Claude's eigene session_id (für --resume) getrennt von unserer internen ID
const claudeSessionIds = new Map<string, string>();

export async function sessionRoutes(fastify: FastifyInstance) {
  // POST /api/sessions — neue Session anlegen
  fastify.post<{ Body: { cwd?: string } }>("/api/sessions", async (req, reply) => {
    const cwd = req.body?.cwd ?? "/workspace";
    const session = sessionStore.create(cwd);
    reply.status(201).send({ session });
  });

  // GET /api/sessions — alle Sessions
  fastify.get("/api/sessions", async () => {
    return { sessions: sessionStore.list() };
  });

  // DELETE /api/sessions/:id — Session beenden
  fastify.delete<{ Params: { id: string } }>("/api/sessions/:id", async (req, reply) => {
    const { id } = req.params;
    if (!sessionStore.get(id)) {
      return reply.status(404).send({ error: "Session nicht gefunden" });
    }
    sessionStore.delete(id);
    claudeSessionIds.delete(id);
    return { deleted: true };
  });

  // WebSocket: /ws/sessions/:id/stream
  // Browser sendet: { message: "..." }
  // Server sendet: { type: "token"|"tool_call"|"done"|"error", ... }
  fastify.get(
    "/ws/sessions/:id/stream",
    { websocket: true },
    (socket, req) => {
      const id = (req.params as { id: string }).id;
      const session = sessionStore.get(id);

      if (!session) {
        socket.send(JSON.stringify({ type: "error", error: "Session nicht gefunden" }));
        socket.close();
        return;
      }

      let isRunning = false;

      socket.on("message", (raw: Buffer | string) => {
        let parsed: { message?: string };
        try {
          parsed = JSON.parse(raw.toString());
        } catch {
          socket.send(JSON.stringify({ type: "error", error: "Ungültiges JSON" }));
          return;
        }

        const message = parsed.message?.trim();
        if (!message) return;

        if (isRunning) {
          socket.send(JSON.stringify({ type: "error", error: "Claude läuft bereits — bitte warten" }));
          return;
        }

        isRunning = true;
        const claudeSessionId = claudeSessionIds.get(id);

        runClaude({
          message,
          cwd: session.cwd,
          claudeSessionId,
          onEvent: (event) => {
            socket.send(JSON.stringify(event));
          },
          onDone: (newClaudeSessionId) => {
            claudeSessionIds.set(id, newClaudeSessionId);
            sessionStore.update(id, { lastActivity: new Date() });
            isRunning = false;
          },
          onError: (error) => {
            isRunning = false;
            socket.send(JSON.stringify({ type: "error", error }));
          },
        });
      });

      socket.on("close", () => {
        // Session bleibt am Leben — PTY-Entkopplung
        sessionStore.update(id, { lastActivity: new Date() });
      });
    }
  );
}
