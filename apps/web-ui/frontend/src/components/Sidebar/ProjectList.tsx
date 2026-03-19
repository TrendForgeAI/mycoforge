"use client";

interface Project {
  name: string;
  path: string;
}

interface Props {
  projects: Project[];
  activeProject: string | null;
  onSelect: (project: Project) => void;
}

export default function ProjectList({ projects, activeProject, onSelect }: Props) {
  return (
    <div className="mb-4">
      <div className="text-xs font-semibold uppercase tracking-wider text-muted mb-2">
        Projekte
      </div>
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
        {projects.length === 0 && (
          <li className="text-xs text-muted px-2 py-1">Keine Projekte</li>
        )}
      </ul>
    </div>
  );
}
