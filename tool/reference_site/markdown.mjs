import fs from 'node:fs';
import path from 'node:path';
import { Marked } from 'marked';
import GithubSlugger from 'github-slugger';

export function escapeHtml(value) {
	return String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
}

export function createMarkdownRenderer({ root, output, routeMap, sourceLinks }) {
	function rewrite(href, sourcePath, outputPage, image = false) {
		if (/^(https?:|mailto:)/i.test(href)) return href;
		if (/^[a-z][a-z\d+.-]*:/i.test(href) || href.startsWith('//')) return '#';
		const [rawPath, fragment = ''] = href.split('#', 2);
		let decoded;
		try { decoded = decodeURIComponent(rawPath); }
		catch { decoded = rawPath; }
		const target = decoded ? path.posix.normalize(path.posix.join(path.posix.dirname(sourcePath), decoded)) : sourcePath;
		const absolute = path.resolve(root, target);
		const inside = absolute.startsWith(`${root}${path.sep}`);
		const exists = inside && fs.existsSync(absolute) && fs.realpathSync(absolute).startsWith(`${root}${path.sep}`);
		const entry = { sourcePath, outputPage, href, target, fragment, exists, mapped: Boolean(routeMap[target]) };
		sourceLinks.push(entry);
		if (routeMap[target]) {
			const relative = path.posix.relative(path.posix.dirname(outputPage), routeMap[target]);
			return `${relative || path.posix.basename(outputPage)}${fragment ? `#${fragment}` : ''}`;
		}
		if (image && exists && /\.(png|jpe?g|gif|webp|svg)$/i.test(target)) {
			const asset = `assets/repository/${target}`;
			const destination = path.join(output, asset);

			// 僅複製已解析且位於儲存庫內的圖片，避免越界讀取。
			fs.mkdirSync(path.dirname(destination), { recursive: true });
			fs.copyFileSync(absolute, destination);
			return path.posix.relative(path.posix.dirname(outputPage), asset);
		}
		const safeTarget = inside ? target : sourcePath;
		return `https://github.com/miudog/Kallopis/blob/main/${safeTarget.split('/').map(encodeURIComponent).join('/')}${fragment ? `#${fragment}` : ''}`;
	}
	return function render(markdown, sourcePath, outputPage) {
		const slugger = new GithubSlugger();
		const parser = new Marked({ gfm: true, breaks: false });
		parser.use({ renderer: {
			heading({ tokens, depth }) {
				const body = this.parser.parseInline(tokens);
				const plain = body.replace(/<[^>]*>/g, '').replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"');
				return `<h${depth} id="${escapeHtml(slugger.slug(plain))}">${body}</h${depth}>\n`;
			},
			link({ href, title, tokens }) {
				return `<a href="${escapeHtml(rewrite(href, sourcePath, outputPage))}"${title ? ` title="${escapeHtml(title)}"` : ''}>${this.parser.parseInline(tokens)}</a>`;
			},
			image({ href, text, title }) {
				return `<img src="${escapeHtml(rewrite(href, sourcePath, outputPage, true))}" alt="${escapeHtml(text)}"${title ? ` title="${escapeHtml(title)}"` : ''} loading="lazy">`;
			},
			code({ text, lang }) {
				if (lang === 'mermaid') return `<pre class="mermaid">${escapeHtml(text)}</pre>\n`;
				return `<pre><code class="language-${escapeHtml((lang || 'text').split(/\s/)[0])}">${escapeHtml(text)}</code></pre>\n`;
			},
			html({ text }) {
				// 原始 HTML 以文字保留；允許明確的文件錨點，禁止執行腳本。
				const anchor = text.trim().match(/^<a\s+(?:id|name)=["']([^"']+)["']\s*>(?:\s*<\/a>)?$/i);
				if (text.trim() === '</a>') return '';
				return anchor ? `<a id="${escapeHtml(anchor[1])}"></a>` : escapeHtml(text);
			},
		} });
		return parser.parse(markdown);
	};
}

