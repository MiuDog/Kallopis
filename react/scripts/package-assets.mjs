import { cpSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const library = fileURLToPath(new URL('../', import.meta.url));
mkdirSync(`${library}dist/fonts`, { recursive: true });
// React 發佈資產自行擁有字型及授權；consumer 不依賴 Flutter 的 package URI。
cpSync(fileURLToPath(new URL('../../flutter/assets/fonts/', import.meta.url)), `${library}dist/fonts`, { recursive: true });
writeFileSync(`${library}dist/styles.css`, readFileSync(`${library}src/tokens.css`, 'utf8') + readFileSync(`${library}src/styles.css`, 'utf8') + readFileSync(`${library}src/desktop/styles.css`, 'utf8'));
cpSync(`${library}src/source-manifest.json`, `${library}dist/source-manifest.json`);
cpSync(`${library}src/styles.d.ts`, `${library}dist/styles.d.ts`);
cpSync(`${library}src/style-runtime`, `${library}dist/style-runtime`, { recursive: true });
cpSync(`${library}src/style-pack-manifest.json`, `${library}dist/style-pack-manifest.json`);
