import type { FastifyInstance } from "fastify";
import { readdir, mkdir, readFile, writeFile } from "node:fs/promises";
import { join, normalize } from "node:path";

const WORKSPACE = process.env.WORKSPACE_PATH ?? "/workspace";
const META_FILE = ".mycoforge.json";

interface ProjectMeta {
  displayName: string;
}

async function readMeta(projectPath: string): Promise<ProjectMeta | null> {
  try {
    const raw = await readFile(join(projectPath, META_FILE), "utf-8");
    return JSON.parse(raw) as ProjectMeta;
  } catch {
    return null;
  }
}

export async function projectRoutes(fastify: FastifyInstance) {
  // GET /api/projects — alle Projekte auflisten
  fastify.get("/api/projects", async (_req, reply) => {
    try {
      const entries = await readdir(WORKSPACE, { withFileTypes: true });
      const projects = await Promise.all(
        entries
          .filter((e) => e.isDirectory())
          .map(async (e) => {
            const projectPath = join(WORKSPACE, e.name);
            const meta = await readMeta(projectPath);
            return {
              name: e.name,
              displayName: meta?.displayName ?? e.name,
              path: projectPath,
            };
          })
      );
      return { projects };
    } catch {
      reply.status(500).send({ error: "Konnte /workspace nicht lesen" });
    }
  });

  // POST /api/projects — neues Projekt anlegen
  fastify.post<{ Body: { name?: string; displayName?: string } }>(
    "/api/projects",
    async (req, reply) => {
      const { name, displayName } = req.body ?? {};

      if (!name || !/^[a-z0-9][a-z0-9-_]*$/.test(name)) {
        return reply.status(400).send({
          error: "Ungültiger Verzeichnisname (nur a–z, 0–9, Bindestrich, Unterstrich)",
        });
      }

      if (!displayName || !displayName.trim()) {
        return reply.status(400).send({ error: "Lesbarer Name fehlt" });
      }

      if (displayName.trim().length > 200) {
        return reply.status(400).send({ error: "Lesbarer Name zu lang (max. 200 Zeichen)" });
      }

      // Pfad-Traversal verhindern
      const projectPath = normalize(join(WORKSPACE, name));
      if (!projectPath.startsWith(WORKSPACE + "/") && projectPath !== WORKSPACE) {
        return reply.status(400).send({ error: "Ungültiger Verzeichnisname" });
      }

      try {
        await mkdir(projectPath);
        const meta: ProjectMeta = { displayName: displayName.trim() };
        await writeFile(join(projectPath, META_FILE), JSON.stringify(meta, null, 2));
        return reply.status(201).send({
          project: { name, displayName: meta.displayName, path: projectPath },
        });
      } catch (err) {
        if ((err as NodeJS.ErrnoException).code === "EEXIST") {
          return reply.status(409).send({ error: "Projekt existiert bereits" });
        }
        return reply.status(500).send({ error: "Konnte Projekt nicht anlegen" });
      }
    }
  );
}
