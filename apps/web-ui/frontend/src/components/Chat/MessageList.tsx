"use client";

import { useEffect, useRef } from "react";
import Message, { type ChatMessage } from "./Message";

interface Props {
  messages: ChatMessage[];
}

export default function MessageList({ messages }: Props) {
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  return (
    <div className="flex-1 overflow-y-auto p-4">
      {messages.length === 0 && (
        <div className="flex h-full items-center justify-center text-muted text-sm">
          Wähle ein Projekt und starte einen Chat mit Claude.
        </div>
      )}
      {messages.map((msg) => (
        <Message key={msg.id} message={msg} />
      ))}
      <div ref={bottomRef} />
    </div>
  );
}
