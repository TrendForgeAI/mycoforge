"use client";

import { useState, useRef, useCallback } from "react";
import Sidebar from "./Sidebar/Sidebar";
import TerminalViewDynamic from "./Terminal/TerminalViewDynamic";
import { useTerminalSession } from "@/hooks/useTerminalSession";

interface Project {
  name: string;
  path: string;
}

export default function AppShell() {
  const [activeProject, setActiveProject] = useState<Project | null>(null);
  const injectTextRef = useRef<((text: string) => void) | null>(null);

  const { session } = useTerminalSession(activeProject?.path ?? null);

  const handleInjectRef = useCallback((fn: (text: string) => void) => {
    injectTextRef.current = fn;
  }, []);

  async function handleUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    e.target.value = "";

    const formData = new FormData();
    formData.append("file", file);

    try {
      const res = await fetch("/api/upload", { method: "POST", body: formData });
      if (!res.ok) {
        const err = await res.json() as { error?: string };
        alert(err.error ?? "Upload fehlgeschlagen");
        return;
      }
      const data = await res.json() as { path: string };
      // Pfad in PTY-stdin injizieren
      injectTextRef.current?.(data.path);
    } catch {
      alert("Upload fehlgeschlagen");
    }
  }

  return (
    <div className="flex h-full bg-bg">
      <Sidebar
        activeProject={activeProject?.path ?? null}
        onProjectSelect={setActiveProject}
      />
      <main className="flex-1 flex flex-col min-w-0">
        {/* Toolbar */}
        <div className="flex items-center gap-2 px-3 py-1.5 border-b border-border bg-surface flex-shrink-0">
          <span className="text-xs text-muted flex-1">
            {activeProject ? activeProject.name : "Workspace"}
          </span>
          <label
            className="text-xs text-muted hover:text-accent transition-colors cursor-pointer px-2 py-1 rounded hover:bg-accent/10"
            title="Bild hochladen und Pfad ins Terminal einfügen"
          >
            ⬆ Bild
            <input
              type="file"
              accept="image/*"
              className="hidden"
              onChange={handleUpload}
            />
          </label>
        </div>
        {/* Terminal */}
        <div className="flex-1 min-h-0">
          <TerminalViewDynamic
            sessionId={session?.id ?? null}
            onInjectRef={handleInjectRef}
          />
        </div>
      </main>
    </div>
  );
}
