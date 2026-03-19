import type { FastifyInstance } from "fastify";
import { readdir } from "node:fs/promises";
import { join } from "node:path";

const WORKSPACE = process.env.WORKSPACE_PATH ?? "/workspace";

export async function projectRoutes(fastify: FastifyInstance) {
  fastify.get("/api/projects", async (_req, reply) => {
    try {
      const entries = await readdir(WORKSPACE, { withFileTypes: true });
      const projects = entries
        .filter((e) => e.isDirectory())
        .map((e) => ({
          name: e.name,
          path: join(WORKSPACE, e.name),
        }));
      return { projects };
    } catch (err) {
      reply.status(500).send({ error: "Konnte /workspace nicht lesen" });
    }
  });
}
