import type { FastifyInstance } from "fastify";
import { readdir, mkdir } from "node:fs/promises";
import { join, normalize } from "node:path";

const WORKSPACE = process.env.WORKSPACE_PATH ?? "/workspace";

export async function projectRoutes(fastify: FastifyInstance) {
  // GET /api/projects — alle Projekte auflisten
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
    } catch {
      reply.status(500).send({ error: "Konnte /workspace nicht lesen" });
    }
  });

  // POST /api/projects — neues Projekt anlegen
  fastify.post<{ Body: { name?: string } }>("/api/projects", async (req, reply) => {
    const { name } = req.body ?? {};

    if (!name || !/^[a-z0-9][a-z0-9-_]*$/.test(name)) {
      return reply.status(400).send({ error: "Ungültiger Projektname (nur a–z, 0–9, Bindestrich, Unterstrich)" });
    }

    // Pfad-Traversal verhindern
    const projectPath = normalize(join(WORKSPACE, name));
    if (!projectPath.startsWith(WORKSPACE + "/") && projectPath !== WORKSPACE) {
      return reply.status(400).send({ error: "Ungültiger Projektname" });
    }

    try {
      await mkdir(projectPath);
      return reply.status(201).send({ project: { name, path: projectPath } });
    } catch (err) {
      if ((err as NodeJS.ErrnoException).code === "EEXIST") {
        return reply.status(409).send({ error: "Projekt existiert bereits" });
      }
      return reply.status(500).send({ error: "Konnte Projekt nicht anlegen" });
    }
  });
}
