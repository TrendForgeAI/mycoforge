"use client";

interface Project {
  name: string;
  displayName: string;
  path: string;
}

interface Props {
  projects: Project[];
  activeProject: string | null;
  onSelect: (project: Project) => void;
  onNewProject: () => void;
}

export default function ProjectList({ projects, activeProject, onSelect, onNewProject }: Props) {
  return (
    <div className="mb-4">
      <div className="flex items-center justify-between text-xs font-semibold uppercase tracking-wider text-muted mb-2">
        <span>Projekte</span>
        <button
          onClick={onNewProject}
          className="w-5 h-5 flex items-center justify-center rounded text-muted hover:text-accent hover:bg-accent/10 transition-colors text-base leading-none"
          title="Neues Projekt anlegen"
        >
          +
        </button>
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
              {p.displayName}
            </button>
          </li>
        ))}
        {projects.length === 0 && (
          <li className="text-xs text-muted px-2 py-1">Keine Projekte — + zum Anlegen</li>
        )}
      </ul>
    </div>
  );
}
