import Fastify from "fastify";
import fastifyWebsocket from "@fastify/websocket";
import fastifyCors from "@fastify/cors";
import { healthRoutes } from "./routes/health.js";
import { projectRoutes } from "./routes/projects.js";
import { fileRoutes } from "./routes/files.js";
import { sessionRoutes } from "./routes/sessions.js";
import { sessionStore } from "./session-store.js";

const fastify = Fastify({
  logger: {
    transport: {
      target: "pino-pretty",
      options: { colorize: true },
    },
  },
});

// Plugins
await fastify.register(fastifyWebsocket);
await fastify.register(fastifyCors, {
  origin: ["http://localhost:3000"],
  methods: ["GET", "POST", "DELETE"],
});

// Routes
await fastify.register(healthRoutes);
await fastify.register(projectRoutes);
await fastify.register(fileRoutes);
await fastify.register(sessionRoutes);

// Session-Cleanup alle 30 Minuten
setInterval(() => sessionStore.cleanup(), 30 * 60 * 1000);

// Start
try {
  await fastify.listen({ port: 3001, host: "0.0.0.0" });
  console.log("mycoforge web-ui backend läuft auf http://0.0.0.0:3001");
} catch (err) {
  fastify.log.error(err);
  process.exit(1);
}
