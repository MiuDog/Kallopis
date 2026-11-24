import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { resolveStylePack } from '../src/index.mjs';

// 從唯一風格來源產生可獨立開啟與複製的原生 Web 組合。
const pack = JSON.parse(readFileSync(new URL('../kallopis-v1.json', import.meta.url), 'utf8'));
const catalog = JSON.parse(readFileSync(new URL('../catalog.json', import.meta.url), 'utf8'));
const directory = new URL('../examples/sidebar-stage/', import.meta.url);
const color = value => value.length === 9 ? `#${value.slice(3)}${value.slice(1, 3)}` : value;
const modes = ['light', 'dark', 'ultraDark', 'transparent'];
const css = modes.map(mode => {
	const { tokens } = resolveStylePack(pack, mode, catalog);
	return `[data-mode="${mode}"] {\n${Object.entries(tokens).filter(([id]) => id.startsWith('theme.colors.')).map(([id, value]) => `\t--klp-${id.slice(6).replaceAll('.', '-')}: ${color(value)};`).join('\n')}\n}`;
}).join('\n');
const html = `<!doctype html>
<html lang="zh-Hant" data-mode="light">
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Kallopis 側欄與工作區</title>
<style>
${css}
* { box-sizing: border-box; }
body { margin: 0; font-family: system-ui, sans-serif; color: var(--klp-colors-text); background: var(--klp-colors-app); }
main { display: grid; grid-template-columns: minmax(120px, 220px) minmax(0, 1fr); gap: 8px; padding: 8px; min-height: 100vh; }
aside, section { padding: 16px; background: var(--klp-colors-surface); }
nav { display: grid; gap: 8px; }
button, select, textarea { font: inherit; color: inherit; border: 1px solid var(--klp-colors-border); background: var(--klp-colors-component); padding: 8px; }
button { cursor: pointer; }
button:hover, button[aria-current="page"] { background: var(--klp-colors-interactionSoft); }
textarea { display: block; width: 100%; min-height: 240px; margin: 16px 0; }
@media(max-width: 480px) { main { grid-template-columns: 1fr; } }
</style>
<main><aside><h1>工作區</h1><nav aria-label="文件"><button aria-current="page">筆記</button><button>草稿</button></nav></aside>
<section><label>風格 <select id="mode">${modes.map(mode => `<option>${mode}</option>`).join('')}</select></label><h2 id="title">筆記</h2><label for="draft">內容</label><textarea id="draft"></textarea><button id="save">儲存</button><p id="status" role="status"></p></section></main>
<script>
const drafts = { 筆記: '', 草稿: '' };
let selected = '筆記';
const editor = document.querySelector('#draft');
document.querySelector('#mode').onchange = event => document.documentElement.dataset.mode = event.target.value;
for (const button of document.querySelectorAll('nav button')) {
	button.onclick = () => {
		drafts[selected] = editor.value;
		selected = button.textContent;
		for (const item of document.querySelectorAll('nav button')) item.removeAttribute('aria-current');
		button.setAttribute('aria-current', 'page');
		document.querySelector('#title').textContent = selected;
		editor.value = drafts[selected];
	};
}
document.querySelector('#save').onclick = () => {
	drafts[selected] = editor.value;
	document.querySelector('#status').textContent = '本次頁面內容已儲存';
};
</script>
</html>\n`;
mkdirSync(directory, { recursive: true });
const target = new URL('index.html', directory);
if (process.argv.includes('--check')) {
	if (readFileSync(target, 'utf8') !== html) throw new Error('Portable example is stale');
} else writeFileSync(target, html);
