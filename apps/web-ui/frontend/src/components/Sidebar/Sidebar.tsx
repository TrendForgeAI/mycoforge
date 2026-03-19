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
}

export default function Sidebar({ activeProject, onProjectSelect }: Props) {
  const [projects, setProjects] = useState<Project[]>([]);

  useEffect(() => {
    fetch("/api/projects")
      .then((r) => r.json())
      .then((d: { projects: Project[] }) => setProjects(d.projects ?? []))
      .catch(console.error);
  }, []);

  function handleProjectCreated(project: Project) {
    setProjects((prev) => [...prev, project]);
    onProjectSelect(project);
  }

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
          onProjectCreated={handleProjectCreated}
        />
        <hr className="border-border my-3" />
        <FileTree rootPath={activeProject} />
      </div>
    </aside>
  );
}
