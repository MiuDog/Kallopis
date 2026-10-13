import { defineConfig } from 'vite';
import { fileURLToPath } from 'node:url';

export default defineConfig({
	root: fileURLToPath(new URL('./example', import.meta.url)),
	base: './',
	build: { outDir: 'dist', emptyOutDir: true },
	resolve: { alias: [
		{ find: /^@kallopis\/react$/, replacement: fileURLToPath(new URL('./dist/index.js', import.meta.url)) },
		{ find: '@kallopis/react/styles.css', replacement: fileURLToPath(new URL('./dist/styles.css', import.meta.url)) },
	] },
});
