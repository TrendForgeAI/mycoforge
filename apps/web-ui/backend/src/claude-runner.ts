import { spawn } from "node:child_process";

export type ClaudeEventType = "token" | "tool_call" | "tool_result" | "done" | "error";

export interface ClaudeEvent {
  type: ClaudeEventType;
  // token: partial text chunk
  text?: string;
  // tool_call: tool wurde aufgerufen
  toolName?: string;
  toolInput?: unknown;
  toolId?: string;
  // done: session_id für nächsten Turn
  claudeSessionId?: string;
  totalCostUsd?: number;
  // error: Fehlermeldung
  error?: string;
}

interface RunOptions {
  message: string;
  cwd: string;
  claudeSessionId?: string; // undefined = erster Turn
  onEvent: (event: ClaudeEvent) => void;
  onDone: (claudeSessionId: string) => void;
  onError: (error: string) => void;
}

export function runClaude(options: RunOptions): () => void {
  const { message, cwd, claudeSessionId, onEvent, onDone, onError } = options;

  const args = [
    "--print",
    "--output-format", "stream-json",
    "--verbose",
    "--include-partial-messages",
  ];

  if (claudeSessionId) {
    args.push("--resume", claudeSessionId);
  }

  // Message wird über -p übergeben (nicht als Argument um Escaping-Probleme zu vermeiden)
  const proc = spawn("claude", [...args, "-p", message], {
    cwd,
    stdio: ["ignore", "pipe", "pipe"],
    env: { ...process.env },
  });

  let buffer = "";

  proc.stdout.on("data", (chunk: Buffer) => {
    buffer += chunk.toString("utf8");
    const lines = buffer.split("\n");
    buffer = lines.pop() ?? ""; // letztes unfertiges Element zurückbehalten

    for (const line of lines) {
      if (!line.trim()) continue;
      try {
        const event = JSON.parse(line);
        processNdjsonEvent(event, onEvent, onDone);
      } catch {
        // Nicht-JSON Zeile ignorieren (z.B. leere Zeilen)
      }
    }
  });

  proc.stderr.on("data", (chunk: Buffer) => {
    // stderr von claude sind oft nur Warnungen, nicht fatale Fehler
    const msg = chunk.toString("utf8").trim();
    if (msg) console.error("[claude stderr]", msg);
  });

  proc.on("close", (code) => {
    // Restlichen Buffer verarbeiten
    if (buffer.trim()) {
      try {
        const event = JSON.parse(buffer);
        processNdjsonEvent(event, onEvent, onDone);
      } catch { /* ignorieren */ }
    }
    if (code !== 0) {
      onError(`claude exited with code ${code}`);
    }
  });

  proc.on("error", (err) => {
    onError(`Fehler beim Starten von claude: ${err.message}`);
  });

  // Gibt eine Funktion zum Abbrechen zurück
  return () => proc.kill("SIGTERM");
}

function processNdjsonEvent(
  event: Record<string, unknown>,
  onEvent: (e: ClaudeEvent) => void,
  onDone: (claudeSessionId: string) => void,
): void {
  if (event.type === "stream_event") {
    const se = event.event as Record<string, unknown>;
    if (se?.type === "content_block_delta") {
      const delta = se.delta as Record<string, unknown>;
      // Text-Token (text_delta)
      if (delta?.type === "text_delta" && typeof delta.text === "string") {
        onEvent({ type: "token", text: delta.text });
      }
    }
  } else if (event.type === "assistant") {
    const msg = event.message as Record<string, unknown>;
    const content = msg?.content as Array<Record<string, unknown>>;
    if (Array.isArray(content)) {
      for (const block of content) {
        if (block.type === "tool_use") {
          onEvent({
            type: "tool_call",
            toolName: block.name as string,
            toolInput: block.input,
            toolId: block.id as string,
          });
        }
      }
    }
  } else if (event.type === "result") {
    onEvent({
      type: "done",
      claudeSessionId: event.session_id as string,
      totalCostUsd: event.total_cost_usd as number,
    });
    if (typeof event.session_id === "string") {
      onDone(event.session_id);
    }
  }
}
