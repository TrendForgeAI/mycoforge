"use client";

import { useState, useEffect } from "react";

export interface Session {
  sessionId: string;
  cwd: string;
}

const STORAGE_KEY = "mycoforge-session";

export function useSession(projectPath: string | null) {
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!projectPath) return;
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      try {
        const parsed = JSON.parse(stored) as Session;
        if (parsed.cwd === projectPath) {
          setSession(parsed);
          return;
        }
      } catch { /* ignorieren */ }
    }
    // Neue Session anlegen
    createSession(projectPath);
  }, [projectPath]);

  async function createSession(cwd: string) {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/sessions", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ cwd }),
      });
      if (!res.ok) throw new Error("Session konnte nicht erstellt werden");
      const data = await res.json() as { session: Session };
      setSession(data.session);
      localStorage.setItem(STORAGE_KEY, JSON.stringify(data.session));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Unbekannter Fehler");
    } finally {
      setLoading(false);
    }
  }

  return { session, loading, error, createSession };
}
