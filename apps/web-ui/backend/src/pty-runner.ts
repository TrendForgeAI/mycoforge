import * as pty from "node-pty";

export interface PtySession {
  pty: pty.IPty;
  cwd: string;
}

export interface PtyRunnerOptions {
  cwd: string;
  cols?: number;
  rows?: number;
  onData: (data: string) => void;
  onExit: (code: number) => void;
}

export function spawnPty(options: PtyRunnerOptions): PtySession {
  const { cwd, cols = 220, rows = 50, onData, onExit } = options;

  const ptyProcess = pty.spawn("claude", [], {
    name: "xterm-256color",
    cols,
    rows,
    cwd,
    env: {
      ...process.env,
      TERM: "xterm-256color",
      COLUMNS: String(cols),
      LINES: String(rows),
      COLORTERM: "truecolor",
    },
  });

  ptyProcess.onData((data) => onData(data));

  ptyProcess.onExit(({ exitCode }) => onExit(exitCode ?? 0));

  return { pty: ptyProcess, cwd };
}
