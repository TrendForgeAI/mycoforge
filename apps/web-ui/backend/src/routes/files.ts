import type { FastifyInstance } from "fastify";
import { readdir, stat } from "node:fs/promises";
import { join, normalize } from "node:path";

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
}
