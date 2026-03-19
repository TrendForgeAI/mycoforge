"use client";

import { useEffect, useRef, useState, useCallback } from "react";

export type WsStatus = "connecting" | "connected" | "disconnected";

export interface WsMessage {
  type: "token" | "tool_call" | "tool_result" | "done" | "error";
  text?: string;
  toolName?: string;
  toolInput?: unknown;
  toolId?: string;
  claudeSessionId?: string;
  totalCostUsd?: number;
  error?: string;
}

export function useWebSocket(sessionId: string | null) {
  const wsRef = useRef<WebSocket | null>(null);
  const [status, setStatus] = useState<WsStatus>("disconnected");
  const [lastMessage, setLastMessage] = useState<WsMessage | null>(null);
  const reconnectAttempts = useRef(0);
  const maxReconnects = 3;
  const sessionGoneRef = useRef(false);

  const connect = useCallback(() => {
    if (!sessionId) return;

    sessionGoneRef.current = false;
    const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
    const host = window.location.host;
    const url = `${protocol}//${host}/ws/sessions/${sessionId}/stream`;

    setStatus("connecting");
    const ws = new WebSocket(url);
    wsRef.current = ws;

    ws.onopen = () => {
      setStatus("connected");
      reconnectAttempts.current = 0;
    };

    ws.onmessage = (event) => {
      try {
        const msg = JSON.parse(event.data as string) as WsMessage;
        if (msg.type === "error" && msg.error === "Session nicht gefunden") {
          sessionGoneRef.current = true;
        }
        setLastMessage(msg);
      } catch {
        console.error("WS: Ungültiges JSON", event.data);
      }
    };

    ws.onclose = () => {
      setStatus("disconnected");
      if (!sessionGoneRef.current && reconnectAttempts.current < maxReconnects) {
        reconnectAttempts.current++;
        const delay = Math.min(1000 * 2 ** reconnectAttempts.current, 10000);
        setTimeout(connect, delay);
      }
    };

    ws.onerror = (err) => {
      console.error("WebSocket Fehler:", err);
    };
  }, [sessionId]);

  useEffect(() => {
    connect();
    return () => {
      wsRef.current?.close();
    };
  }, [connect]);

  const send = useCallback((message: string) => {
    if (wsRef.current?.readyState === WebSocket.OPEN) {
      wsRef.current.send(JSON.stringify({ message }));
    }
  }, []);

  return { status, lastMessage, send };
}
