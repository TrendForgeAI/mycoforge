"use client";

import { useState } from "react";

interface Project {
  name: string;
  displayName: string;
  path: string;
}

interface Props {
  projects: Project[];
  activeProject: string | null;
  onSelect: (project: Project) => void;
  onProjectCreated: (project: Project) => void;
}

function toSlug(displayName: string): string {
  return displayName
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // Akzente entfernen
    .replace(/[^a-z0-9]+/g, "-")     // Sonderzeichen → Bindestrich
    .replace(/^-+|-+$/g, "")         // führende/trailing Bindestriche entfernen
    .slice(0, 64)                     // Längenbegrenzung
    .replace(/-+$/, "")              // trailing Bindestrich nach slice entfernen
    || "projekt";
}

export default function ProjectList({ projects, activeProject, onSelect, onProjectCreated }: Props) {
  const [creating, setCreating] = useState(false);
  const [displayName, setDisplayName] = useState("");
  const [dirName, setDirName] = useState("");
  const [dirEdited, setDirEdited] = useState(false);
  const [error, setError] = useState<string | null>(null);

  function handleDisplayNameChange(value: string) {
    setDisplayName(value);
    if (!dirEdited) {
      setDirName(toSlug(value));
    }
  }

  function handleDirNameChange(value: string) {
    setDirName(value);
    setDirEdited(true);
  }

  function openForm() {
    setCreating(true);
    setDisplayName("");
    setDirName("");
    setDirEdited(false);
    setError(null);
  }

  function cancel() {
    setCreating(false);
    setDisplayName("");
    setDirName("");
    setDirEdited(false);
    setError(null);
  }

  async function handleCreate() {
    const trimmedDisplay = displayName.trim();
    const trimmedDir = dirName.trim();
    if (!trimmedDisplay || !trimmedDir) return;
    setError(null);
    try {
      const res = await fetch("/api/projects", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ displayName: trimmedDisplay, name: trimmedDir }),
      });
      const data = await res.json() as { project?: Project; error?: string };
      if (!res.ok) {
        setError(data.error ?? "Fehler beim Anlegen");
        return;
      }
      cancel();
      if (data.project) onProjectCreated(data.project);
    } catch {
      setError("Verbindungsfehler");
    }
  }

  function handleKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === "Enter") handleCreate();
    if (e.key === "Escape") cancel();
  }

  const dirValid = /^[a-z0-9][a-z0-9-_]*$/.test(dirName);

  return (
    <div className="mb-4">
      <hr className="border-border mb-3" />
      <div className="flex items-center justify-between text-xs font-semibold uppercase tracking-wider text-muted mb-2">
        <span>Projekte</span>
        <button
          onClick={openForm}
          className="w-5 h-5 flex items-center justify-center rounded text-muted hover:text-accent hover:bg-accent/10 transition-colors text-base leading-none"
          title="Neues Projekt anlegen"
        >
          +
        </button>
      </div>

      {creating && (
        <div className="mb-3 space-y-1.5">
          <input
            autoFocus
            value={displayName}
            onChange={(e) => handleDisplayNameChange(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="Lesbarer Name (z. B. Mein Projekt)"
            className="w-full bg-bg border border-accent rounded px-2 py-1 text-sm text-text placeholder-muted focus:outline-none"
          />
          <div>
            <div className="flex items-center gap-1">
              <span className="text-xs text-muted shrink-0">Verzeichnis:</span>
              <input
                value={dirName}
                onChange={(e) => handleDirNameChange(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder="verzeichnis-name"
                className={`flex-1 min-w-0 bg-bg border rounded px-2 py-0.5 text-xs text-text placeholder-muted focus:outline-none ${
                  dirName && !dirValid ? "border-red-400" : "border-border"
                }`}
              />
            </div>
            {dirName && !dirValid && (
              <p className="text-xs text-red-400 mt-0.5 px-1">
                Nur a–z, 0–9, Bindestrich, Unterstrich
              </p>
            )}
          </div>
          {error && <p className="text-xs text-red-400 px-1">{error}</p>}
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
              {p.displayName}
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
