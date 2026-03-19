import type { FastifyInstance } from "fastify";
import { readdir, stat, readFile, writeFile } from "node:fs/promises";
import { join, normalize } from "node:path";

const MAX_FILE_SIZE = 500 * 1024; // 500 KB

const WORKSPACE = process.env.WORKSPACE_PATH ?? "/workspace";

export async function fileRoutes(fastify: FastifyInstance) {
  fastify.get<{ Querystring: { path?: string } }>(
    "/api/files",
    async (req, reply) => {
      const rawPath = req.query.path ?? WORKSPACE;

      // Directory Traversal verhindern
      const safePath = normalize(rawPath);
      if (!safePath.startsWith(WORKSPACE)) {
        return reply.status(403).send({ error: "Zugriff verweigert" });
      }

      try {
        const entries = await readdir(safePath, { withFileTypes: true });
        const files = await Promise.all(
          entries.map(async (e) => {
            const fullPath = join(safePath, e.name);
            const s = await stat(fullPath);
            return {
              name: e.name,
              path: fullPath,
              type: e.isDirectory() ? "directory" : "file",
              size: e.isFile() ? s.size : undefined,
            };
          })
        );
        return { path: safePath, entries: files };
      } catch {
        return reply.status(404).send({ error: "Verzeichnis nicht gefunden" });
      }
    }
  );

  // GET /api/files/content — Dateiinhalt lesen
  fastify.get<{ Querystring: { path?: string } }>(
    "/api/files/content",
    async (req, reply) => {
      const rawPath = req.query.path ?? "";
      if (!rawPath) return reply.status(400).send({ error: "Kein Pfad angegeben" });

      const safePath = normalize(rawPath);
      if (!safePath.startsWith(WORKSPACE)) {
        return reply.status(403).send({ error: "Zugriff verweigert" });
      }

      try {
        const s = await stat(safePath);
        if (!s.isFile()) return reply.status(400).send({ error: "Kein reguläres File" });
        if (s.size > MAX_FILE_SIZE) return reply.status(413).send({ error: "Datei zu groß (max. 500 KB)" });

        const content = await readFile(safePath, "utf-8");
        return { path: safePath, content };
      } catch {
        return reply.status(404).send({ error: "Datei nicht gefunden" });
      }
    }
  );

  // PUT /api/files/content — Dateiinhalt schreiben
  fastify.put<{ Body: { path?: string; content?: string } }>(
    "/api/files/content",
    async (req, reply) => {
      const { path: rawPath, content } = req.body ?? {};
      if (!rawPath || content === undefined) {
        return reply.status(400).send({ error: "path und content erforderlich" });
      }

      const safePath = normalize(rawPath);
      if (!safePath.startsWith(WORKSPACE)) {
        return reply.status(403).send({ error: "Zugriff verweigert" });
      }

      try {
        await writeFile(safePath, content, "utf-8");
        return { ok: true };
      } catch {
        return reply.status(500).send({ error: "Konnte Datei nicht schreiben" });
      }
    }
  );
}
