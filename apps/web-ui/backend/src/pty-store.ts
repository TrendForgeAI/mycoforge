import type { IPty } from "node-pty";

export interface PtySessionState {
  id: string;
  cwd: string;
  pty: IPty;
  createdAt: Date;
  lastActivity: Date;
}

export class PtyStore {
  private sessions = new Map<string, PtySessionState>();
  private readonly IDLE_TIMEOUT_MS = 4 * 60 * 60 * 1000; // 4 Stunden

  add(id: string, cwd: string, ptyProcess: IPty): PtySessionState {
    const session: PtySessionState = {
      id,
      cwd,
      pty: ptyProcess,
      createdAt: new Date(),
      lastActivity: new Date(),
    };
    this.sessions.set(id, session);
    return session;
  }

  get(id: string): PtySessionState | undefined {
    return this.sessions.get(id);
  }

  touch(id: string): void {
    const s = this.sessions.get(id);
    if (s) s.lastActivity = new Date();
  }

  delete(id: string): void {
    const s = this.sessions.get(id);
    if (s) {
      try { s.pty.kill(); } catch { /* already dead */ }
      this.sessions.delete(id);
    }
  }

  cleanup(): void {
    const now = Date.now();
    for (const [id, s] of this.sessions) {
      if (now - s.lastActivity.getTime() > this.IDLE_TIMEOUT_MS) {
        this.delete(id);
      }
    }
  }
}

export const ptyStore = new PtyStore();
