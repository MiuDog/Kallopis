import path from 'node:path';

export function escapeHtml(value) {
	return String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#39;');
}

function headingId(value) {
	return value.replaceAll('`', '').trim().toLowerCase().replace(/\s+/g, '-');
}

function linkTarget(target, context) {
	// 相對來源先解析，再對應站內路由；未登錄文件只連到原文，不發明 HTML。
	if (/^(https?:|mailto:)/i.test(target)) return target;
	if (target.startsWith('#')) return target;
	if (/^[a-z][a-z\d+.-]*:/i.test(target) || target.startsWith('//')) return null;
	const [name, ...fragmentParts] = target.split('#');
	const fragment = fragmentParts.length ? `#${fragmentParts.join('#')}` : '';
	const source = path.posix.normalize(path.posix.join(path.posix.dirname(context.source), name));
	if (source.startsWith('../') || source.startsWith('/')) return null;
	const route = context.routes.get(source);
	if (route) return `${path.posix.relative(path.posix.dirname(context.href), route)}${fragment}`;
	return `https://github.com/technis-toolbox/Kallopis/blob/main/${source.split('/').map(encodeURIComponent).join('/')}${fragment}`;
}

function inline(value, context) {
	// 按記號分段處理，避免 code 內容被再次當成 HTML 或連結執行。
	const pattern = /`([^`]+)`|\[([^\]]+)\]\(([^\s]+?)\)|\*\*([^*]+)\*\*|<br\s*\/?\s*>/gi;
	let result = '';
	let previous = 0;
	for (const match of value.matchAll(pattern)) {
		result += escapeHtml(value.slice(previous, match.index));
		if (match[1] !== undefined) result += `<code>${escapeHtml(match[1])}</code>`;
		else if (match[2] !== undefined) {
			const target = linkTarget(match[3], context);
			result += target ? `<a href="${escapeHtml(target)}">${escapeHtml(match[2])}</a>` : escapeHtml(match[2]);
		}
		else if (match[4] !== undefined) result += `<strong>${escapeHtml(match[4])}</strong>`;
		else result += '<br>';
		previous = match.index + match[0].length;
	}
	return result + escapeHtml(value.slice(previous));
}

function cells(line) {
	const result = [];
	let value = '';
	let code = false;
	for (let index = 0; index < line.length; index++) {
		const char = line[index];
		if (char === '\\' && line[index + 1] === '|') {
			value += '|';
			index++;
			continue;
		}
		if (char === '`') code = !code;
		if (char === '|' && !code) {
			result.push(value.trim());
			value = '';
		}
		else value += char;
	}
	result.push(value.trim());
	if (line.trim().startsWith('|')) result.shift();
	if (line.trim().endsWith('|')) result.pop();
	return result;
}

export function plainText(html) {
	return html.replace(/<[^>]+>/g, ' ').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('&#39;', "'").replaceAll('&amp;', '&').replace(/\s+/g, ' ').trim();
}

export function renderMarkdown(source, context) {
	const lines = source.replaceAll('\r\n', '\n').split('\n');
	const output = [];
	const anchors = [];
	const counts = new Map();
	let list = '';
	const closeList = () => {
		if (list) output.push(`</${list}>`);
		list = '';
	};
	for (let index = 0; index < lines.length; index++) {
		const line = lines[index];
		if (!line.trim()) {
			closeList();
			continue;
		}
		if (line.startsWith('```')) {
			closeList();
			const language = line.slice(3).trim();
			const code = [];
			while (++index < lines.length && !lines[index].startsWith('```')) code.push(lines[index]);
			const className = language === 'mermaid' ? ' class="mermaid"' : '';
			output.push(`<pre${className}><code>${escapeHtml(code.join('\n'))}</code></pre>`);
			continue;
		}
		const heading = line.match(/^(#{1,6})\s+(.+)$/);
		if (heading) {
			closeList();
			const base = headingId(heading[2]);
			const count = counts.get(base) || 0;
			counts.set(base, count + 1);
			const id = count ? `${base}-${count}` : base;
			anchors.push(id);
			output.push(`<h${heading[1].length} id="${escapeHtml(id)}">${inline(heading[2], context)}</h${heading[1].length}>`);
			continue;
		}
		if (line.trim().startsWith('|') && /^\|?[\s:|\-]+\|?$/.test(lines[index + 1]?.trim() || '') && lines[index + 1]?.includes('---')) {
			closeList();
			const header = cells(line);
			output.push(`<div class="table-wrap" tabindex="0" role="region" aria-label="可水平捲動的資料表"><table><thead><tr>${header.map((cell) => `<th scope="col">${inline(cell, context)}</th>`).join('')}</tr></thead><tbody>`);
			index++;
			while (index + 1 < lines.length && lines[index + 1].trim().startsWith('|')) {
				const row = cells(lines[++index]);
				if (row.length !== header.length) throw new Error(`Table column mismatch: ${context.source}:${index + 1}`);
				output.push(`<tr>${row.map((cell) => `<td>${inline(cell, context)}</td>`).join('')}</tr>`);
			}
			output.push('</tbody></table></div>');
			continue;
		}
		const item = line.match(/^(?:- |\d+\. )(.+)$/);
		if (item) {
			const kind = line.startsWith('-') ? 'ul' : 'ol';
			if (list !== kind) {
				closeList();
				list = kind;
				output.push(`<${kind}>`);
			}
			output.push(`<li>${inline(item[1], context)}</li>`);
			continue;
		}
		closeList();
		if (line.startsWith('> ')) output.push(`<blockquote>${inline(line.slice(2), context)}</blockquote>`);
		else output.push(`<p>${inline(line, context)}</p>`);
	}
	closeList();
	const html = output.join('\n');
	return {
		/* html：安全文章；body：同內容的搜尋文字；anchors：站內 fragment 驗證依據。 */
		html, body: plainText(html), anchors,
	};
}
