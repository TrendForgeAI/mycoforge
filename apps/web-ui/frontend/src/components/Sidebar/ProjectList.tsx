"use client";

import { useState } from "react";

interface Project {
  name: string;
  path: string;
}

interface Props {
  projects: Project[];
  activeProject: string | null;
  onSelect: (project: Project) => void;
  onProjectCreated: (project: Project) => void;
}

export default function ProjectList({ projects, activeProject, onSelect, onProjectCreated }: Props) {
  const [creating, setCreating] = useState(false);
  const [newName, setNewName] = useState("");
  const [error, setError] = useState<string | null>(null);

  async function handleCreate() {
    const name = newName.trim();
    if (!name) return;
    setError(null);
    try {
      const res = await fetch("/api/projects", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name }),
      });
      const data = await res.json() as { project?: Project; error?: string };
      if (!res.ok) {
        setError(data.error ?? "Fehler beim Anlegen");
        return;
      }
      setCreating(false);
      setNewName("");
      if (data.project) onProjectCreated(data.project);
    } catch {
      setError("Verbindungsfehler");
    }
  }

  function handleKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === "Enter") handleCreate();
    if (e.key === "Escape") { setCreating(false); setNewName(""); setError(null); }
  }

  return (
    <div className="mb-4">
      <div className="flex items-center justify-between text-xs font-semibold uppercase tracking-wider text-muted mb-2">
        <span>Projekte</span>
        <button
          onClick={() => { setCreating(true); setError(null); }}
          className="text-muted hover:text-accent transition-colors leading-none"
          title="Neues Projekt anlegen"
        >
          +
        </button>
      </div>

      {creating && (
        <div className="mb-1.5">
          <input
            autoFocus
            value={newName}
            onChange={(e) => setNewName(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="projektname (enter / esc)"
            className="w-full bg-bg border border-accent rounded px-2 py-1 text-sm text-text placeholder-muted focus:outline-none"
          />
          {error && <p className="text-xs text-red-400 mt-0.5 px-1">{error}</p>}
        </div>
      )}

      <ul className="space-y-0.5">
        {projects.map((p) => (
          <li key={p.path}>
            <button
              onClick={() => onSelect(p)}
              className={`w-full text-left px-2 py-1.5 rounded text-sm truncate transition-colors ${
                activeProject === p.path
                  ? "bg-accent/20 text-accent"
                  : "text-text hover:bg-surface hover:text-text"
              }`}
            >
              {p.name}
            </button>
          </li>
        ))}
        {projects.length === 0 && !creating && (
          <li className="text-xs text-muted px-2 py-1">Keine Projekte — + zum Anlegen</li>
        )}
      </ul>
    </div>
  );
}
