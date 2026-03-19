export interface SessionState {
  sessionId: string;       // Claude Code session_id aus --resume
  cwd: string;             // Arbeitsverzeichnis (/workspace/<projekt>)
  createdAt: Date;
  lastActivity: Date;
  active: boolean;
}

export class SessionStore {
  private sessions = new Map<string, SessionState>();
  private readonly IDLE_TIMEOUT_MS = 4 * 60 * 60 * 1000; // 4 Stunden

  create(cwd: string): SessionState {
    // Generiert eine neue lokale session-ID (nicht Claude's session_id)
    // Claude's session_id kommt erst nach dem ersten Aufruf zurück
    const id = crypto.randomUUID();
    const session: SessionState = {
      sessionId: id,
      cwd,
      createdAt: new Date(),
      lastActivity: new Date(),
      active: true,
    };
    this.sessions.set(id, session);
    return session;
  }

  get(id: string): SessionState | undefined {
    return this.sessions.get(id);
  }

  update(id: string, data: Partial<SessionState>): void {
    const session = this.sessions.get(id);
    if (session) {
      Object.assign(session, data, { lastActivity: new Date() });
    }
  }

  delete(id: string): void {
    this.sessions.delete(id);
  }

  list(): SessionState[] {
    return Array.from(this.sessions.values());
  }

  cleanup(): void {
    const now = Date.now();
    for (const [id, session] of this.sessions) {
      if (now - session.lastActivity.getTime() > this.IDLE_TIMEOUT_MS) {
        this.sessions.delete(id);
      }
    }
  }
}

export const sessionStore = new SessionStore();
