"use client";

import { useState } from "react";

interface Props {
  toolName: string;
  toolInput: unknown;
}

export default function ToolCallBlock({ toolName, toolInput }: Props) {
  const [open, setOpen] = useState(false);

  return (
    <div className="my-1 border border-border rounded text-xs">
      <button
        onClick={() => setOpen(!open)}
        className="flex items-center gap-2 w-full px-3 py-1.5 text-left text-muted hover:text-text transition-colors"
      >
        <span className="text-accent">⚙</span>
        <span className="font-mono">{toolName}</span>
        <span className="ml-auto">{open ? "▲" : "▼"}</span>
      </button>
      {open && (
        <div className="border-t border-border px-3 py-2 bg-bg rounded-b">
          <pre className="text-muted whitespace-pre-wrap break-all text-xs overflow-x-auto">
            {JSON.stringify(toolInput, null, 2)}
          </pre>
        </div>
      )}
    </div>
  );
}
