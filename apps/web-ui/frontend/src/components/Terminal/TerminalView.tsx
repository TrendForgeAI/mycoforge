"use client";

import { useEffect, useRef, useCallback, useState } from "react";
import { Terminal } from "@xterm/xterm";
import { FitAddon } from "@xterm/addon-fit";
import "@xterm/xterm/css/xterm.css";

interface Props {
  sessionId: string | null;
  onInjectRef?: (fn: (text: string) => void) => void;
}

const WS_RECONNECT_DELAY = 2000;

export default function TerminalView({ sessionId, onInjectRef }: Props) {
  const containerRef = useRef<HTMLDivElement>(null);
  const termRef = useRef<Terminal | null>(null);
  const fitRef = useRef<FitAddon | null>(null);
  const wsRef = useRef<WebSocket | null>(null);
  const [status, setStatus] = useState<"connecting" | "connected" | "disconnected">("disconnected");

  const injectText = useCallback((text: string) => {
    wsRef.current?.send(JSON.stringify({ type: "input", data: text }));
  }, []);

  // Ref-Callback nach außen geben (für Upload-Button, Quick-Actions)
  useEffect(() => {
    onInjectRef?.(injectText);
  }, [injectText, onInjectRef]);

  useEffect(() => {
    if (!containerRef.current || !sessionId) return;

    // Terminal initialisieren
    const term = new Terminal({
      theme: {
        background: "#0d1117",
        foreground: "#e6edf3",
        cursor: "#58a6ff",
        selectionBackground: "#58a6ff44",
        black: "#0d1117",
        brightBlack: "#8b949e",
        blue: "#58a6ff",
        brightBlue: "#79c0ff",
        cyan: "#39d353",
        green: "#3fb950",
        red: "#ff7b72",
        yellow: "#d29922",
        white: "#e6edf3",
        brightWhite: "#ffffff",
      },
      fontFamily: 'ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, monospace',
      fontSize: 13,
      lineHeight: 1.4,
      cursorBlink: true,
      scrollback: 5000,
    });

    const fitAddon = new FitAddon();
    term.loadAddon(fitAddon);
    term.open(containerRef.current);
    fitAddon.fit();

    termRef.current = term;
    fitRef.current = fitAddon;

    // WebSocket verbinden
    const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
    const ws = new WebSocket(`${protocol}//${window.location.host}/ws/terminal/${sessionId}/stream`);
    wsRef.current = ws;

    ws.onopen = () => {
      setStatus("connected");
      // Initiale Größe senden
      const { cols, rows } = term;
      ws.send(JSON.stringify({ type: "resize", cols, rows }));
    };

    ws.onmessage = (e) => {
      // Roher PTY-Output: direkt ans Terminal
      if (typeof e.data === "string") {
        // Session-nicht-gefunden Fehler abfangen
        if (e.data.startsWith('{"type":"error"')) {
          try {
            const msg = JSON.parse(e.data) as { type: string; error?: string };
            if (msg.error) term.writeln(`\r\n\x1b[31mFehler: ${msg.error}\x1b[0m`);
            return;
          } catch { /* kein JSON */ }
        }
        term.write(e.data);
      }
    };

    ws.onclose = () => {
      setStatus("disconnected");
      term.writeln("\r\n\x1b[33m[Verbindung getrennt — Seite neu laden zum Reconnecten]\x1b[0m");
    };

    ws.onerror = () => setStatus("disconnected");

    // Tastatureingaben → WebSocket
    term.onData((data) => {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify({ type: "input", data }));
      }
    });

    // Terminal-Resize → Backend
    const resizeObserver = new ResizeObserver(() => {
      fitAddon.fit();
      const { cols, rows } = term;
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify({ type: "resize", cols, rows }));
      }
    });
    resizeObserver.observe(containerRef.current);

    setStatus("connecting");

    return () => {
      resizeObserver.disconnect();
      ws.close();
      term.dispose();
      wsRef.current = null;
      termRef.current = null;
    };
  }, [sessionId]);

  return (
    <div className="flex flex-col h-full">
      <div className="flex items-center gap-3 px-4 py-1.5 border-b border-border bg-surface text-xs text-muted flex-shrink-0">
        <span className="text-accent font-semibold">Terminal</span>
        <span className="text-border">|</span>
        <span className={
          status === "connected" ? "text-green-500" :
          status === "connecting" ? "text-yellow-500" : "text-red-500"
        }>
          {status === "connected" ? "Verbunden" : status === "connecting" ? "Verbinde…" : "Getrennt"}
        </span>
      </div>
      <div ref={containerRef} className="flex-1 overflow-hidden p-2" />
    </div>
  );
}
