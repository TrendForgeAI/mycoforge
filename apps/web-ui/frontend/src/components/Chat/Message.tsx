"use client";

import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import ToolCallBlock from "./ToolCallBlock";

export interface ChatMessage {
  id: string;
  role: "user" | "assistant";
  content: string;
  toolCalls?: Array<{
    toolName: string;
    toolInput: unknown;
    toolId: string;
  }>;
  streaming?: boolean;
}

interface Props {
  message: ChatMessage;
}

export default function Message({ message }: Props) {
  const isUser = message.role === "user";

  return (
    <div className={`flex gap-3 ${isUser ? "flex-row-reverse" : "flex-row"} mb-4`}>
      <div
        className={`w-7 h-7 rounded-full flex-shrink-0 flex items-center justify-center text-xs font-bold ${
          isUser ? "bg-user text-white" : "bg-assistant text-white"
        }`}
      >
        {isUser ? "B" : "C"}
      </div>
      <div className={`max-w-[80%] ${isUser ? "items-end" : "items-start"} flex flex-col gap-1`}>
        {message.content && (
          <div
            className={`rounded-lg px-3 py-2 text-sm ${
              isUser
                ? "bg-user/20 text-text"
                : "bg-surface text-text"
            }`}
          >
            {isUser || message.streaming ? (
              <span className="whitespace-pre-wrap">
                {message.content}
                {message.streaming && <span className="animate-pulse">▋</span>}
              </span>
            ) : (
              <ReactMarkdown
                remarkPlugins={[remarkGfm]}
                components={{
                  code({ children, className }) {
                    const isBlock = className?.includes("language-");
                    return isBlock ? (
                      <pre className="bg-bg rounded p-3 overflow-x-auto text-xs my-2 border border-border">
                        <code>{children}</code>
                      </pre>
                    ) : (
                      <code className="bg-bg px-1 py-0.5 rounded text-accent text-xs font-mono">
                        {children}
                      </code>
                    );
                  },
                  p({ children }) {
                    return <p className="mb-2 last:mb-0">{children}</p>;
                  },
                }}
              >
                {message.content}
              </ReactMarkdown>
            )}
          </div>
        )}
        {message.toolCalls?.map((tc) => (
          <ToolCallBlock
            key={tc.toolId}
            toolName={tc.toolName}
            toolInput={tc.toolInput}
          />
        ))}
      </div>
    </div>
  );
}
