import type { IPty } from "node-pty";

const MAX_SCROLLBACK_BYTES = 50 * 1024; // 50 KB

export interface PtySessionState {
  id: string;
  cwd: string;
  pty: IPty;
  createdAt: Date;
  lastActivity: Date;
  scrollbackChunks: string[];
  scrollbackBytes: number;
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
      scrollbackChunks: [],
      scrollbackBytes: 0,
    };
    this.sessions.set(id, session);
    return session;
  }

  appendScrollback(id: string, data: string): void {
    const s = this.sessions.get(id);
    if (!s) return;
    s.scrollbackChunks.push(data);
    s.scrollbackBytes += data.length;
    while (s.scrollbackBytes > MAX_SCROLLBACK_BYTES && s.scrollbackChunks.length > 0) {
      const removed = s.scrollbackChunks.shift()!;
      s.scrollbackBytes -= removed.length;
    }
  }

  getScrollback(id: string): string {
    return this.sessions.get(id)?.scrollbackChunks.join("") ?? "";
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
