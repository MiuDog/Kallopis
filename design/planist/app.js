const paths = {
	file: '<path d="M6 3h8l4 4v14H6zM14 3v5h4M9 12h6M9 16h6"/>',
	files: '<path d="M7 7h12v14H7zM4 17V3h11"/>',
	folder: '<path d="M3 6h6l2 2h10v12H3z"/>',
	board: '<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 8h4v4H7zM14 11h3v5h-3z"/>',
	check: '<rect x="3" y="3" width="18" height="18" rx="4"/><path d="m7 12 3 3 7-7"/>',
	image: '<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8" cy="8" r="1.5"/><path d="m3 18 6-6 4 4 4-6 4 5"/>',
	spark: '<path d="m12 3 2.5 6.5L21 12l-6.5 2.5L12 21l-2.5-6.5L3 12l6.5-2.5z"/>',
	layers: '<path d="m3 8 9-5 9 5-9 5zM3 12l9 5 9-5M3 16l9 5 9-5"/>',
	search: '<circle cx="10" cy="10" r="6"/><path d="m15 15 5 5"/>',
	pin: '<path d="m9 3 9 3-3 5 1 4-5-2-4 3-3-2 5-5zM8 16l-4 5"/>',
	sliders: '<path d="M4 6h16M4 12h16M4 18h16"/><circle cx="8" cy="6" r="2"/><circle cx="16" cy="12" r="2"/><circle cx="10" cy="18" r="2"/>',
	moon: '<path d="M20 15A9 9 0 0 1 9 4a9 9 0 1 0 11 11z"/>',
	minus: '<path d="M5 12h14"/>',
	window: '<rect x="5" y="5" width="14" height="14" rx="1"/>',
	close: '<path d="m6 6 12 12M18 6 6 18"/>',
	arrow: '<path d="M4 12h16m-6-6 6 6-6 6"/>',
	menu: '<path d="M4 6h16M4 12h16M4 18h16"/>',
	cursor: '<path d="m6 3 12 11-7 1-3 7z"/>',
	plus: '<path d="M12 4v16M4 12h16"/>',
};
const documents = {
	brief: { title: '工作室改造計畫', kind: 'Flow', folder: '空間改造' },
	board: { title: '靈感牆', kind: 'Canva', folder: '空間改造' },
	meeting: { title: '第一次現場紀錄', kind: 'Flow', folder: '空間改造' },
	inbox: { title: '隨手記', kind: 'Flow', folder: '文件' },
};
const state = { selected: 'brief', page: 'documents', drafts: {}, notes: null, nodes: null };
const content = document.querySelector('#content');
const root = document.documentElement;

function icon(name) { return `<svg class="icon" viewBox="0 0 24 24" aria-hidden="true">${paths[name] || paths.file}</svg>`; }
function hydrateIcons() { document.querySelectorAll('[data-icon]').forEach(element => { element.innerHTML = icon(element.dataset.icon); }); }
function captureDraft() {
	const sidebar = document.querySelector('#right-sidebar');
	if (!sidebar.hidden) state.notes = sidebar.innerHTML;
	const editor = content.querySelector('.flow-scroll');
	if (editor) state.drafts[state.selected] = editor.innerHTML;
	const canvas = content.querySelector('.canvas-sheet');
	if (canvas) state.nodes = canvas.innerHTML;
}
function openDocument(id) {
	captureDraft();
	state.selected = id;
	state.page = 'documents';
	render();
	document.querySelector('.sidebar').classList.remove('open');
	document.querySelector('#search-dialog').close();
}
function render() {
	const doc = documents[state.selected];
	document.querySelectorAll('.primary [data-page]').forEach(button => button.classList.toggle('current', button.dataset.page === state.page));
	document.querySelectorAll('.file[data-doc]').forEach(button => button.classList.toggle('selected', state.page === 'documents' && button.dataset.doc === state.selected));
	if (state.page === 'documents') content.innerHTML = doc.kind === 'Canva' ? canvasView() : flowView();
	else content.innerHTML = utilityView(state.page);
	const sidebar = document.querySelector('#right-sidebar');
	sidebar.hidden = state.page !== 'documents' || state.selected !== 'brief';
	sidebar.innerHTML = sidebar.hidden ? '' : (state.notes || notesView());
	document.querySelector('.stage').classList.toggle('document-stage', state.page === 'documents');
	hydrateIcons();
	updateConnection();
}
function flowView() {
	let body = state.drafts[state.selected];
	if (!body) body = state.selected === 'brief' ? briefView() : simpleNote();
	return `<div class="flow-scroll">${body}</div>`;
}
function briefView() {
	return `<div class="flow-layout"><article class="paper"><span class="eyebrow">STUDIO JOURNAL / 001</span><h1 class="editable" contenteditable="true" aria-label="筆記標題">工作室改造計畫</h1><p class="lead editable" contenteditable="true" aria-label="筆記摘要">把日常工作的地方，留一點空間給靈感。<br>一個能專注，也能隨時把想法攤開的工作室。</p><div class="callout">${icon('spark')}<p><strong>這次想完成的事</strong><br>不急著填滿空間，先找到光線、動線與工作的節奏。</p></div><h2>01　空間的三個方向</h2><div class="two-col"><div><h3>留白與自然光</h3><p class="editable" contenteditable="true">工作桌靠近窗邊，讓午後的光線落在桌面。牆面保留原色，減少視線裡的干擾。</p></div><div><h3>讓想法看得見</h3><p class="editable" contenteditable="true">把零散的筆記和參考放在一起，透過便利貼整理關係，保留隨時調整的餘地。</p></div></div><hr class="note-divider"><h2>02　開始之前</h2><label class="check-row"><input type="checkbox" checked><span>記錄空間尺寸與主要採光方向</span></label><label class="check-row"><input type="checkbox"><span>整理現有家具，留下真正需要的物件</span></label><label class="check-row"><input type="checkbox"><span>收集材質與配色參考</span></label><label class="check-row"><input type="checkbox"><span>確認第一版平面配置</span></label><button class="reference-link" data-doc="board">${icon('board')}<div><strong>靈感牆</strong><div class="small muted">Canva · 材質、色彩與空間想法</div></div><span>${icon('arrow')}</span></button><hr class="note-divider"><p class="muted small">所有想法都可以先留下，再慢慢找到它們的位置。</p></article></div>`;
}
function notesView() {
	return `<div class="notes-column"><div class="sticky"><span class="eyebrow">A THOUGHT</span><h3>先保留空白</h3><p class="editable" contenteditable="true" aria-label="便利貼內容">不要為了收納而增加櫃子。<br>先想清楚，每天真正會使用的是什麼。</p></div><div class="sticky sage"><span class="eyebrow">TO REMEMBER</span><p>木材、亞麻、暖白。<br>讓材質自然地說話。</p></div><p class="margin-caption">相關文件<br><button class="file" data-doc="meeting">${icon('file')}第一次現場紀錄</button></p></div>`;
}
function simpleNote() {
	const isMeeting = state.selected === 'meeting';
	return `<div class="flow-layout"><article class="paper"><span class="eyebrow">STUDIO JOURNAL</span><h1 contenteditable="true" class="editable">${documents[state.selected].title}</h1><p class="lead">${isMeeting ? '從現場觀察，開始理解這個空間。' : '還沒整理好的想法，也值得一個位置。'}</p><hr class="note-divider"><div class="editable" contenteditable="true" aria-label="笔記正文"><h2>${isMeeting ? '光線與動線' : '今天想到的事'}</h2><p>${isMeeting ? '午後窗邊的光很柔和。入口到工作桌之間需要保留足夠通道，書架可以移到另一面牆。' : '在這裡輸入筆記……'}</p></div></article></div>`;
}
function canvasView() {
	const board = state.nodes || `<div class="board-label"><span class="eyebrow">CANVA / IDEAS IN SPACE</span><h1>靈感牆</h1><span class="small muted">把零散想法放在一起，找出它們的關係。</span></div><svg class="connections" aria-hidden="true"><path id="connector" d="M316 294 C400 294 370 365 456 365"/></svg><div class="board-node sticky" tabindex="0" aria-label="移動便利貼：自然光" style="left:80px;top:204px" data-node="light"><span class="eyebrow">01 / LIGHT</span><h3>讓光走進來</h3><p>桌面靠窗，<br>工作區保持明亮。<br>留下看得見天空的角度。</p></div><div class="board-node sticky sage" tabindex="0" aria-label="移動便利貼：材質" style="left:456px;top:280px" data-node="material"><span class="eyebrow">02 / MATERIAL</span><h3>溫柔的觸感</h3><p>淺木色、亞麻、霧面金屬。<br>不需要太多顏色，<br>讓材質帶出層次。</p></div><div class="board-node sticky terracotta" tabindex="0" aria-label="移動便利貼：留白" style="left:738px;top:164px" data-node="space"><span class="eyebrow">03 / SPACE</span><h3>留一面空白的牆</h3><p>放上還沒成形的想法。<br>隨時可以挪動，<br>也隨時可以重新開始。</p></div><div class="board-label" style="top:556px;left:80px"><button class="reference-link" data-doc="brief">${icon('file')}回到工作室改造計畫 ${icon('arrow')}</button></div>`;
	return `<div class="board-wrap"><div class="canvas"><div class="canvas-sheet">${board}</div></div><div class="canvas-tools"><button class="active" id="select-tool">${icon('cursor')}選取</button><button id="add-sticky">${icon('plus')}便利貼</button></div></div>`;
}
function utilityView(page) {
	if (page === 'tasks') return `<div class="utility"><span class="eyebrow">PROJECT / TASKS</span><h1>待辦事項</h1><p class="muted">從筆記裡收集待辦，回到原處繼續推進。</p><div class="task-list">${['整理現有家具，留下真正需要的物件', '收集材質與配色參考', '確認第一版平面配置'].map((text, index) => `<div class="task-item"><label class="check-row"><input type="checkbox" data-task="${index}"><span>${text}</span></label><button data-doc="brief">工作室改造計畫 ↗</button></div>`).join('')}</div><p class="small muted" style="margin-top:24px">此頁展示彙整外觀，待辦資料尚未連接正文。</p></div>`;
	if (page === 'assets') return `<div class="utility"><span class="eyebrow">PROJECT / ASSETS</span><h1>資產庫</h1><p class="muted">此專案的檔案，在這裡集中整理。</p><div class="asset-grid">${['空間現況.pdf', '材質參考.png', '現場紀錄.m4a'].map((name, index) => `<div class="asset"><div class="asset-preview">${icon(index === 1 ? 'image' : 'file')}</div><strong>${name}</strong><div class="muted small">展示附件 · 未載入實體檔案</div></div>`).join('')}</div></div>`;
	return `<div class="utility"><span class="eyebrow">PLANIST AI</span><h1>為想法，留一個位置。</h1><p class="muted">AI 功能將在後續版本推出。目前可以繼續在本機整理文件與靈感。</p><button class="reference-link" data-doc="brief">${icon('file')}回到工作室改造計畫 ${icon('arrow')}</button></div>`;
}

// 將設計稿的互動限定在頁面記憶體，不宣稱已完成產品保存。
document.addEventListener('click', event => {
	const target = event.target.closest('button');
	if (!target) return;
	if (target.dataset.doc) openDocument(target.dataset.doc);
	if (target.dataset.page) { captureDraft(); state.page = target.dataset.page; render(); }
	if (target.id === 'collection') { captureDraft(); state.selected = 'board'; state.page = 'documents'; render(); }
	if (target.id === 'open-search') { updateSearch(''); document.querySelector('#search').value = ''; document.querySelector('#search-dialog').showModal(); document.querySelector('#search').focus(); }
	if (target.id === 'appearance') document.querySelector('#settings').showModal();
	if (target.id === 'sidebar-toggle') document.querySelector('.sidebar').classList.toggle('open');
	if (target.id === 'add-sticky') {
		const node = document.createElement('div');
		node.className = 'board-node sticky'; node.tabIndex = 0; node.dataset.node = `note-${Date.now()}`;
		node.style.left = '360px'; node.style.top = '80px';
		node.innerHTML = '<span class="eyebrow">NEW IDEA</span><h3 contenteditable="true">新的想法</h3><p contenteditable="true">點選這裡寫下想法。</p>';
		content.querySelector('.canvas-sheet').append(node);
	}
});
document.querySelector('#theme-select').addEventListener('change', event => { root.dataset.theme = event.target.value; });
document.querySelector('#tone-select').addEventListener('change', event => { root.dataset.tone = event.target.value; });
document.querySelector('#shadow-toggle').addEventListener('change', event => { root.dataset.shadow = event.target.checked ? 'on' : 'off'; });
function updateSearch(query) {
	const matches = Object.entries(documents).filter(([, doc]) => doc.title.toLowerCase().includes(query.toLowerCase()));
	document.querySelector('#search-results').innerHTML = matches.map(([id, doc]) => `<button class="file" data-doc="${id}">${icon(doc.kind === 'Canva' ? 'board' : 'file')}${doc.title}</button>`).join('');
	document.querySelector('#search-empty').hidden = matches.length > 0;
}
document.querySelector('#search').addEventListener('input', event => { updateSearch(event.target.value.trim()); });
content.addEventListener('change', event => {
	if (event.target.matches('input[type="checkbox"]')) event.target.toggleAttribute('checked', event.target.checked);
});
let drag = null;
content.addEventListener('pointerdown', event => {
	const node = event.target.closest('.board-node');
	if (!node || event.target.closest('[contenteditable]')) return;
	content.querySelectorAll('.board-node').forEach(item => item.classList.remove('is-selected'));
	node.classList.add('is-selected'); node.focus();
	drag = { node, x: event.clientX, y: event.clientY, left: node.offsetLeft, top: node.offsetTop };
	node.setPointerCapture(event.pointerId);
});
function updateConnection() {
	const a = content.querySelector('[data-node="light"]');
	const b = content.querySelector('[data-node="material"]');
	const path = content.querySelector('#connector');
	if (!a || !b || !path) return;
	const x = a.offsetLeft + a.offsetWidth; const y = a.offsetTop + a.offsetHeight / 2;
	const endX = b.offsetLeft; const endY = b.offsetTop + b.offsetHeight / 2;
	path.setAttribute('d', `M${x} ${y} C${x + 80} ${y} ${endX - 80} ${endY} ${endX} ${endY}`);
}
content.addEventListener('pointermove', event => {
	if (!drag) return;
	drag.node.style.left = `${Math.max(0, Math.min(1050 - drag.node.offsetWidth, drag.left + event.clientX - drag.x))}px`;
	drag.node.style.top = `${Math.max(0, Math.min(720 - drag.node.offsetHeight, drag.top + event.clientY - drag.y))}px`;
	updateConnection();
});
content.addEventListener('pointerup', () => { drag = null; });
content.addEventListener('pointercancel', () => { drag = null; });
content.addEventListener('keydown', event => {
	const node = event.target.closest('.board-node');
	if (!node || event.target.closest('[contenteditable]')) return;
	const steps = { ArrowLeft: [-10, 0], ArrowRight: [10, 0], ArrowUp: [0, -10], ArrowDown: [0, 10] };
	if (!steps[event.key]) return;
	event.preventDefault();
	node.style.left = `${Math.max(0, Math.min(1050 - node.offsetWidth, node.offsetLeft + steps[event.key][0]))}px`;
	node.style.top = `${Math.max(0, Math.min(720 - node.offsetHeight, node.offsetTop + steps[event.key][1]))}px`;
	updateConnection();
});
render();
