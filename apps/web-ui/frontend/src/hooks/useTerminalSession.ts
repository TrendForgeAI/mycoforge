"use client";

import { useState, useEffect, useRef } from "react";

export interface TerminalSession {
  id: string;
  cwd: string;
}

function storageKey(cwd: string) {
  return `mycoforge-terminal:${cwd}`;
}

export function useTerminalSession(projectPath: string | null) {
  const effectivePath = projectPath ?? "/workspace";
  const [session, setSession] = useState<TerminalSession | null>(null);
  const [loading, setLoading] = useState(false);
  const prevPath = useRef<string | null>(null);

  useEffect(() => {
    // Neue Session bei Projektwechsel (nie cd-Inject in laufenden Prozess)
    if (prevPath.current === effectivePath) return;
    prevPath.current = effectivePath;

    const stored = localStorage.getItem(storageKey(effectivePath));
    if (stored) {
      try {
        const parsed = JSON.parse(stored) as TerminalSession;
        // Prüfen ob Session noch existiert
        fetch(`/api/terminal/${parsed.id}`, { method: "HEAD" })
          .then((r) => {
            if (r.ok) {
              setSession(parsed);
            } else {
              localStorage.removeItem(storageKey(effectivePath));
              createSession(effectivePath);
            }
          })
          .catch(() => createSession(effectivePath));
        return;
      } catch { /* ignorieren */ }
    }
    createSession(effectivePath);
  }, [effectivePath]);

  async function createSession(cwd: string) {
    setLoading(true);
    try {
      const res = await fetch("/api/terminal", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ cwd }),
      });
      if (!res.ok) throw new Error("Session konnte nicht erstellt werden");
      const data = await res.json() as { id: string; cwd: string };
      const newSession: TerminalSession = { id: data.id, cwd: data.cwd };
      setSession(newSession);
      localStorage.setItem(storageKey(cwd), JSON.stringify(newSession));
    } catch (e) {
      console.error("Terminal session error:", e);
    } finally {
      setLoading(false);
    }
  }

  function resetSession() {
    localStorage.removeItem(storageKey(effectivePath));
    setSession(null);
    createSession(effectivePath);
  }

  return { session, loading, resetSession };
}
