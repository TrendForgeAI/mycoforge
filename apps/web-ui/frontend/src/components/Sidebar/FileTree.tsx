"use client";

import { useState, useEffect } from "react";

interface FileEntry {
  name: string;
  path: string;
  type: "file" | "directory";
}

interface Props {
  rootPath: string | null;
  onFileClick?: (path: string) => void;
}

function FileIcon({ type }: { type: string }) {
  return (
    <span className="text-muted mr-1.5 text-xs">
      {type === "directory" ? "▶" : "·"}
    </span>
  );
}

function FileNode({ entry, onFileClick }: { entry: FileEntry; onFileClick?: (path: string) => void }) {
  const [open, setOpen] = useState(false);
  const [children, setChildren] = useState<FileEntry[]>([]);

  async function toggle() {
    if (entry.type === "file") {
      onFileClick?.(entry.path);
      return;
    }
    if (!open && children.length === 0) {
      const res = await fetch(`/api/files?path=${encodeURIComponent(entry.path)}`);
      const data = await res.json() as { entries: FileEntry[] };
      setChildren(data.entries ?? []);
    }
    setOpen(!open);
  }

  return (
    <li>
      <button
        onClick={toggle}
        className="flex items-center w-full text-left py-0.5 text-xs text-text hover:text-accent transition-colors"
      >
        <FileIcon type={entry.type} />
        <span className="truncate">{entry.name}</span>
      </button>
      {open && children.length > 0 && (
        <ul className="pl-4 border-l border-border ml-1.5">
          {children.map((c) => (
            <FileNode key={c.path} entry={c} onFileClick={onFileClick} />
          ))}
        </ul>
      )}
    </li>
  );
}

export default function FileTree({ rootPath, onFileClick }: Props) {
  const [entries, setEntries] = useState<FileEntry[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!rootPath) return;
    setLoading(true);
    fetch(`/api/files?path=${encodeURIComponent(rootPath)}`)
      .then((r) => r.json())
      .then((d: { entries: FileEntry[] }) => setEntries(d.entries ?? []))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, [rootPath]);

  if (!rootPath) return <div className="text-xs text-muted px-2">Kein Projekt gewählt</div>;
  if (loading) return <div className="text-xs text-muted px-2">Laden…</div>;

  return (
    <div>
      <div className="text-xs font-semibold uppercase tracking-wider text-muted mb-2">
        Dateien
      </div>
      <ul className="space-y-0">
        {entries.map((e) => (
          <FileNode key={e.path} entry={e} onFileClick={onFileClick} />
        ))}
      </ul>
    </div>
  );
}
