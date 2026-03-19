"use client";

import type { WsStatus } from "@/hooks/useWebSocket";

interface Props {
  projectName: string | null;
  wsStatus: WsStatus;
}

const statusLabel: Record<WsStatus, string> = {
  connecting: "Verbinde…",
  connected: "Verbunden",
  disconnected: "Getrennt",
};

const statusColor: Record<WsStatus, string> = {
  connecting: "text-yellow-500",
  connected: "text-green-500",
  disconnected: "text-red-500",
};

export default function StatusBar({ projectName, wsStatus }: Props) {
  return (
    <div className="flex items-center gap-3 px-4 py-1.5 border-b border-border bg-surface text-xs text-muted">
      <span>{projectName ?? "Kein Projekt"}</span>
      <span className="text-border">|</span>
      <span className={statusColor[wsStatus]}>{statusLabel[wsStatus]}</span>
    </div>
  );
}
