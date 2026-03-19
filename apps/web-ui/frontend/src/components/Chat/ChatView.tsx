"use client";

import { useState, useEffect, useCallback } from "react";
import MessageList from "./MessageList";
import InputBar from "./InputBar";
import StatusBar from "./StatusBar";
import { useWebSocket } from "@/hooks/useWebSocket";
import { useSession } from "@/hooks/useSession";
import type { ChatMessage } from "./Message";

interface Props {
  projectPath: string | null;
  projectName: string | null;
}

export default function ChatView({ projectPath, projectName }: Props) {
  const { session } = useSession(projectPath);
  const { status, lastMessage, send } = useWebSocket(session?.sessionId ?? null);
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [isStreaming, setIsStreaming] = useState(false);

  const appendToken = useCallback((text: string) => {
    setMessages((prev) => {
      const last = prev[prev.length - 1];
      if (last?.role === "assistant" && last.streaming) {
        return [
          ...prev.slice(0, -1),
          { ...last, content: last.content + text },
        ];
      }
      // Neue Streaming-Message anlegen
      return [
        ...prev,
        {
          id: crypto.randomUUID(),
          role: "assistant",
          content: text,
          streaming: true,
        },
      ];
    });
  }, []);

  useEffect(() => {
    if (!lastMessage) return;

    if (lastMessage.type === "token" && lastMessage.text) {
      appendToken(lastMessage.text);
      setIsStreaming(true);
    } else if (lastMessage.type === "tool_call") {
      setMessages((prev) => {
        const last = prev[prev.length - 1];
        if (last?.role === "assistant") {
          return [
            ...prev.slice(0, -1),
            {
              ...last,
              toolCalls: [
                ...(last.toolCalls ?? []),
                {
                  toolName: lastMessage.toolName!,
                  toolInput: lastMessage.toolInput,
                  toolId: lastMessage.toolId!,
                },
              ],
            },
          ];
        }
        return prev;
      });
    } else if (lastMessage.type === "done") {
      setMessages((prev) => {
        const last = prev[prev.length - 1];
        if (last?.streaming) {
          return [...prev.slice(0, -1), { ...last, streaming: false }];
        }
        return prev;
      });
      setIsStreaming(false);
    } else if (lastMessage.type === "error") {
      setMessages((prev) => [
        ...prev,
        {
          id: crypto.randomUUID(),
          role: "assistant",
          content: `Fehler: ${lastMessage.error}`,
        },
      ]);
      setIsStreaming(false);
    }
  }, [lastMessage, appendToken]);

  function handleSend(message: string) {
    if (isStreaming) return;
    setMessages((prev) => [
      ...prev,
      { id: crypto.randomUUID(), role: "user", content: message },
    ]);
    send(message);
    setIsStreaming(true);
  }

  return (
    <div className="flex flex-col h-full">
      <StatusBar projectName={projectName} wsStatus={status} />
      <MessageList messages={messages} />
      <InputBar
        onSend={handleSend}
        disabled={isStreaming || status !== "connected" || !session}
        placeholder={
          !session
            ? "Session wird erstellt…"
            : status !== "connected"
            ? "Verbindung wird hergestellt…"
            : "Nachricht an Claude… (Enter = Senden)"
        }
      />
    </div>
  );
}
