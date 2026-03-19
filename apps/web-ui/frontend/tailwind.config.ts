import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        bg: "#0d1117",
        surface: "#161b22",
        border: "#30363d",
        text: "#e6edf3",
        muted: "#8b949e",
        accent: "#58a6ff",
        user: "#1f6feb",
        assistant: "#238636",
      },
    },
  },
  plugins: [],
};

export default config;
