import { Suspense } from "react";
import AppShell from "@/components/AppShell";

export default function Home() {
  return (
    <Suspense fallback={<div className="flex h-full items-center justify-center text-muted">Laden…</div>}>
      <AppShell />
    </Suspense>
  );
}
