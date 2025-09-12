import path from "node:path";
import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// NOTE: more at https://vite.dev/config/
export default defineConfig({
	plugins: [react(), tailwindcss()],
	// NOTE: source - https://ui.shadcn.com/docs/installation/vite
	resolve: {
		alias: {
			"@": path.resolve(__dirname, "./src"),
		},
	},
	// NOTE: So that FE will be able to reach BE on development env.
	server: {
		proxy: {
			"/users": "http://localhost:2300",
			"/sessions": "http://localhost:2300",
		},
	},
});
