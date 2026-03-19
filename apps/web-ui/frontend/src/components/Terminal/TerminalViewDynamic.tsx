import dynamic from "next/dynamic";

// xterm.js greift auf window/document zu → kein SSR
const TerminalViewDynamic = dynamic(() => import("./TerminalView"), {
  ssr: false,
  loading: () => (
    <div className="flex-1 flex items-center justify-center text-muted text-sm">
      Terminal lädt…
    </div>
  ),
});

export default TerminalViewDynamic;
