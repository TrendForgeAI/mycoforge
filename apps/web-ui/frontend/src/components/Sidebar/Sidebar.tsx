"use client";

import { useState, useEffect } from "react";
import ProjectList from "./ProjectList";
import FileTree from "./FileTree";

interface Project {
  name: string;
  displayName: string;
  path: string;
}

interface Props {
  activeProject: string | null;
  onProjectSelect: (project: Project) => void;
  onNewProject: () => void;
}

export default function Sidebar({ activeProject, onProjectSelect, onNewProject }: Props) {
  const [projects, setProjects] = useState<Project[]>([]);

  useEffect(() => {
    const fetchProjects = async () => {
      try {
        const r = await fetch("/api/projects");
        const d = await r.json() as { projects: Project[] };
        const next = d.projects ?? [];
        setProjects((prev) => {
          const prevKey = prev.map((p) => `${p.name}:${p.displayName}`).join(",");
          const nextKey = next.map((p) => `${p.name}:${p.displayName}`).join(",");
          return prevKey === nextKey ? prev : next;
        });
      } catch { /* ignorieren */ }
    };

    fetchProjects();
    const interval = setInterval(fetchProjects, 10_000);
    return () => clearInterval(interval);
  }, []);

  return (
    <aside className="w-64 flex-shrink-0 bg-surface border-r border-border flex flex-col overflow-hidden">
      <div className="px-4 py-4 border-b border-border flex items-center justify-center">
        <span className="text-2xl font-bold tracking-tight text-accent">mycoforge</span>
      </div>
      <div className="flex-1 overflow-y-auto p-3">
        <ProjectList
          projects={projects}
          activeProject={activeProject}
          onSelect={onProjectSelect}
          onNewProject={onNewProject}
        />
        <hr className="border-border my-3" />
        <FileTree rootPath={activeProject} />
      </div>
    </aside>
  );
}
