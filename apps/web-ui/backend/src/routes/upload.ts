import type { FastifyInstance } from "fastify";
import { mkdir, writeFile } from "node:fs/promises";
import { join, extname } from "node:path";
import { randomUUID } from "node:crypto";

const UPLOAD_DIR = "/tmp/uploads";
const MAX_SIZE = 10 * 1024 * 1024; // 10 MB
const ALLOWED_MIME = new Set([
  "image/jpeg",
  "image/png",
  "image/gif",
  "image/webp",
  "image/svg+xml",
]);

export async function uploadRoutes(fastify: FastifyInstance) {
  await mkdir(UPLOAD_DIR, { recursive: true });

  fastify.post("/api/upload", async (req, reply) => {
    const data = await req.file({ limits: { fileSize: MAX_SIZE } });

    if (!data) {
      return reply.status(400).send({ error: "Keine Datei erhalten" });
    }

    if (!ALLOWED_MIME.has(data.mimetype)) {
      return reply.status(400).send({ error: "Nur Bilder erlaubt (jpeg, png, gif, webp, svg)" });
    }

    const ext = extname(data.filename) || ".bin";
    const filename = `${randomUUID()}${ext}`;
    const filepath = join(UPLOAD_DIR, filename);

    const buffer = await data.toBuffer();
    await writeFile(filepath, buffer);

    return { path: filepath };
  });
}
