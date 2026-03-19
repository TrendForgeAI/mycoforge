"use client";

import { useState, useEffect } from "react";
import hljs from "highlight.js/lib/core";
import typescript from "highlight.js/lib/languages/typescript";
import javascript from "highlight.js/lib/languages/javascript";
import python from "highlight.js/lib/languages/python";
import bash from "highlight.js/lib/languages/bash";
import json from "highlight.js/lib/languages/json";
import yaml from "highlight.js/lib/languages/yaml";
import markdown from "highlight.js/lib/languages/markdown";
import css from "highlight.js/lib/languages/css";

hljs.registerLanguage("typescript", typescript);
hljs.registerLanguage("javascript", javascript);
hljs.registerLanguage("python", python);
hljs.registerLanguage("bash", bash);
hljs.registerLanguage("json", json);
hljs.registerLanguage("yaml", yaml);
hljs.registerLanguage("markdown", markdown);
hljs.registerLanguage("css", css);

const EXT_TO_LANG: Record<string, string> = {
  ts: "typescript", tsx: "typescript",
  js: "javascript", jsx: "javascript",
  py: "python",
  sh: "bash", bash: "bash",
  json: "json",
  yaml: "yaml", yml: "yaml",
  md: "markdown",
  css: "css",
};

function getLanguage(filename: string): string | undefined {
  const ext = filename.split(".").pop()?.toLowerCase() ?? "";
  return EXT_TO_LANG[ext];
}

function highlightCode(code: string, filename: string): string {
  const lang = getLanguage(filename);
  if (lang && hljs.getLanguage(lang)) {
    return hljs.highlight(code, { language: lang }).value;
  }
  return hljs.highlightAuto(code).value;
}

interface Props {
  path: string;
  onClose: () => void;
}

export default function FileViewer({ path, onClose }: Props) {
  const [content, setContent] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editContent, setEditContent] = useState("");
  const [isDirty, setIsDirty] = useState(false);
  const [saving, setSaving] = useState(false);

  const filename = path.split("/").pop() ?? path;

  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") onClose();
    }
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, [onClose]);

  useEffect(() => {
    setContent(null);
    setError(null);
    setIsEditing(false);
    setIsDirty(false);
    fetch(`/api/files/content?path=${encodeURIComponent(path)}`)
      .then(async (r) => {
        const d = await r.json() as { content?: string; error?: string };
        if (!r.ok) throw new Error(d.error ?? "Fehler beim Laden");
        setContent(d.content ?? "");
      })
      .catch((e: Error) => setError(e.message));
  }, [path]);

  function startEdit() {
    setEditContent(content ?? "");
    setIsEditing(true);
    setIsDirty(false);
  }

  function handleChange(val: string) {
    setEditContent(val);
    setIsDirty(val !== content);
  }

  async function save() {
    setSaving(true);
    try {
      const r = await fetch("/api/files/content", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ path, content: editContent }),
      });
      if (!r.ok) {
        const d = await r.json() as { error?: string };
        throw new Error(d.error ?? "Fehler beim Speichern");
      }
      setContent(editContent);
      setIsDirty(false);
    } catch (e) {
      alert(e instanceof Error ? e.message : "Fehler beim Speichern");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="absolute inset-0 z-10 bg-bg flex flex-col">
      {/* Top bar */}
      <div className="flex items-center gap-2 px-3 py-1.5 border-b border-border bg-surface flex-shrink-0">
        <span className="text-xs text-text flex-1 truncate font-mono">{filename}</span>
        {!isEditing && (
          <button
            onClick={startEdit}
            className="text-xs text-muted hover:text-accent transition-colors px-2 py-1 rounded hover:bg-accent/10"
          >
            Bearbeiten
          </button>
        )}
        {isEditing && isDirty && (
          <button
            onClick={save}
            disabled={saving}
            className="text-xs text-accent hover:text-accent/80 transition-colors px-2 py-1 rounded hover:bg-accent/10 disabled:opacity-50"
          >
            {saving ? "Speichert…" : "Speichern"}
          </button>
        )}
        <button
          onClick={onClose}
          className="text-xs text-muted hover:text-text transition-colors px-2 py-1 rounded hover:bg-accent/10"
          title="Schließen (ESC)"
        >
          ✕
        </button>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-auto min-h-0">
        {error && (
          <div className="p-4 text-xs text-red-400">{error}</div>
        )}
        {content === null && !error && (
          <div className="p-4 text-xs text-muted">Laden…</div>
        )}
        {content !== null && !isEditing && (
          <pre className="p-4 text-xs leading-relaxed m-0">
            <code
              className="hljs"
              dangerouslySetInnerHTML={{ __html: highlightCode(content, filename) }}
            />
          </pre>
        )}
        {isEditing && (
          <textarea
            className="w-full h-full p-4 bg-bg text-text text-xs font-mono leading-relaxed resize-none outline-none border-none block"
            value={editContent}
            onChange={(e) => handleChange(e.target.value)}
            spellCheck={false}
            autoFocus
          />
        )}
      </div>
    </div>
  );
}
