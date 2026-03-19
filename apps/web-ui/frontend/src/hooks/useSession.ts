"use client";

import { useState, useEffect } from "react";

export interface Session {
  sessionId: string;
  cwd: string;
}

// cwd-spezifischer Storage-Key verhindert falsche Session-Wiederverwendung bei Projektwechsel
function storageKey(cwd: string) {
  return `mycoforge-session:${cwd}`;
}

export function useSession(projectPath: string | null) {
  // Kein Projekt gewählt → /workspace als Default-Kontext
  const effectivePath = projectPath ?? "/workspace";

  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const key = storageKey(effectivePath);
    const stored = localStorage.getItem(key);
    if (stored) {
      try {
        const parsed = JSON.parse(stored) as Session;
        if (parsed.cwd === effectivePath) {
          setSession(parsed);
          return;
        }
      } catch { /* ignorieren */ }
    }
    createSession(effectivePath);
  }, [effectivePath]);

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
      localStorage.setItem(storageKey(cwd), JSON.stringify(data.session));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Unbekannter Fehler");
    } finally {
      setLoading(false);
    }
  }

  function resetSession() {
    localStorage.removeItem(storageKey(effectivePath));
    setSession(null);
    createSession(effectivePath);
  }

  return { session, loading, error, createSession, resetSession };
}
