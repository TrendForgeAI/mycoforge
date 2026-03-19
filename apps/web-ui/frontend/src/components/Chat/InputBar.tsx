"use client";

import { useState, useRef, type KeyboardEvent } from "react";

interface Props {
  onSend: (message: string) => void;
  disabled: boolean;
  placeholder?: string;
}

export default function InputBar({ onSend, disabled, placeholder }: Props) {
  const [value, setValue] = useState("");
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  function handleSend() {
    const msg = value.trim();
    if (!msg || disabled) return;
    onSend(msg);
    setValue("");
    if (textareaRef.current) {
      textareaRef.current.style.height = "auto";
    }
  }

  function handleKeyDown(e: KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  }

  function handleInput() {
    const el = textareaRef.current;
    if (!el) return;
    el.style.height = "auto";
    el.style.height = `${Math.min(el.scrollHeight, 200)}px`;
  }

  return (
    <div className="border-t border-border p-3 bg-surface">
      <div className="flex gap-2 items-end">
        <textarea
          ref={textareaRef}
          value={value}
          onChange={(e) => setValue(e.target.value)}
          onKeyDown={handleKeyDown}
          onInput={handleInput}
          disabled={disabled}
          placeholder={placeholder ?? "Nachricht an Claude… (Enter = Senden, Shift+Enter = Zeile)"}
          rows={1}
          className="flex-1 bg-bg border border-border rounded-lg px-3 py-2 text-sm text-text placeholder-muted resize-none focus:outline-none focus:border-accent transition-colors disabled:opacity-50"
          style={{ minHeight: "40px", maxHeight: "200px" }}
        />
        <button
          onClick={handleSend}
          disabled={disabled || !value.trim()}
          className="w-9 h-9 flex-shrink-0 rounded-lg bg-accent text-bg flex items-center justify-center font-bold text-sm hover:bg-accent/80 transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
          aria-label="Senden"
        >
          ▶
        </button>
      </div>
    </div>
  );
}
