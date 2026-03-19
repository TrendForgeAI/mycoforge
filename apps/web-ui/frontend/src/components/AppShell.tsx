"use client";

import { useState } from "react";
import Sidebar from "./Sidebar/Sidebar";
import ChatView from "./Chat/ChatView";

interface Project {
  name: string;
  path: string;
}

export default function AppShell() {
  const [activeProject, setActiveProject] = useState<Project | null>(null);

  return (
    <div className="flex h-full bg-bg">
      <Sidebar
        activeProject={activeProject?.path ?? null}
        onProjectSelect={setActiveProject}
      />
      <main className="flex-1 flex flex-col min-w-0">
        <ChatView
          projectPath={activeProject?.path ?? null}
          projectName={activeProject?.name ?? null}
        />
      </main>
    </div>
  );
}
