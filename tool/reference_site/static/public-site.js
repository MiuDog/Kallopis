// 校正後的 8 大跨領域風格（微立體與立體合併為單一「立體浮層 Elevation」系列，透過立體程度即時切換）
		const themes = [
			{
				id: 'elevation-v1', family: 'elevation', adjustableElevation: true,
				name: { en: 'Elevation', 'zh-Hant': '立體浮層' },
				englishName: 'Elevation (Micro ↔ Glass)',
				desc: {
					en: 'Unified elevation spectrum—dial seamlessly between restrained micro-bevel workbenches and full color-block frosted glass.',
					'zh-Hant': '統一立體光譜系列：可自由調整立體程度，從克制的微立體微亮邊一路切換至飽滿色塊與半透明磨砂玻璃。',
				},
				cssPath: 'styles/themes/elevation-v1.css', jsPath: 'styles/themes/elevation-v1.js', jsonPath: 'styles/themes/elevation-v1.json',
			},
			{
				id: 'modern-minimal-v1', family: 'modern-minimal',
				name: { en: 'Editorial Minimal', 'zh-Hant': '編輯簡約' },
				englishName: 'Editorial Minimal',
				desc: {
					en: '1px editorial hairlines, restrained linear transitions, and quiet alabaster typography.',
					'zh-Hant': '1px 細線分隔、克制俐落的線性過場與編輯排版留白。',
				},
				cssPath: 'styles/themes/modern-minimal-v1.css', jsPath: 'styles/themes/modern-minimal-v1.js', jsonPath: 'styles/themes/modern-minimal-v1.json',
			},
			{
				id: 'kallopis-v1', family: 'kallopis',
				name: { en: 'Parchment', 'zh-Hant': '暖紙書房' },
				englishName: 'Kallopis Parchment',
				desc: {
					en: 'Kallopis warm parchment baseline with low-contrast controls and gentle paper elevation.',
					'zh-Hant': '原始暖紙基準表面、低對比中性控制項與柔和紙片微浮手感。',
				},
				cssPath: 'styles/themes/kallopis-v1.css', jsPath: 'styles/themes/kallopis-v1.js', jsonPath: 'styles/themes/kallopis-v1.json',
			},
			{
				id: 'dev-precision-v1', family: 'dev-precision',
				name: { en: 'Dev Precision', 'zh-Hant': '開發精密' },
				englishName: 'Dev Precision (IDE & SaaS)',
				desc: {
					en: 'Linear & Vercel inspired precision: deep slate layers, hairline borders, electric indigo accents, and keyboard-first rhythm.',
					'zh-Hant': '專為程式開發與 IDE 工具打造：冷調深岩分層、銳利細線、電光靛藍強調色與鍵盤優先操作節奏。',
				},
				cssPath: 'styles/themes/dev-precision-v1.css', jsPath: 'styles/themes/dev-precision-v1.js', jsonPath: 'styles/themes/dev-precision-v1.json',
			},
			{
				id: 'quant-terminal-v1', family: 'quant-terminal',
				name: { en: 'Quant Terminal', 'zh-Hant': '金融終端' },
				englishName: 'Quant Terminal (Finance)',
				desc: {
					en: 'High-density financial terminal aesthetics with tabular numerals, instant state changes, and disciplined emerald/crimson signals.',
					'zh-Hant': '高資訊密度金融交易終端語彙：等寬對齊數值、零延遲狀態回饋與克制的紅綠漲跌訊號色。',
				},
				cssPath: 'styles/themes/quant-terminal-v1.css', jsPath: 'styles/themes/quant-terminal-v1.js', jsonPath: 'styles/themes/quant-terminal-v1.json',
			},
			{
				id: 'data-notebook-v1', family: 'data-notebook',
				name: { en: 'Data Notebook', 'zh-Hant': '資料筆記' },
				englishName: 'Data Notebook (Data Science)',
				desc: {
					en: 'Computational notebook clarity inspired by Observable and Jupyter: modular code cells, crisp lab surfaces, and scientific chart hues.',
					'zh-Hant': '資料科學與分析筆記語彙：模組化程式碼儲存格、俐落實驗室白／深海藍底色與清晰圖表色階。',
				},
				cssPath: 'styles/themes/data-notebook-v1.css', jsPath: 'styles/themes/data-notebook-v1.js', jsonPath: 'styles/themes/data-notebook-v1.json',
			},
			{
				id: 'studio-canvas-v1', family: 'studio-canvas',
				name: { en: 'Studio Canvas', 'zh-Hant': '設計畫布' },
				englishName: 'Studio Canvas (Design Tools)',
				desc: {
					en: 'Color-neutral studio gray inspired by Figma and Blender so designers judge artwork accurately alongside compact inspector panels.',
					'zh-Hant': '專為設計與創作工具打造的零色偏中性灰畫布，搭配高密度屬性面板與鮮明選取框線。',
				},
				cssPath: 'styles/themes/studio-canvas-v1.css', jsPath: 'styles/themes/studio-canvas-v1.js', jsonPath: 'styles/themes/studio-canvas-v1.json',
			},
			{
				id: 'swiss-brutal-v1', family: 'swiss-brutal',
				name: { en: 'Swiss Brutal', 'zh-Hant': '瑞士粗獷' },
				englishName: 'Swiss Brutalism (Systems)',
				desc: {
					en: '0px corners, stark 1.5px ink rules, high-voltage safety orange signals, and uncompromising Swiss grid structure.',
					'zh-Hant': '0px 直角、1.5px 實線邊框、安全橘高對比訊號色與嚴謹瑞士網格結構。',
				},
				cssPath: 'styles/themes/swiss-brutal-v1.css', jsPath: 'styles/themes/swiss-brutal-v1.js', jsonPath: 'styles/themes/swiss-brutal-v1.json',
			},
			{
				id: 'enterprise-clarity-v1', family: 'enterprise-clarity',
				name: { en: 'Enterprise Clarity', 'zh-Hant': '企業清晰' },
				englishName: 'Enterprise Clarity (SaaS)',
				desc: {
					en: 'Trust-blue enterprise hierarchy inspired by Stripe and Atlassian for complex workflows, tables, and RBAC consoles.',
					'zh-Hant': '企業級 SaaS 信任藍語彙：清晰資訊層級與穩健表單秩序，適合管理後台與審批系統。',
				},
				cssPath: 'styles/themes/enterprise-clarity-v1.css', jsPath: 'styles/themes/enterprise-clarity-v1.js', jsonPath: 'styles/themes/enterprise-clarity-v1.json',
			},
			{
				id: 'clinical-calm-v1', family: 'clinical-calm',
				name: { en: 'Clinical Calm', 'zh-Hant': '醫療潔淨' },
				englishName: 'Clinical Calm (Healthcare)',
				desc: {
					en: 'High-clarity clinical surfaces with soothing sage-teal status cues and generous breathing room for zero-error readability.',
					'zh-Hant': '醫療與生技領域專屬的高清晰度潔淨介面，採柔和青綠訊號與充裕留白降低判讀疲勞。',
				},
				cssPath: 'styles/themes/clinical-calm-v1.css', jsPath: 'styles/themes/clinical-calm-v1.js', jsonPath: 'styles/themes/clinical-calm-v1.json',
			},
			{
				id: 'cyber-neon-v1', family: 'cyber-neon',
				name: { en: 'Cyber Neon', 'zh-Hant': '霓虹電競' },
				englishName: 'Cyber Neon (Media & Gaming)',
				desc: {
					en: 'Deep violet-obsidian surfaces paired with vivid magenta and cyan accents for streaming, audio, and gaming tools.',
					'zh-Hant': '深紫黑曜底色搭配洋紅與電光青亮點，適合影音剪輯、串流控制與遊戲社群介面。',
				},
				cssPath: 'styles/themes/cyber-neon-v1.css', jsPath: 'styles/themes/cyber-neon-v1.js', jsonPath: 'styles/themes/cyber-neon-v1.json',
			},
			{
				id: 'spatial-glass-v1', family: 'spatial-glass',
				name: { en: 'Spatial Glass', 'zh-Hant': '液態玻璃' },
				englishName: 'Spatial Glass (Spatial OS)',
				desc: {
					en: 'Optical frosted glass panels with specular edge highlights and floating docks inspired by modern spatial operating systems.',
					'zh-Hant': '空間運算液態玻璃語彙：高通透光學模糊、高光亮邊與懸浮式操控列。',
				},
				cssPath: 'styles/themes/spatial-glass-v1.css', jsPath: 'styles/themes/spatial-glass-v1.js', jsonPath: 'styles/themes/spatial-glass-v1.json',
			},
		];

		const motionComponents = [
			{
				id: 'tab-bar', klpComponent: 'KlpTabs', origin: 'core',
				name: { en: 'Tab Bar', 'zh-Hant': 'Tab Bar 導覽列' },
				subtitle: 'Sliding Pill · Expanding Label',
				variants: { en: ['Sliding Pill', 'Expanding Label'], 'zh-Hant': ['滑動膠囊', '展開標籤'] },
				render(container, variantIdx, lang) {
					const items = lang === 'en' ? ['Home', 'Explore', 'Saved', 'Prefs'] : ['首頁', '探索', '收藏', '設定'];
					let selected = 0;
					const expandMode = variantIdx === 1;
					container.innerHTML = `<div class="demo-card-shell"><div class="m-tabbar ${expandMode ? 'expand-mode' : ''}" role="tablist"><div class="m-tab-indicator"></div>${items.map((label, idx) => `<button type="button" class="m-tab-btn ${idx === 0 ? 'active' : ''}" data-tab="${idx}"><span>${['◈', '◎', '✦', '⚙'][idx]}</span><span class="m-tab-text">${label}</span></button>`).join('')}</div><p id="tab-demo-note" style="margin:16px 0 0;font-size:13px;color:var(--klp-colors-textMuted);text-align:center;">${lang === 'en' ? 'Active Tab: Home' : '目前分頁：首頁'}</p></div>`;
					const indicator = container.querySelector('.m-tab-indicator');
					const btns = [...container.querySelectorAll('.m-tab-btn')];
					const note = container.querySelector('#tab-demo-note');
					function moveIndicator() {
						const active = btns[selected];
						indicator.style.width = `${active.offsetWidth}px`;
						indicator.style.transform = `translateX(${active.offsetLeft - 5}px)`;
					}
					btns.forEach((btn, idx) => btn.addEventListener('click', () => {
						selected = idx;
						btns.forEach((b, j) => b.classList.toggle('active', j === idx));
						note.textContent = `${lang === 'en' ? 'Active Tab: ' : '目前分頁：'}${items[idx]}`;
						requestAnimationFrame(moveIndicator);
					}));
					requestAnimationFrame(moveIndicator);
				},
				code: {
					react: `export function KlpMotionTabBar({ items = ['Home', 'Explore', 'Saved', 'Prefs'] }) {\n\tconst [active, setActive] = useState(0);\n\treturn (\n\t\t<div className="m-tabbar" role="tablist">\n\t\t\t{items.map((label, i) => (\n\t\t\t\t<button key={label} className={\`m-tab-btn \${i === active ? 'active' : ''}\`} onClick={() => setActive(i)}>{label}</button>\n\t\t\t))}\n\t\t</div>\n\t);\n}`,
					flutter: `AnimatedAlign(\n\tduration: const Duration(milliseconds: 280),\n\tcurve: Curves.easeOutBack,\n\talignment: Alignment(-1 + (2 * activeIndex / (items.length - 1)), 0),\n\tchild: Container(color: context.klp.colors.component),\n);`,
					html: `<div class="m-tabbar" role="tablist">\n\t<div class="m-tab-indicator"></div>\n\t<button class="m-tab-btn active">Home</button>\n</div>`,
				},
			},
			{
				id: 'button-micro', klpComponent: 'KlpButton', origin: 'core',
				name: { en: 'Button Motion', 'zh-Hant': 'Button 微互動' },
				subtitle: 'Ripple · Jelly · Load & Success',
				variants: { en: ['Ripple & Jelly', 'Load & Success'], 'zh-Hant': ['水波紋 & 果凍', '讀取轉完成'] },
				render(container, variantIdx, lang) {
					if (variantIdx === 0) {
						container.innerHTML = `<div class="demo-card-shell"><div class="m-btn-wrap"><button type="button" class="m-btn" id="ripple-btn">${lang === 'en' ? 'Ripple Click' : '水波紋點擊'}</button><button type="button" class="m-btn jelly">${lang === 'en' ? 'Jelly Bounce' : '果凍彈跳'}</button></div></div>`;
						const rBtn = container.querySelector('#ripple-btn');
						rBtn.addEventListener('click', e => {
							const rect = rBtn.getBoundingClientRect();
							const span = document.createElement('span');
							span.className = 'm-ripple';
							const size = Math.max(rect.width, rect.height);
							span.style.width = span.style.height = `${size}px`;
							span.style.left = `${e.clientX - rect.left - size / 2}px`;
							span.style.top = `${e.clientY - rect.top - size / 2}px`;
							rBtn.append(span);
							setTimeout(() => span.remove(), 540);
						});
					} else {
						const idle = lang === 'en' ? 'Submit Changes' : '送出變更';
						const done = lang === 'en' ? '✓ Saved' : '✓ 已完成';
						container.innerHTML = `<div class="demo-card-shell" style="text-align:center;"><button type="button" class="m-btn" id="load-btn">${idle}</button></div>`;
						const btn = container.querySelector('#load-btn');
						btn.addEventListener('click', () => {
							if (btn.classList.contains('loading')) return;
							btn.classList.add('loading');
							btn.innerHTML = '<span class="m-spinner"></span>';
							setTimeout(() => {
								btn.classList.remove('loading');
								btn.classList.add('success');
								btn.textContent = done;
								setTimeout(() => { btn.classList.remove('success'); btn.textContent = idle; }, 1400);
							}, 900);
						});
					}
				},
				code: {
					react: `export function KlpMorphButton({ onSubmit }) {\n\tconst [state, setState] = useState('idle');\n\treturn <button className={\`m-btn \${state}\`} onClick={onSubmit}>{state === 'success' ? '✓ Saved' : 'Submit'}</button>;\n}`,
					flutter: `AnimatedContainer(\n\tduration: const Duration(milliseconds: 280),\n\twidth: isLoading ? 44 : 140,\n\theight: 44,\n);`,
					html: `<button class="m-btn" type="button">Submit Changes</button>`,
				},
			},
			{
				id: 'switch-motion', klpComponent: 'KlpSwitch', origin: 'core',
				name: { en: 'Switch Motion', 'zh-Hant': 'Switch 開關動效' },
				subtitle: 'Elastic Thumb · Water Fill',
				variants: { en: ['Elastic & Water'], 'zh-Hant': ['彈性滑塊 & 液態填充'] },
				render(container, _v, lang) {
					container.innerHTML = `<div class="demo-card-shell"><div class="m-switch-row"><div><strong>${lang === 'en' ? 'Elastic Thumb' : '彈性滑塊'}</strong><div style="font-size:12px;color:var(--klp-colors-textMuted);">${lang === 'en' ? 'Stretches subtly on press' : '按壓時拇指微延展'}</div></div><button type="button" class="m-switch on" role="switch" aria-checked="true"><span class="m-switch-thumb"></span></button></div><div class="m-switch-row"><div><strong>${lang === 'en' ? 'Water Fill' : '液態填滿'}</strong><div style="font-size:12px;color:var(--klp-colors-textMuted);">${lang === 'en' ? 'Color rises smoothly on toggle' : '切換時色彩由底部上升'}</div></div><button type="button" class="m-switch water" role="switch" aria-checked="false"><span class="m-switch-thumb"></span></button></div></div>`;
					for (const sw of container.querySelectorAll('.m-switch')) {
						sw.addEventListener('click', () => {
							const next = !sw.classList.contains('on');
							sw.classList.toggle('on', next);
							sw.setAttribute('aria-checked', String(next));
						});
					}
				},
				code: {
					react: `<button role="switch" aria-checked={checked} className={\`m-switch \${checked ? 'on' : ''}\`} onClick={toggle}><span className="m-switch-thumb" /></button>`,
					flutter: `KlpToggle(value: enabled, onChanged: setEnabled);`,
					html: `<button class="m-switch water" role="switch" aria-checked="false"><span class="m-switch-thumb"></span></button>`,
				},
			},
			{
				id: 'icon-morph', klpComponent: 'KlpIconButton', origin: 'core',
				name: { en: 'Icon Morph', 'zh-Hant': 'Icon Morph 圖示變形' },
				subtitle: 'Spin Swap · Tumble Flip · Scale',
				variants: { en: ['Interactive Tiles'], 'zh-Hant': ['點擊切換變形'] },
				render(container, _v, lang) {
					container.innerHTML = `<div class="demo-card-shell"><div class="m-icon-grid"><button type="button" class="m-icon-tile spin"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg></button><button type="button" class="m-icon-tile flip"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 9l6 6 6-6"/></svg></button><button type="button" class="m-icon-tile morph"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15 9 22 9 16.5 14 18.5 21 12 17 5.5 21 7.5 14 2 9 9 9 12 2"/></svg></button></div><p style="margin:14px 0 0;font-size:12.5px;color:var(--klp-colors-textMuted);text-align:center;">${lang === 'en' ? 'Click any tile to trigger spin, flip, or scale morph' : '點擊任一圖示體驗旋轉、翻轉與縮放變形'}</p></div>`;
					for (const tile of container.querySelectorAll('.m-icon-tile')) tile.addEventListener('click', () => tile.classList.toggle('active'));
				},
				code: {
					react: `<button className={\`m-icon-tile spin \${active ? 'active' : ''}\`} onClick={toggle}><PlusIcon /></button>`,
					flutter: `AnimatedRotation(turns: active ? 0.5 : 0, duration: const Duration(milliseconds: 300), child: const Icon(Icons.add));`,
					html: `<button class="m-icon-tile spin" onclick="this.classList.toggle('active')">+</button>`,
				},
			},
			{
				id: 'text-field', klpComponent: 'KlpTextField', origin: 'core',
				name: { en: 'Text Field', 'zh-Hant': 'Text Field 輸入欄' },
				subtitle: 'Floating Label · Live Validation',
				variants: { en: ['Floating & Counter'], 'zh-Hant': ['浮動標籤與驗證'] },
				render(container, _v, lang) {
					container.innerHTML = `<div class="demo-card-shell"><div class="m-field"><input type="text" id="demo-float-input" placeholder=" " maxlength="32" value="Kallopis Theme"><label for="demo-float-input">${lang === 'en' ? 'Project Name' : '專案名稱'}</label></div><div class="m-field-meta"><span id="demo-valid-msg">${lang === 'en' ? '✓ Valid name' : '✓ 名稱格式正確'}</span><span id="demo-char-count">14 / 32</span></div></div>`;
					const input = container.querySelector('#demo-float-input');
					const count = container.querySelector('#demo-char-count');
					const msg = container.querySelector('#demo-valid-msg');
					input.addEventListener('input', () => {
						const ok = input.value.trim().length >= 3;
						count.textContent = `${input.value.length} / 32`;
						msg.textContent = ok ? (lang === 'en' ? '✓ Valid name' : '✓ 名稱格式正確') : (lang === 'en' ? 'Enter at least 3 chars' : '請輸入至少 3 個字元');
						msg.style.color = ok ? 'var(--klp-colors-success)' : 'var(--klp-colors-danger)';
					});
				},
				code: {
					react: `<div className="m-field"><input placeholder=" " value={value} onChange={onChange} /><label>Project Name</label></div>`,
					flutter: `KlpTextField(label: 'Project Name', maxLength: 32, controller: controller);`,
					html: `<div class="m-field"><input type="text" placeholder=" " maxlength="32"><label>Project Name</label></div>`,
				},
			},
			{
				id: 'tooltip-motion', klpComponent: 'KlpTooltip', origin: 'core',
				name: { en: 'Tooltip', 'zh-Hant': 'Tooltip 提示氣泡' },
				subtitle: 'Arrow Grow · Elastic Drop',
				variants: { en: ['Hover & Focus'], 'zh-Hant': ['懸停與聚焦'] },
				render(container, _v, lang) {
					container.innerHTML = `<div class="demo-card-shell"><div class="m-tip-row"><div class="m-tip-host"><button type="button" class="klp-btn">${lang === 'en' ? 'Copy Token' : '複製色票'}</button><span class="m-tip-bubble">${lang === 'en' ? '⌘C Copy semantic hex' : '⌘C 複製語意色碼'}</span></div><div class="m-tip-host"><button type="button" class="klp-btn">${lang === 'en' ? 'Sync Mode' : '同步模式'}</button><span class="m-tip-bubble">${lang === 'en' ? 'Synced across all themes' : '即時同步所有主題'}</span></div></div></div>`;
				},
				code: {
					react: `<div className="m-tip-host"><button className="klp-btn">Copy Token</button><span className="m-tip-bubble">⌘C Copy semantic hex</span></div>`,
					flutter: `KlpTooltip(message: '⌘C Copy semantic hex', child: KlpButton(label: 'Copy Token', onPressed: onCopy));`,
					html: `<div class="m-tip-host"><button class="klp-btn">Copy Token</button><span class="m-tip-bubble">⌘C Copy semantic hex</span></div>`,
				},
			},
			{
				id: 'side-drawer', klpComponent: 'KlpDrawer', origin: 'core',
				name: { en: 'Side Drawer', 'zh-Hant': 'Side Drawer 抽屜選單' },
				subtitle: 'Push Aside · Frosted Glass',
				variants: { en: ['Push Aside', 'Glass Overlay'], 'zh-Hant': ['推動主畫面', '磨砂覆蓋'] },
				render(container, variantIdx, lang) {
					const isPush = variantIdx === 0;
					container.innerHTML = `<div class="demo-card-shell" style="padding:14px;"><div class="m-drawer-stage ${isPush ? 'push' : ''}" id="demo-drawer"><aside class="m-drawer-panel"><strong style="font-size:13px;">${lang === 'en' ? 'Workspace' : '工作區導覽'}</strong><span style="font-size:12px;color:var(--klp-colors-textMuted);">01 Tokens</span><span style="font-size:12px;color:var(--klp-colors-textMuted);">02 Components</span><span style="font-size:12px;color:var(--klp-colors-textMuted);">03 Themes</span></aside><div class="m-drawer-main"><button type="button" class="klp-btn" id="drawer-toggle-btn">${lang === 'en' ? 'Toggle Drawer' : '展開 / 收合抽屜'}</button></div></div></div>`;
					const stage = container.querySelector('#demo-drawer');
					container.querySelector('#drawer-toggle-btn').addEventListener('click', () => stage.classList.toggle('open'));
				},
				code: {
					react: `<div className={\`m-drawer-stage \${open ? 'open' : ''} push\`}><aside className="m-drawer-panel">...</aside><div className="m-drawer-main">{children}</div></div>`,
					flutter: `AnimatedSlide(offset: open ? Offset.zero : const Offset(-1, 0), duration: const Duration(milliseconds: 280), child: drawerPanel);`,
					html: `<div class="m-drawer-stage push open"><aside class="m-drawer-panel">...</aside></div>`,
				},
			},
			{
				id: 'search-bar', klpComponent: 'KlpExpandSearch', origin: 'draft',
				name: { en: 'Expand Search', 'zh-Hant': 'Search Bar 展開搜尋' },
				subtitle: 'Morphing Pill Search',
				variants: { en: ['Click to Expand'], 'zh-Hant': ['點擊展開搜尋列'] },
				render(container, _v, lang) {
					container.innerHTML = `<div class="demo-card-shell" style="display:flex;justify-content:center;"><div class="m-search-shell" id="demo-search-shell"><button type="button" id="demo-search-btn" style="border:0;background:transparent;cursor:pointer;padding:0;" aria-label="Expand Search">⌕</button><input type="search" id="demo-search-input" placeholder="${lang === 'en' ? 'Search tokens or styles…' : '搜尋 token 或風格…'}"></div></div>`;
					const shell = container.querySelector('#demo-search-shell');
					const input = container.querySelector('#demo-search-input');
					container.querySelector('#demo-search-btn').addEventListener('click', () => { shell.classList.toggle('open'); if (shell.classList.contains('open')) input.focus(); });
				},
				code: {
					react: `<div className={\`m-search-shell \${open ? 'open' : ''}\`}><button onClick={() => setOpen(!open)}>⌕</button><input placeholder="Search…" /></div>`,
					flutter: `AnimatedContainer(duration: const Duration(milliseconds: 300), width: expanded ? 320 : 44, height: 44);`,
					html: `<div class="m-search-shell open"><button>⌕</button><input type="search" placeholder="Search…"></div>`,
				},
			},
			{
				id: 'skeleton-loading', klpComponent: 'KlpSkeleton', origin: 'core',
				name: { en: 'Skeleton', 'zh-Hant': 'Skeleton 骨架屏' },
				subtitle: 'Shimmer · Blur Focus Reveal',
				variants: { en: ['Toggle Loaded'], 'zh-Hant': ['模擬載入完成'] },
				render(container, _v, lang) {
					let loaded = false;
					function draw() {
						container.innerHTML = `<div class="demo-card-shell" style="display:flex;flex-direction:column;gap:12px;">${loaded ? `<div class="m-skel-loaded"><strong style="font-size:15px;">${lang === 'en' ? 'Style pack ready' : 'Kallopis 語意風格已就緒'}</strong><p style="margin:6px 0 0;font-size:13px;color:var(--klp-colors-textMuted);">${lang === 'en' ? 'Smooth blur-to-focus reveal avoids jarring layout pops.' : '文字由柔焦漸進清晰呈現，避免載入瞬間跳動。'}</p></div>` : `<div class="m-skel-line" style="width:62%;"></div><div class="m-skel-line" style="width:100%;"></div><div class="m-skel-line" style="width:84%;"></div>`}<button type="button" class="klp-btn" id="toggle-skel-btn" style="align-self:flex-start;">${loaded ? (lang === 'en' ? 'Replay Skeleton' : '重新播放骨架屏') : (lang === 'en' ? 'Show Loaded' : '切換為載入完成')}</button></div>`;
						container.querySelector('#toggle-skel-btn').addEventListener('click', () => { loaded = !loaded; draw(); });
					}
					draw();
				},
				code: {
					react: `{loading ? <div className="m-skel-line" /> : <div className="m-skel-loaded">{content}</div>}`,
					flutter: `AnimatedSwitcher(duration: const Duration(milliseconds: 360), child: isLoading ? const KlpSkeleton() : content);`,
					html: `<div class="m-skel-line" style="width:70%"></div>`,
				},
			},
			{
				id: 'like-swipe', klpComponent: 'KlpSwipeRow', origin: 'draft',
				name: { en: 'Like & Swipe', 'zh-Hant': 'Like & Swipe 微回饋' },
				subtitle: 'Pop Bounce · Inline Undo',
				variants: { en: ['Pop & Archive'], 'zh-Hant': ['愛心彈跳與封存'] },
				render(container, _v, lang) {
					let count = 24;
					container.innerHTML = `<div class="demo-card-shell" style="display:flex;flex-direction:column;gap:14px;"><div><button type="button" class="m-like-btn" id="demo-like-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 0 0 0-7.8z"/></svg><span id="demo-like-count">24</span></button></div><div class="m-swipe-row" id="demo-swipe-row"><span style="font-size:13px;">${lang === 'en' ? 'Design system milestone' : '設計系統里程碑通知'}</span><button type="button" class="klp-btn" id="demo-archive-btn" style="height:28px;font-size:12px;">${lang === 'en' ? 'Archive' : '封存'}</button></div></div>`;
					const likeBtn = container.querySelector('#demo-like-btn');
					const likeCount = container.querySelector('#demo-like-count');
					likeBtn.addEventListener('click', () => { const liked = likeBtn.classList.toggle('liked'); count += liked ? 1 : -1; likeCount.textContent = String(count); });
					const row = container.querySelector('#demo-swipe-row');
					const archiveBtn = container.querySelector('#demo-archive-btn');
					archiveBtn.addEventListener('click', () => { const archived = row.classList.toggle('archived'); archiveBtn.textContent = archived ? (lang === 'en' ? 'Undo' : '復原') : (lang === 'en' ? 'Archive' : '封存'); });
				},
				code: {
					react: `<button className={\`m-like-btn \${liked ? 'liked' : ''}\`} onClick={toggleLike}><HeartIcon /> {count}</button>`,
					flutter: `AnimatedScale(scale: liked ? 1.15 : 1.0, duration: const Duration(milliseconds: 260), curve: Curves.elasticOut, child: Icon(Icons.favorite));`,
					html: `<button class="m-like-btn liked">♥ 25</button>`,
				},
			},
		];

		// 完整中英文對照字典（確保切換語言 100% 完整翻譯）
		const i18n = {
			en: {
				langBadge: 'EN',
				navHome: 'Home', navDesign: 'Design', navUsage: 'Usage', navCommunity: 'Community',
				headerCta: 'Use Kallopis',
				mHomeOverview: 'Overview', mHomeOverviewDesc: 'Universal styling foundation and governed constraints',
				mHomeStyles: 'Style Preview', mHomeStylesDesc: 'Revolving showcase across four versioned themes',
				mHomeExamples: 'Component Examples', mHomeExamplesDesc: 'Ten component categories synced live with active style',
				mHomeArch: 'Architecture', mHomeArchDesc: 'Motion curves, cross-framework parity, and synced modes',
				mDesignColor: 'Color Palette', mDesignColorDesc: '350+ semantic tokens across four color modes',
				mDesignComp: 'Component Preview', mDesignCompDesc: 'Interactive motion stage with multi-framework code',
				mDesignLayout: 'Layout Design', mDesignLayoutDesc: 'Two-pane workbenches and responsive surface order',
				mUsageLib: 'Use Library', mUsageLibDesc: 'Install and compose Kallopis in React, Flutter, or HTML',
				mUsageSkills: 'AI Skills', mUsageSkillsDesc: 'Drop-in style constraint skills and versioned style packs',
				mUsageRef: 'References', mUsageRefDesc: 'Public API reference, token bindings, and contracts',
				mCommGithub: 'GitHub Repository', mCommGithubDesc: 'Source code, versioned themes, and release history',
				mCommDiscord: 'Discord Community', mCommDiscordDesc: 'Live feedback, theme showcases, and Vibe Coder tips',
				mCommDiscuss: 'Discussions', mCommDiscussDesc: 'Propose new styles and review component candidates',
				comingSoon: 'Coming Soon',
				heroTitle: 'Universal UI Styling Foundation',
				heroSubtitle: 'Simple, governed style constraints for any application—complete with cross-framework components, versioned style packs, and AI Skills built for Vibe Coders and product teams.',
				heroCta: 'Use Kallopis',
				heroWinTitle: 'Kallopis Workspace · Style Tokens',
				heroNavAll: 'All Themes', heroNavTokens: 'Semantic Tokens', heroNavComp: 'Components', heroNavSkills: 'AI Skills',
				heroCard1: 'Warm charcoal bevels built for long-focus workbenches.',
				heroCard2: 'Color-block surfaces paired with translucent frosted glass.',
				heroCard3: 'Quietly editorial 1px hairlines and refined spacing.',
				heroCard4: 'Calm paper hierarchy with low-contrast controls.',
				meaningLine1: 'Kallopis comes from Kallopizo —',
				meaningLine2: 'crafted to beautify every interface.',
				icon1: 'Style Constraints', icon2: 'Semantic Tokens', icon3: 'Cross-Framework', icon4: 'Style Packs', icon5: 'AI Skills',
				stylePreviewTitle: 'Style Preview',
				examplesTitle: 'Component Examples',
				archTitle: 'Order for the system, freedom for your product',
				themeMicro: 'Micro Elevation', themeElev: 'Elevation', themeMinimal: 'Editorial Minimal', themeParchment: 'Parchment',
				themeDev: 'Dev Precision', themeQuant: 'Quant Terminal', themeData: 'Data Notebook', themeStudio: 'Studio Canvas', themeBrutal: 'Swiss Brutal',
				themeEnterprise: 'Enterprise Clarity', themeClinical: 'Clinical Calm', themeCyber: 'Cyber Neon', themeSpatial: 'Spatial Glass',
				domProductivity: 'Productivity', domEditorial: 'Editorial', domNotes: 'Knowledge', domDev: 'DevTools', domFinance: 'Finance', domData: 'Data Science', domDesign: 'Design', domSystems: 'Systems',
				domEnterprise: 'Enterprise', domHealth: 'Healthcare', domMedia: 'Media & Game', domSpatial: 'Spatial OS',
				elevIntensityLabel: 'ELEVATION DEPTH', elevFlat: 'Flat', elevMicro: 'Micro', elevFull: 'Elevated',
				enterPreview: 'Open Preview ↗', prevBtn: '← Prev', nextBtn: 'Next →',
				repMicroTitle: 'Micro Elevation', repMicroNote: 'Subtle bevel & charcoal layers',
				repElevSpace: 'Spatial Workspace', repElevGlass: 'Flat · Micro · Elevated', repElevFocus: 'Today', repElevPlan: 'Visual Iteration Plan',
				repElevBlock: 'Color Block', repElevNav: 'Glass Header', statusDone: 'Done', statusActive: 'Active',
				repElevSchedule: 'Schedule', repElevReview: 'Review', repElevAlign: 'Tokens', repElevShip: 'Release',
				repEd1: '01 Rhythm', repEd2: '02 Hairline', repEd3: '03 Spacing', repEd4: '04 Orbs',
				repEdCallout: '1px hairline structure paired with soft gradient accents.',
				repEdCol1: 'Warm alabaster canvas and crisp ink hierarchy.', repEdCol2: 'Quiet controls that keep reading first.',
				repParch1: 'Core Principles', repParch2: 'Parchment Base', repParch3: 'Composition',
				repParchTitle: 'Order with breathing room.', repParchBody: 'Flat structural surfaces with optional lifted paper cards.',
				repParchMemo1: 'Ownership', repParchMemo1s: 'Product-owned flows', repParchMemo2: 'Consistency', repParchMemo2s: 'Shared focus & feel',
				catForm: 'Form Inputs', catButtons: 'Action Buttons', catSwitches: 'Switches & Toggles', catNav: 'Navigation & Tabs', catCommand: 'Menus & Command',
				catData: 'Data & Lists', catFeedback: 'Feedback & Alerts', catLoading: 'Loading & Skeleton', catLayout: 'Layout & Surfaces', catMedia: 'Media & Badges',
				miniInput: 'Project Name…', miniSubmit: 'Save', miniValid: 'Valid', miniPrimary: 'Primary', miniGhost: 'Ghost', miniMotion: 'Micro Motion',
				miniToggle: 'Toggle', miniTab1: 'Home', miniTab2: 'Docs', miniTab3: 'API', miniCmd: 'Command…', miniTip: '⌘C Copy Token',
				pillar1Title: 'Style-Driven Motion', pillar1Body: 'Every interactive component adapts its depth, radius, glass opacity, and easing physics to the active theme.',
				pillar2Title: 'Live Stage & Code', pillar2Body: 'Inspect each style in a two-pane workbench and copy ready-to-use React, Flutter, or HTML/CSS snippets.',
				pillar3Title: 'Global Day / Night Sync', pillar3Body: 'Themes and color modes stay decoupled—one toggle switches the page, previews, and components together.',
				closingTitle: 'Explore every component across all four styles',
				closingBody: 'Switch styles in the left navigator and inspect live motion alongside copyable code.',
				closingCta: 'Open Style Preview ↗',
				block1Title: 'Screen Preview', block2PaletteTitle: 'Color Palette', block3CompTitle: 'Component Categories', block4OthersTitle: 'Try Other Styles',
				primitiveTitle: 'Primitive Scales', semanticTitle: 'Semantic Tokens', designerPresetsTitle: 'Designer Presets', algoControlsTitle: 'Linear Algorithm Controls',
				ctrlHue: 'Accent Hue', ctrlWarmth: 'Neutral Warmth', ctrlContrast: 'Contrast Scale', ctrlSat: 'Saturation Scale',
				resetPalette: 'Reset', copyFullTokens: 'Copy Full Tokens', downloadFile: 'Export ↓',
				openColorStudioBtn: 'Color Studio ↗', openLayoutStudioBtn: 'Layout Builder ↗',
				readonlyBadge: 'READ-ONLY', editInColorStudio: 'Edit Primitives in Color Studio ↗',
				colorStudioTitle: 'Primitive Color Design', applyToPreviewBtn: 'Apply to Component Preview ↗',
				adoptLibraryTitle: 'Adopt from Existing Design Libraries', colorWheelTitle: 'Interactive Color Wheel',
				colorEngineTitle: 'Color Engine', engineOklch: 'OKLCH Equal-L', engineWheel: 'Color Wheel',
				oklchEqualLabel: 'Equal-Lightness Hue Band', oklchLLabel: 'Perceptual Lightness (L)', oklchCLabel: 'OKLCH Chroma (C)',
				harmonyAlgoTitle: 'Harmony Algorithm', harmMono: 'Mono', harmAnalogous: 'Analogous', harmComp: 'Complementary', harmTriadic: 'Triadic',
				wheelHueLabel: 'Primary Hue', wheelSatLabel: 'Primary Saturation', generatedPrimitivesTitle: 'Generated Primitive Scales',
				layoutStudioTitle: 'Layout Design Studio', lpWorkbench: 'Sidebar + Stage', lpIde: '3-Pane IDE', lpDashboard: 'Dashboard', lpClear: 'Clear',
				containersTitle: 'Containers', dragHint: 'Drag into any canvas slot or click + to insert.',
				layoutCanvasTitle: 'Layout Canvas', layoutModeEdit: 'Edit Wireframe', layoutModePreview: 'Live Preview',
				layoutSchemaTitle: 'Layout Schema', copySchemaBtn: 'Copy Schema', exportSchemaBtn: 'Export ↓',
				navThemeLabel: 'THEME', navCompLabel: 'COMPONENTS (10)', searchPlaceholder: 'Search components…',
				copyThemeCss: 'Copy Theme CSS', copyCode: 'Copy Code',
				docsTitle: 'Cross-Framework Usage & Skills',
				docsBody: 'Every theme ships versioned CSS, JS, and JSON packs with shared semantic tokens across React, Flutter, and AI Skills.',
				openPreviewBtn: 'Open Style Preview ↗', backHomeBtn: 'Back to Home',
				docCard1Title: 'Four Versioned Styles', docCard1Body: 'micro-elevation-v1, elevation-v1, modern-minimal-v1, and kallopis-v1 all pass four-mode contrast checks.',
				docCard2Title: 'Built for Vibe Coders', docCard2Body: 'Drop in style packs and AI Skills so coding agents stay inside your visual tokens and layout rules.',
				docCard3Title: 'Token & API Contracts', docCard3Body: 'Switch [data-klp-theme] and [data-klp-mode] to restyle every component consistently across frameworks.',
				footerDesc: 'Inspired by Kallopizo—a universal UI styling foundation with governed constraints, cross-framework components, style packs, and AI Skills.',
				footerIndexJson: 'Theme Index JSON ↗', footerDiscord: 'Discord (Coming Soon)', footerChangelog: 'Changelog ↗', backTop: 'Back to Top ↑',
			},
			'zh-Hant': {
				langBadge: '繁中',
				navHome: '主頁', navDesign: '設計', navUsage: '使用', navCommunity: '社群',
				headerCta: '使用 Kallopis',
				mHomeOverview: '概覽與願景', mHomeOverviewDesc: '通用介面美化基底與已規範的風格約束理念',
				mHomeStyles: '風格預覽', mHomeStylesDesc: '四套版本化風格代表畫面即時迴旋預覽',
				mHomeExamples: '元件範例', mHomeExamplesDesc: '十大元件分類縮圖，隨風格選擇即時同步換膚',
				mHomeArch: '系統架構', mHomeArchDesc: '動效曲線、跨框架對齊與深淺色同步原則',
				mDesignColor: '色票設計', mDesignColorDesc: '350+ 語意色票與四種色彩模式階調',
				mDesignComp: '元件預覽', mDesignCompDesc: '左導覽右舞台：即時操作動態元件與三語言程式',
				mDesignLayout: '布局設計', mDesignLayoutDesc: '雙區工作台、側欄導覽與響應式秩序',
				mUsageLib: '使用本庫', mUsageLibDesc: '於 React、Flutter 或純 HTML 專案引入 Kallopis',
				mUsageSkills: 'AI Skills', mUsageSkillsDesc: '專為 Vibe Coder 打造的風格約束 Skills 與主題檔',
				mUsageRef: '參考文件', mUsageRefDesc: '公開 API、Token 對應表與跨框架設計契約',
				mCommGithub: 'GitHub 專案', mCommGithubDesc: '瀏覽原始碼、風格檔案與最新版本發布',
				mCommDiscord: 'Discord 社群', mCommDiscordDesc: '設計交流、元件許願與 Vibe Coder 作品分享',
				mCommDiscuss: '社群討論區', mCommDiscussDesc: '提交新風格提案與元件篩選回饋',
				comingSoon: '即將開放',
				heroTitle: '通用介面美化基底',
				heroSubtitle: '為任何應用程式提供簡單、已規範好的風格約束能力；內建跨框架元件、版本化風格檔案與 AI Skills，讓 Vibe Coder 與產品團隊開箱即用。',
				heroCta: '使用 Kallopis',
				heroWinTitle: 'Kallopis 工作區 · 風格語意系統',
				heroNavAll: '全部風格', heroNavTokens: '語意色票', heroNavComp: '公開元件', heroNavSkills: 'AI Skills',
				heroCard1: '溫潤炭灰微亮邊，專為長時專注工作台打造。',
				heroCard2: '飽滿色塊容器搭配半透明磨砂玻璃層次。',
				heroCard3: '1px 編輯細線分隔與克制留白排版。',
				heroCard4: '安定暖紙層次與低對比中性控制項。',
				meaningLine1: 'Kallopis 源自希臘文 Kallopizo，',
				meaningLine2: '為每個介面注入秩序與美感。',
				icon1: '風格約束', icon2: '語意色票', icon3: '跨框架元件', icon4: '風格檔案', icon5: 'AI Skills',
				stylePreviewTitle: '風格預覽',
				examplesTitle: '元件範例',
				archTitle: '秩序留給系統，自由還給產品',
				themeMicro: '微立體', themeElev: '立體浮層', themeMinimal: '編輯簡約', themeParchment: '暖紙書房',
				themeDev: '開發精密', themeQuant: '金融終端', themeData: '資料筆記', themeStudio: '設計畫布', themeBrutal: '瑞士粗獷',
				themeEnterprise: '企業清晰', themeClinical: '醫療潔淨', themeCyber: '霓虹電競', themeSpatial: '液態玻璃',
				domProductivity: '生產力', domEditorial: '編輯出版', domNotes: '知識筆記', domDev: '程式開發', domFinance: '金融交易', domData: '資料科學', domDesign: '設計工具', domSystems: '系統工程',
				domEnterprise: '企業 SaaS', domHealth: '醫療生技', domMedia: '影音遊戲', domSpatial: '空間運算',
				elevIntensityLabel: '立體程度', elevFlat: '平面', elevMicro: '微立體', elevFull: '立體',
				enterPreview: '進入預覽 ↗', prevBtn: '← 上一套', nextBtn: '下一套 →',
				repMicroTitle: '微立體工作台', repMicroNote: '低浮層微亮邊與炭灰層次',
				repElevSpace: '空間工作區', repElevGlass: '平面 · 微立體 · 立體', repElevFocus: '今日重點', repElevPlan: '產品視覺迭代計畫',
				repElevBlock: '色塊分層', repElevNav: '玻璃導覽', statusDone: '完成', statusActive: '進行中',
				repElevSchedule: '快速日程', repElevReview: '設計評審', repElevAlign: '元件對齊', repElevShip: '主題發布',
				repEd1: '01 排版節奏', repEd2: '02 細線秩序', repEd3: '03 留白比例', repEd4: '04 光暈點綴',
				repEdCallout: '1px 細線分隔搭配柔和漸層光暈，專注閱讀體驗。',
				repEdCol1: '米白畫布與暖炭墨黑，保有報刊般清晰結構。', repEdCol2: '低干擾控制項，讓正文內容成為視覺主角。',
				repParch1: '核心設計原則', repParch2: '暖紙視覺基準', repParch3: '元件組合指南',
				repParchTitle: '有秩序，也有空間。', repParchBody: '結構保持平整，獨立紙片才決定是否微浮。',
				repParchMemo1: '產品組合權', repParchMemo1s: '自由安排畫面流程', repParchMemo2: '一致手感', repParchMemo2s: '共用鍵盤焦點秩序',
				catForm: '表單輸入', catButtons: '互動按鈕', catSwitches: '切換控制', catNav: '導覽分頁', catCommand: '選單命令',
				catData: '資料呈現', catFeedback: '回饋提示', catLoading: '載入骨架', catLayout: '布局容器', catMedia: '媒體標籤',
				miniInput: '專案名稱…', miniSubmit: '送出', miniValid: '已驗證', miniPrimary: '主要', miniGhost: '次要', miniMotion: '微互動回饋',
				miniToggle: '開關', miniTab1: '首頁', miniTab2: '文件', miniTab3: 'API', miniCmd: '搜尋命令…', miniTip: '⌘C 複製色票',
				pillar1Title: '風格驅動動態手感', pillar1Body: '同一款互動元件會依所選風格自動調整陰影層次、圓角張力、玻璃透光與彈性曲線。',
				pillar2Title: '左互動、右多語言程式', pillar2Body: '進入獨立風格預覽頁即可逐一操作元件，並直接複製 React、Flutter 或 HTML/CSS 實作。',
				pillar3Title: '深淺色全域同步', pillar3Body: '風格與明暗完全解耦；頂部開關一次切換網頁、風格卡片與所有元件實景。',
				closingTitle: '體驗所有動態元件在四套風格下的變化',
				closingBody: '左側 Navigator 切換元件，右側即時操作並複製多語言程式碼。',
				closingCta: '開啟獨立風格預覽 ↗',
				block1Title: '畫面預覽', block2PaletteTitle: '色票設計', block3CompTitle: '元件類別', block4OthersTitle: '嘗試其他風格',
				primitiveTitle: 'Primitive 基礎色階', semanticTitle: 'Semantic 語意色票', designerPresetsTitle: '設計師調色組合', algoControlsTitle: '線性計算演算法微調',
				ctrlHue: '強調色相', ctrlWarmth: '中性色溫', ctrlContrast: '對比強度', ctrlSat: '彩度比例',
				resetPalette: '重設', copyFullTokens: '複製整套 Token', downloadFile: '導出檔案 ↓',
				openColorStudioBtn: '色票設計 ↗', openLayoutStudioBtn: '布局設計 ↗',
				readonlyBadge: '唯讀預覽', editInColorStudio: '前往色票設計頁編輯基礎色 ↗',
				colorStudioTitle: '色票設計工作台（Primitive）', applyToPreviewBtn: '套用至元件預覽 ↗',
				adoptLibraryTitle: '沿用現有設計庫色票', colorWheelTitle: '互動色環選色器',
				colorEngineTitle: '色彩計算引擎', engineOklch: 'OKLCH 同亮轉換', engineWheel: '色環選色',
				oklchEqualLabel: '感知等亮色相帶（鎖定 L）', oklchLLabel: '感知亮度 (L)', oklchCLabel: 'OKLCH 彩度 (C)',
				harmonyAlgoTitle: '色彩和聲演算法', harmMono: '單色階', harmAnalogous: '類比色', harmComp: '互補色', harmTriadic: '三角色',
				wheelHueLabel: '主色色相', wheelSatLabel: '主色彩度', generatedPrimitivesTitle: '即時生成的 Primitive 基礎色階',
				layoutStudioTitle: '線上布局設計工作台', lpWorkbench: '雙區工作台', lpIde: '三欄 IDE', lpDashboard: '儀表板', lpClear: '清空畫布',
				containersTitle: '可拖放容器', dragHint: '拖曳至畫布任一插槽，或點擊 + 直接加入。',
				layoutCanvasTitle: '布局畫布', layoutModeEdit: '編輯線框', layoutModePreview: '即時預覽',
				layoutSchemaTitle: '布局 Schema', copySchemaBtn: '複製 Schema', exportSchemaBtn: '匯出 ↓',
				navThemeLabel: '選擇風格 THEME', navCompLabel: '動態與互動元件 (10)', searchPlaceholder: '搜尋元件名稱…',
				copyThemeCss: '複製主題 CSS', copyCode: '複製程式碼',
				docsTitle: '跨框架使用指南與 AI Skills',
				docsBody: '所有主題皆提供版本化 CSS、JS 與 JSON 檔案，並於 React、Flutter 與 AI Skills 共用同一套語意命名。',
				openPreviewBtn: '前往風格預覽 ↗', backHomeBtn: '返回主頁',
				docCard1Title: '四套版本化風格', docCard1Body: 'micro-elevation-v1、elevation-v1、modern-minimal-v1、kallopis-v1 皆通過四模式對比驗證。',
				docCard2Title: '專為 Vibe Coder 設計', docCard2Body: '直接匯入風格檔案與 AI Skills，讓 AI 開發時嚴格遵守視覺規範與布局約束。',
				docCard3Title: 'Token 與 API 契約', docCard3Body: '透過 [data-klp-theme] 與 [data-klp-mode] 即可跨框架一致切換全部元件風格。',
				footerDesc: '源自希臘文 Kallopizo——通用介面美化基底，提供已規範好的風格約束、跨框架元件、版本化風格檔案與 AI Skills。',
				footerIndexJson: '主題索引 JSON ↗', footerDiscord: 'Discord（即將開放）', footerChangelog: '版本紀錄 ↗', backTop: '回到頁首 ↑',
			},
		};

		let currentLang = 'en';
		let currentRoute = 'home';
		let currentMode = 'light';
		let activeCarouselIdx = 0;
		let selectedThemeId = themes[0].id;
		let selectedCompId = motionComponents[0].id;
		let selectedVariantIdx = 0;
		let selectedLang = 'react';

		const rootEl = document.documentElement;
		const toggleBtn = document.getElementById('global-mode-toggle');
		const langToggleBtn = document.getElementById('lang-toggle-btn');
		const langToggleLabel = document.getElementById('lang-toggle-label');
		const refDemoCanvas = document.getElementById('ref-demo-canvas');

		// 完整已註冊元件清冊（涵蓋 react/src 全部公開 Klp* 元件，沒列於此視為未註冊）
		const registeredRegistry = [
			{
				id: 'form',
				title: { en: 'Form Inputs', 'zh-Hant': '表單輸入' },
				items: [
					{ id: 'KlpTextField', desc: { en: 'Single-line text input with floating label and live validation.', 'zh-Hant': '單行文字輸入欄，支援浮動標籤與即時驗證。' } },
					{ id: 'KlpTextArea', desc: { en: 'Multi-line text area for long-form notes and descriptions.', 'zh-Hant': '多行文字輸入區塊，適用長文備註與說明。' } },
					{ id: 'KlpSwitch', desc: { en: 'Binary toggle switch with tactile spring thumb.', 'zh-Hant': '二元切換開關（Toggle），具彈性滑塊手感。' } },
					{ id: 'KlpCheckbox', desc: { en: 'Checkbox control supporting checked and indeterminate states.', 'zh-Hant': '核取方塊控制項，支援勾選與半選狀態。' } },
					{ id: 'KlpRadioGroup', desc: { en: 'Mutually exclusive radio selection group with keyboard arrows.', 'zh-Hant': '單選按鈕群組，支援鍵盤方向鍵切換。' } },
					{ id: 'KlpSelect', desc: { en: 'Dropdown select control with accessible popup option list.', 'zh-Hant': '下拉選單（Dropdown），具無障礙彈出清單。' } },
					{ id: 'KlpMultiSelect', desc: { en: 'Multi-option token selector with removable chips.', 'zh-Hant': '多選標籤選擇器，支援即時增刪項目。' } },
					{ id: 'KlpComboBox', desc: { en: 'Filterable combobox combining text input and dropdown suggestions.', 'zh-Hant': '可篩選複合輸入框，結合搜尋與下拉建議。' } },
					{ id: 'KlpSlider', desc: { en: 'Continuous numeric slider with live value readout.', 'zh-Hant': '連續數值滑桿（Slider），即時回報數值。' } },
				],
			},
			{
				id: 'buttons',
				title: { en: 'Action Buttons', 'zh-Hant': '互動按鈕' },
				items: [
					{ id: 'KlpButton', desc: { en: 'Primary, secondary, and ghost action buttons with micro-motion.', 'zh-Hant': '主要、次要與透明動作按鈕，內建按壓與微互動回饋。' } },
					{ id: 'KlpIconButton', desc: { en: 'Compact icon-only button with morph/spin active states.', 'zh-Hant': '精簡純圖示按鈕，支援旋轉與狀態變形。' } },
					{ id: 'KlpSplitButton', desc: { en: 'Primary action paired with a secondary dropdown trigger.', 'zh-Hant': '主動作與附屬下拉選項結合的分割按鈕。' } },
					{ id: 'KlpSystemAction', desc: { en: 'Standardized system action trigger for dialogs and toolbars.', 'zh-Hant': '對話框與工具列專用的標準系統動作按鈕。' } },
				],
			},
			{
				id: 'navigation',
				title: { en: 'Navigation & Tabs', 'zh-Hant': '導覽分頁' },
				items: [
					{ id: 'KlpTabs', desc: { en: 'Animated sliding-pill tab bar with keyboard navigation.', 'zh-Hant': '具備滑動指示器的分頁導覽列，支援鍵盤操作。' } },
					{ id: 'KlpBreadcrumb', desc: { en: 'Hierarchical path trail for nested workspaces.', 'zh-Hant': '階層路徑麵包屑導覽。' } },
					{ id: 'KlpPagination', desc: { en: 'Compact page switcher for datasets and tables.', 'zh-Hant': '資料集與表格分頁切換控制項。' } },
					{ id: 'KlpLink', desc: { en: 'Semantic inline and navigation link with focus ring.', 'zh-Hant': '語意行內與導覽連結元件。' } },
					{ id: 'KlpAccordion', desc: { en: 'Expandable disclosure sections for structured content.', 'zh-Hant': '可折疊展開的結構化內容手風琴。' } },
				],
			},
			{
				id: 'command',
				title: { en: 'Menus & Command', 'zh-Hant': '選單命令' },
				items: [
					{ id: 'KlpRegisteredCommandPalette', desc: { en: 'Keyboard-first ⌘K command palette bound to command registry.', 'zh-Hant': '鍵盤優先的 ⌘K 命令面板，綁定命令登錄表。' } },
					{ id: 'KlpRegisteredCommandMenu', desc: { en: 'Structured menu surface populated from registered commands.', 'zh-Hant': '依已註冊命令自動生成的選單面板。' } },
					{ id: 'KlpRegisteredCommandPopup', desc: { en: 'Contextual popup menu anchored to trigger controls.', 'zh-Hant': '依觸發控制項定位的情境彈出選單。' } },
					{ id: 'KlpRegisteredCommandToolbar', desc: { en: 'Horizontal command toolbar for workbench actions.', 'zh-Hant': '工作台專用的水平命令工具列。' } },
					{ id: 'KlpCommandShortcutHost', desc: { en: 'Global shortcut listener and keymap coordinator.', 'zh-Hant': '全域快捷鍵監聽與鍵位協調宿主。' } },
					{ id: 'KlpPopover', desc: { en: 'Floating anchored popover surface.', 'zh-Hant': '錨定式懸浮彈出視窗容器。' } },
					{ id: 'KlpRibbon', desc: { en: 'Grouped desktop ribbon toolbar for rich editors.', 'zh-Hant': '分組式桌面功能區工具列。' } },
				],
			},
			{
				id: 'data',
				title: { en: 'Data & Lists', 'zh-Hant': '資料呈現' },
				items: [
					{ id: 'KlpTable', desc: { en: 'Structured data table with tabular numeric alignment.', 'zh-Hant': '結構化資料表，內建等寬數值對齊。' } },
					{ id: 'KlpDataGrid', desc: { en: 'High-density interactive data grid with selection.', 'zh-Hant': '高密度互動資料網格，支援列選取。' } },
					{ id: 'KlpList', desc: { en: 'Accessible vertical list with hover/selected surface states.', 'zh-Hant': '具一致懸停與選取層次的清單元件。' } },
					{ id: 'KlpVirtualList', desc: { en: 'Windowed virtualized list for large datasets.', 'zh-Hant': '大資料量專用的虛擬捲動清單。' } },
					{ id: 'KlpTree', desc: { en: 'Hierarchical expandable tree view.', 'zh-Hant': '可展開收合的階層樹狀檢視。' } },
					{ id: 'KlpTreeGrid', desc: { en: 'Multi-column hierarchical tree grid.', 'zh-Hant': '結合樹狀階層與多欄資料的樹狀網格。' } },
					{ id: 'KlpFileExplorer', desc: { en: 'Direct file explorer projecting sections and item callbacks.', 'zh-Hant': '直接投影區段與檔案項目的檔案總管元件。' } },
				],
			},
			{
				id: 'feedback',
				title: { en: 'Feedback & Alerts', 'zh-Hant': '回饋提示' },
				items: [
					{ id: 'KlpTooltip', desc: { en: 'Hover/focus tooltip bubble with crisp spring entry.', 'zh-Hant': '懸停與鍵盤聚焦提示氣泡。' } },
					{ id: 'KlpAlert', desc: { en: 'Inline semantic alert banner (info, success, warning, danger).', 'zh-Hant': '行內語意警示橫幅（資訊、成功、警告、危險）。' } },
					{ id: 'KlpDialog', desc: { en: 'Modal dialog with scrim and focus trap.', 'zh-Hant': '具遮罩與焦點鎖定的模態對話框。' } },
					{ id: 'KlpToastRegion', desc: { en: 'Non-blocking transient notification region.', 'zh-Hant': '非阻塞式即時通知浮層區。' } },
					{ id: 'KlpProgress', desc: { en: 'Determinate and indeterminate progress bar.', 'zh-Hant': '明確與不確定狀態進度條。' } },
				],
			},
			{
				id: 'loading',
				title: { en: 'Loading & Skeleton', 'zh-Hant': '載入骨架' },
				items: [
					{ id: 'KlpSkeleton', desc: { en: 'Shimmer skeleton placeholder with blur-to-focus reveal.', 'zh-Hant': '掃光骨架屏佔位元件，載入後柔焦呈現。' } },
					{ id: 'KlpSpinner', desc: { en: 'Compact animated loading spinner.', 'zh-Hant': '精簡旋轉載入指示器。' } },
					{ id: 'KlpEmptyState', desc: { en: 'Structured empty state container with primary action.', 'zh-Hant': '含引導動作的空狀態佔位容器。' } },
				],
			},
			{
				id: 'layout',
				title: { en: 'Layout & Surfaces', 'zh-Hant': '布局容器' },
				items: [
					{ id: 'KlpSurface', desc: { en: 'Semantic elevation surface container.', 'zh-Hant': '語意表面層次基礎容器。' } },
					{ id: 'KlpCard', desc: { en: 'Structured content card adapting to active theme.', 'zh-Hant': '依主題自動適配陰影與圓角的內容卡片。' } },
					{ id: 'KlpFrame', desc: { en: 'Framed document and panel boundary container.', 'zh-Hant': '文件與面板外框容器。' } },
					{ id: 'KlpDrawer', desc: { en: 'Slide-in side drawer supporting push and glass overlay.', 'zh-Hant': '側邊滑入抽屜，支援推動與磨砂覆蓋。' } },
					{ id: 'KlpAppLayout', desc: { en: 'Top-level application shell layout.', 'zh-Hant': '應用程式頂層殼層布局。' } },
					{ id: 'KlpDockLayout', desc: { en: 'Resizable multi-pane dock layout host.', 'zh-Hant': '可調寬度的多面板停靠工作台布局。' } },
					{ id: 'KlpModernProductivityLayout', desc: { en: 'Two-pane sidebar + stage productivity layout.', 'zh-Hant': '雙區側欄＋舞台生產力工作台布局。' } },
					{ id: 'KlpWorkspace', desc: { en: 'Workspace root coordinating panels and focus.', 'zh-Hant': '協調多面板與焦點的工作區根容器。' } },
					{ id: 'KlpContentHost', desc: { en: 'Main stage content host.', 'zh-Hant': '主舞台內容承載容器。' } },
					{ id: 'KlpLayoutRow', desc: { en: 'Horizontal flex layout primitive.', 'zh-Hant': '水平排列基礎布局原語。' } },
					{ id: 'KlpLayoutColumn', desc: { en: 'Vertical flex layout primitive.', 'zh-Hant': '垂直排列基礎布局原語。' } },
					{ id: 'KlpLayoutPane', desc: { en: 'Resizable pane slot inside layouts.', 'zh-Hant': '布局內可調尺寸的面板插槽。' } },
					{ id: 'KlpLayoutDivider', desc: { en: 'Semantic hairline divider between panes.', 'zh-Hant': '面板間語意分隔線。' } },
					{ id: 'KlpLayoutSpacer', desc: { en: 'Token-governed spacing primitive.', 'zh-Hant': '依語意間距驅動的留白原語。' } },
					{ id: 'KlpSeparator', desc: { en: 'Visual separator rule.', 'zh-Hant': '視覺分隔細線元件。' } },
					{ id: 'KlpStatusBar', desc: { en: 'Bottom workbench status bar.', 'zh-Hant': '工作台底部狀態列。' } },
				],
			},
			{
				id: 'media',
				title: { en: 'Media & Badges', 'zh-Hant': '媒體標籤' },
				items: [
					{ id: 'KlpAvatar', desc: { en: 'User monogram and image avatar.', 'zh-Hant': '使用者頭像與字母縮寫徽章。' } },
					{ id: 'KlpBadge', desc: { en: 'Semantic status and category badge.', 'zh-Hant': '語意狀態與分類標籤。' } },
					{ id: 'KlpText', desc: { en: 'Typography primitive enforcing scale and contrast.', 'zh-Hant': '強制對齊字級與對比度的文字原語。' } },
					{ id: 'KlpThemeProvider', desc: { en: 'Root semantic theme and mode context provider.', 'zh-Hant': '根部語意主題與四模式上下文提供者。' } },
				],
			},
		];
		let activeRefCatId = 'form';
		let activeRefCompId = 'KlpTextField';

		function applyLanguage(lang) {
			currentLang = lang;
			rootEl.lang = lang;
			rootEl.dataset.klpLang = lang;
			const dict = i18n[lang] || i18n.en;
			langToggleLabel.textContent = dict.langBadge;
			for (const node of document.querySelectorAll('[data-i18n]')) {
				const key = node.dataset.i18n;
				if (typeof dict[key] === 'string') node.textContent = dict[key];
			}
			const searchInput = document.getElementById('ref-search-input');
			if (searchInput) searchInput.placeholder = dict.searchPlaceholder;
			if (currentRoute === 'style-preview') renderStylePreviewPage();
			if (currentRoute === 'color-design') renderColorDesignPage();
			if (currentRoute === 'layout-design') renderLayoutDesignPage();
			if (currentRoute === 'docs') renderReferencePage();
		}

		langToggleBtn.addEventListener('click', () => applyLanguage(currentLang === 'en' ? 'zh-Hant' : 'en'));

		let selectedTokenFmt = 'css';
		let elevationLevel = 'elevated';
		const interactiveRepStage = document.getElementById('interactive-rep-stage');

		function resolveEffectiveTheme(theme) {
			if (theme.adjustableElevation && elevationLevel === 'flat') {
				return { id: 'elevation-v1', family: 'modern-minimal', elevDepth: 'flat', cssPath: 'styles/themes/elevation-v1.css', jsPath: 'styles/themes/elevation-v1.js', jsonPath: 'styles/themes/elevation-v1.json' };
			}
			if (theme.adjustableElevation && elevationLevel === 'micro') {
				return { id: 'micro-elevation-v1', family: 'micro-elevation', elevDepth: 'micro', cssPath: 'styles/themes/micro-elevation-v1.css', jsPath: 'styles/themes/micro-elevation-v1.js', jsonPath: 'styles/themes/micro-elevation-v1.json' };
			}
			return { ...theme, elevDepth: theme.adjustableElevation ? 'elevated' : '' };
		}

		for (const lvlBtn of document.querySelectorAll('#elevation-level-tabs [data-elev-level]')) {
			lvlBtn.addEventListener('click', () => {
				elevationLevel = lvlBtn.dataset.elevLevel;
				for (const b of document.querySelectorAll('#elevation-level-tabs [data-elev-level]')) {
					b.setAttribute('aria-selected', String(b.dataset.elevLevel === elevationLevel));
				}
				renderStylePreviewPage();
			});
		}

		function applyGlobalMode(mode) {
			currentMode = mode;
			rootEl.dataset.klpMode = mode;
			toggleBtn.setAttribute('aria-checked', String(mode === 'dark'));
			for (const canvas of document.querySelectorAll('.rep-canvas, .category-visual')) {
				canvas.dataset.klpMode = mode;
			}
			if (refDemoCanvas) refDemoCanvas.dataset.klpMode = mode;
			if (interactiveRepStage) interactiveRepStage.dataset.klpMode = mode;
			const liveDock = document.getElementById('preview-live-components-dock');
			if (liveDock) liveDock.dataset.klpMode = mode;
			const layoutCanvas = document.getElementById('layout-drop-canvas');
			if (layoutCanvas) layoutCanvas.dataset.klpMode = mode;
			if (currentRoute === 'docs') renderReferenceStage();
			if (currentRoute === 'color-design') renderColorDesignPage();
		}

		function toggleModeWithCircleReveal() {
			const nextMode = currentMode === 'light' ? 'dark' : 'light';
			const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
			if (!document.startViewTransition || reduceMotion) {
				applyGlobalMode(nextMode);
				return;
			}
			const rect = toggleBtn.getBoundingClientRect();
			const cx = rect.left + rect.width / 2;
			const cy = rect.top + rect.height / 2;
			const endRadius = Math.hypot(Math.max(cx, window.innerWidth - cx), Math.max(cy, window.innerHeight - cy));
			const transition = document.startViewTransition(() => applyGlobalMode(nextMode));
			transition.ready.then(() => {
				document.documentElement.animate(
					{ clipPath: [`circle(0px at ${cx}px ${cy}px)`, `circle(${endRadius}px at ${cx}px ${cy}px)`] },
					{ duration: 460, easing: 'cubic-bezier(0.22, 1, 0.36, 1)', pseudoElement: '::view-transition-new(root)' }
				);
			});
		}
		toggleBtn.addEventListener('click', toggleModeWithCircleReveal);

		// 覆蓋式 Header Hover 展開與平滑收回動畫（延遲隱藏 panel，確保 grid-template-rows 完整動畫收回）
		const topbarEl = document.getElementById('site-topbar');
		const navMenuBtns = [...document.querySelectorAll('.topbar-nav button[data-menu]')];
		const megaPanels = [...document.querySelectorAll('.mega-panel[data-panel]')];
		let openMenuKey = null;
		let closeTimer = null;

		function openMegaMenu(menuKey) {
			if (closeTimer) {
				clearTimeout(closeTimer);
				closeTimer = null;
			}
			openMenuKey = menuKey;
			megaPanels.forEach(panel => { panel.hidden = panel.dataset.panel !== menuKey; });
			navMenuBtns.forEach(btn => btn.setAttribute('aria-expanded', String(btn.dataset.menu === menuKey)));
			requestAnimationFrame(() => topbarEl.classList.add('expanded'));
		}
		function closeMegaMenu() {
			openMenuKey = null;
			topbarEl.classList.remove('expanded');
			navMenuBtns.forEach(btn => btn.setAttribute('aria-expanded', 'false'));
			if (closeTimer) clearTimeout(closeTimer);
			closeTimer = setTimeout(() => {
				if (!openMenuKey) megaPanels.forEach(panel => { panel.hidden = true; });
				closeTimer = null;
			}, 290);
		}

		// Hero 大背景動態滑鼠跟隨（監聽 window pointermove/mousemove，平滑阻尼 60fps 跟隨）
		const heroBoxEl = document.getElementById('hero-top');
		if (heroBoxEl) {
			let targetX = 0, targetY = 0, currX = 0, currY = 0;
			let targetPx = 50, targetPy = 42, currPx = 50, currPy = 42;
			let rafId = null;

			function tickHeroAurora() {
				currX += (targetX - currX) * 0.1;
				currY += (targetY - currY) * 0.1;
				currPx += (targetPx - currPx) * 0.12;
				currPy += (targetPy - currPy) * 0.12;
				heroBoxEl.style.setProperty('--mx', currX.toFixed(4));
				heroBoxEl.style.setProperty('--my', currY.toFixed(4));
				heroBoxEl.style.setProperty('--cursor-x', `${currPx.toFixed(2)}%`);
				heroBoxEl.style.setProperty('--cursor-y', `${currPy.toFixed(2)}%`);
				if (Math.abs(targetX - currX) > 0.001 || Math.abs(targetY - currY) > 0.001 || Math.abs(targetPx - currPx) > 0.05) {
					rafId = requestAnimationFrame(tickHeroAurora);
				} else {
					rafId = null;
				}
			}

			function handleHeroPointer(e) {
				const rect = heroBoxEl.getBoundingClientRect();
				if (!rect.width || !rect.height) return;
				const nx = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
				const ny = Math.max(0, Math.min(1, (e.clientY - rect.top) / rect.height));
				targetX = (nx - 0.5) * 2;
				targetY = (ny - 0.5) * 2;
				targetPx = nx * 100;
				targetPy = ny * 100;
				if (!rafId) rafId = requestAnimationFrame(tickHeroAurora);
			}

			window.addEventListener('pointermove', handleHeroPointer, { passive: true });
			window.addEventListener('mousemove', handleHeroPointer, { passive: true });
			heroBoxEl.addEventListener('pointerleave', () => {
				targetX = 0; targetY = 0; targetPx = 50; targetPy = 42;
				if (!rafId) rafId = requestAnimationFrame(tickHeroAurora);
			});
		}
		navMenuBtns.forEach(btn => {
			btn.addEventListener('mouseenter', () => openMegaMenu(btn.dataset.menu));
			btn.addEventListener('focus', () => openMegaMenu(btn.dataset.menu));
		});
		topbarEl.addEventListener('mouseleave', closeMegaMenu);
		document.addEventListener('keydown', e => { if (e.key === 'Escape') closeMegaMenu(); });
		document.addEventListener('click', e => { if (!topbarEl.contains(e.target)) closeMegaMenu(); });

		function navigateTo(route, themeId) {
			currentRoute = route;
			if (themeId) selectedThemeId = themeId;
			for (const pane of document.querySelectorAll('.view-pane')) pane.hidden = pane.id !== `view-${route}`;
			const isDesignRoute = route === 'style-preview' || route === 'color-design' || route === 'layout-design';
			navMenuBtns.forEach(btn => {
				const isCurrent = btn.dataset.menu === 'design' ? isDesignRoute : btn.dataset.route === route;
				btn.setAttribute('aria-current', isCurrent ? 'page' : 'false');
			});
			if (route === 'style-preview') renderStylePreviewPage();
			if (route === 'color-design') renderColorDesignPage();
			if (route === 'layout-design') renderLayoutDesignPage();
			if (route === 'docs') renderReferencePage();
			closeMegaMenu();
			window.scrollTo({ top: 0, behavior: 'smooth' });
		}

		for (const el of document.querySelectorAll('[data-jump-home]')) {
			el.addEventListener('click', () => {
				const sel = el.dataset.jumpHome;
				navigateTo('home');
				requestAnimationFrame(() => { const t = document.querySelector(sel); if (t) t.scrollIntoView({ behavior: 'smooth' }); });
			});
		}
		for (const el of document.querySelectorAll('[data-open-preview]')) el.addEventListener('click', () => navigateTo('style-preview', el.dataset.openPreview));
		for (const el of document.querySelectorAll('[data-open-route]')) el.addEventListener('click', () => navigateTo(el.dataset.openRoute));
		for (const el of document.querySelectorAll('[data-open-docs]')) el.addEventListener('click', () => navigateTo('docs'));
		document.getElementById('footer-back-top').addEventListener('click', e => { e.preventDefault(); window.scrollTo({ top: 0, behavior: 'smooth' }); });
		document.getElementById('brand-home-btn').addEventListener('click', () => navigateTo('home'));
		document.getElementById('preview-back-home').addEventListener('click', () => navigateTo('home'));
		document.getElementById('header-preview-btn').addEventListener('click', () => navigateTo('style-preview', selectedThemeId));
		document.getElementById('hero-open-style-btn').addEventListener('click', () => navigateTo('style-preview', selectedThemeId));
		document.getElementById('docs-go-preview').addEventListener('click', () => navigateTo('style-preview', selectedThemeId));
		document.getElementById('docs-go-home').addEventListener('click', () => navigateTo('home'));

		// 主頁 4 欄風格 Grid 點擊進入該風格的元件預覽頁
		for (const gridCard of document.querySelectorAll('.style-grid-card[data-theme-id]')) {
			gridCard.addEventListener('click', () => navigateTo('style-preview', gridCard.dataset.themeId));
		}

		const categoryVisuals = [...document.querySelectorAll('.category-visual')];
		function syncCategoryExamples(theme) {
			for (const el of categoryVisuals) {
				el.dataset.klpTheme = theme.id;
				el.dataset.styleFamily = theme.family;
				el.dataset.klpMode = currentMode;
				el.dataset.elevDepth = theme.elevDepth || '';
			}
		}

		// 點擊設計頁的元件類別卡片 → 進入「參考文件」並展開該分類與其第一個已註冊元件
		for (const catCard of document.querySelectorAll('.category-card[data-category-id]')) {
			catCard.addEventListener('click', () => {
				const catId = catCard.dataset.categoryId;
				const cat = registeredRegistry.find(c => c.id === catId) || registeredRegistry[0];
				activeRefCatId = cat.id;
				activeRefCompId = catCard.dataset.categoryComp || cat.items[0].id;
				navigateTo('docs');
			});
		}

		// 區塊 1：以本庫 Klp 元件（.klp-theme / .klp-workspace / .klp-frame / .klp-explorer / .klp-dock-tabs / .klp-card / .klp-button / .klp-badge）為基底擴充的三欄式「畫面預覽」
		function renderInteractiveRepScreen(theme) {
			interactiveRepStage.dataset.klpTheme = theme.id;
			interactiveRepStage.dataset.klpVisualStyle = theme.family;
			interactiveRepStage.dataset.klpVisualMode = currentMode;
			interactiveRepStage.dataset.klpMode = currentMode;
			interactiveRepStage.dataset.styleFamily = theme.family;
			interactiveRepStage.dataset.elevDepth = theme.elevDepth || '';
			const isEn = currentLang === 'en';
			const navItems = isEn
				? ['Overview', 'Design Tokens', 'Components', 'Workflows', 'Analytics']
				: ['專案總覽', '設計語意', '元件清單', '工作流程', '數據分析'];
			const tabs = isEn ? ['Workspace', 'Live Table', 'Spec Notes'] : ['工作舞台', '即時資料表', '規格筆記'];
			const rows = isEn
				? [
					{ title: 'Semantic surface contrast audit', tag: 'Done', metric: '12.4:1' },
					{ title: 'Cross-framework motion tokens', tag: 'Active', metric: '60 fps' },
					{ title: 'AI Skills style pack bundle', tag: 'Ready', metric: 'v1.0.0' },
				]
				: [
					{ title: '語意表面對比度驗證', tag: '完成', metric: '12.4:1' },
					{ title: '跨框架動態曲線規範', tag: '進行中', metric: '60 fps' },
					{ title: 'AI Skills 主題約束包', tag: '就緒', metric: 'v1.0.0' },
				];
			let activeNav = 0, activeTab = 0, selectedRow = 0;

			function drawRichApp() {
				interactiveRepStage.innerHTML = `
					<div class="klp-theme rich-preview-app" data-klp-component="KlpAppLayout">
						<div class="klp-surface-base rich-app-bar">
							<div class="rich-app-bar-left">
								<div class="hero-win-dots" aria-hidden="true"><i></i><i></i><i></i></div>
								<strong class="klp-text klp-text-body-strong">${theme.name[currentLang] || theme.name.en}</strong>
								<span class="klp-badge klp-badge-info" data-klp-component="KlpBadge">${theme.id}</span>
							</div>
							<div class="rich-app-bar-right">
								<span class="klp-surface-inset rich-cmd-pill">⌘K ${isEn ? 'Quick Command' : '快速命令'}</span>
								<button type="button" class="klp-button klp-button-primary klp-size-sm" data-klp-component="KlpButton">${isEn ? 'Publish' : '發布風格'}</button>
							</div>
						</div>
						<div class="klp-workspace rich-app-grid" data-klp-component="KlpWorkspace">
							<aside class="klp-frame klp-frame-sidebar rich-pane" data-klp-component="KlpFileExplorer">
								<span class="klp-text klp-text-label klp-tone-muted">${isEn ? 'NAVIGATION' : '工作區導覽'}</span>
								<div class="klp-explorer" style="padding:0;">
									<ul>
										${navItems.map((item, i) => `<li><button type="button" class="klp-explorer-row" data-rn="${i}" aria-pressed="${i === activeNav}">${item}</button></li>`).join('')}
									</ul>
								</div>
								<div style="margin-top:auto;padding-top:10px;display:grid;gap:6px;">
									<div style="display:flex;justify-content:space-between;font-size:11px;" class="klp-tone-muted"><span>${isEn ? 'Token Coverage' : '語意覆蓋率'}</span><strong>100%</strong></div>
									<div class="rich-progress" data-klp-component="KlpProgress"><i style="width:94%;"></i></div>
								</div>
							</aside>

							<div class="klp-frame klp-surface-stage rich-pane stage" data-klp-component="KlpContentHost">
								<div class="klp-dock-tabs rich-stage-tabs" role="tablist" data-klp-component="KlpTabs">
									${tabs.map((t, i) => `<button type="button" class="klp-dock-tab rich-stage-tab ${i === activeTab ? 'active' : ''}" role="tab" aria-selected="${i === activeTab}" data-rt="${i}">${t}</button>`).join('')}
								</div>
								<div class="klp-frame-body rich-stage-body">
									<div class="rich-kpi-row">
										<div class="klp-card klp-surface-component rich-kpi-card" data-klp-component="KlpCard"><span class="klp-text klp-text-caption klp-tone-muted">${isEn ? 'Semantic Tokens' : '語意色票'}</span><strong class="klp-text klp-text-h3">350</strong></div>
										<div class="klp-card klp-surface-component rich-kpi-card" data-klp-component="KlpCard"><span class="klp-text klp-text-caption klp-tone-muted">${isEn ? 'Components' : '公開元件'}</span><strong class="klp-text klp-text-h3">60</strong></div>
										<div class="klp-card klp-surface-component rich-kpi-card" data-klp-component="KlpCard"><span class="klp-text klp-text-caption klp-tone-muted">${isEn ? 'Color Modes' : '色彩模式'}</span><strong class="klp-text klp-text-h3">4</strong></div>
									</div>
									<div class="rich-list-table" data-klp-component="KlpList">
										${rows.map((r, i) => `<button type="button" class="klp-card klp-surface-component rich-row-btn ${i === selectedRow ? 'selected' : ''}" data-rr="${i}"><span><strong class="klp-text klp-text-body-strong">${r.title}</strong></span><span style="display:flex;align-items:center;gap:8px;"><span class="klp-badge klp-badge-success">${r.tag}</span><code class="klp-text-code klp-tone-muted">${r.metric}</code></span></button>`).join('')}
									</div>
								</div>
							</div>

							<aside class="klp-frame klp-frame-auxiliary rich-pane" data-klp-component="KlpLayoutPane">
								<span class="klp-text klp-text-label klp-tone-muted">${isEn ? 'INSPECTOR' : '屬性檢查器'}</span>
								<div class="klp-card klp-surface-component rich-prop-row"><span>${isEn ? 'Selected' : '目前選取'}</span><strong>#${selectedRow + 1}</strong></div>
								<div class="klp-card klp-surface-component rich-prop-row"><span>${isEn ? 'Mode' : '色彩模式'}</span><strong>${currentMode}</strong></div>
								<div class="klp-card klp-surface-component rich-prop-row"><span>${isEn ? 'Accent' : '強調色'}</span><span style="display:inline-block;width:16px;height:16px;border-radius:4px;background:var(--klp-colors-accent);"></span></div>
								<div class="klp-card rep-callout" style="margin-top:auto;"><strong>${navItems[activeNav]}</strong> · ${rows[selectedRow].title}</div>
							</aside>
						</div>
					</div>
				`;
				for (const b of interactiveRepStage.querySelectorAll('[data-rn]')) b.addEventListener('click', () => { activeNav = Number(b.dataset.rn); drawRichApp(); });
				for (const b of interactiveRepStage.querySelectorAll('[data-rt]')) b.addEventListener('click', () => { activeTab = Number(b.dataset.rt); drawRichApp(); });
				for (const b of interactiveRepStage.querySelectorAll('[data-rr]')) b.addEventListener('click', () => { selectedRow = Number(b.dataset.rr); drawRichApp(); });
			}
			drawRichApp();
			renderLiveComponentsDock(theme);
		}

		// 畫面預覽下方：以本庫 .klp-* 元件為基底同步呈現按鈕、開關／核取、輸入／滑桿與回饋提示
		function renderLiveComponentsDock(theme) {
			const dock = document.getElementById('preview-live-components-dock');
			if (!dock) return;
			dock.classList.add('klp-theme');
			dock.dataset.klpTheme = theme.id;
			dock.dataset.klpVisualStyle = theme.family;
			dock.dataset.klpVisualMode = currentMode;
			dock.dataset.klpMode = currentMode;
			dock.dataset.styleFamily = theme.family;
			dock.dataset.elevDepth = theme.elevDepth || '';
			const isEn = currentLang === 'en';
			dock.innerHTML = `
				<div style="display:flex;justify-content:space-between;align-items:center;gap:10px;">
					<strong class="klp-text klp-text-body-strong">${isEn ? 'Live Synced Components' : '同步元件即時預覽'}</strong>
					<span class="klp-text klp-text-label klp-tone-muted">${theme.id} · ${currentMode}</span>
				</div>
				<div class="live-comp-dock-grid">
					<div class="klp-card klp-surface-stage live-comp-tile" data-klp-component="KlpCard">
						<div class="live-comp-tile-head"><span>KlpButton · KlpBadge</span><span>ACTIONS</span></div>
						<div style="display:flex;flex-wrap:wrap;gap:8px;align-items:center;">
							<button type="button" class="klp-button klp-button-primary klp-size-sm" data-klp-component="KlpButton">${isEn ? 'Primary' : '主要按鈕'}</button>
							<button type="button" class="klp-button klp-size-sm" data-klp-component="KlpButton">${isEn ? 'Secondary' : '次要'}</button>
							<span class="klp-badge klp-badge-info" data-klp-component="KlpBadge">${isEn ? 'Accent' : '強調標籤'}</span>
							<span class="klp-badge klp-badge-success" data-klp-component="KlpBadge">${isEn ? 'Synced' : '已同步'}</span>
						</div>
					</div>
					<div class="klp-card klp-surface-stage live-comp-tile" data-klp-component="KlpCard">
						<div class="live-comp-tile-head"><span>KlpSwitch · KlpCheckbox</span><span>TOGGLES</span></div>
						<div style="display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;">
							<label style="display:inline-flex;align-items:center;gap:7px;font-size:12.5px;cursor:pointer;" data-klp-component="KlpCheckbox">
								<input type="checkbox" checked style="width:15px;height:15px;accent-color:var(--klp-colors-accent);">
								<span>${isEn ? 'Auto Contrast' : '自動對比'}</span>
							</label>
							<button type="button" class="m-switch on" id="dock-live-switch" role="switch" aria-checked="true" data-klp-component="KlpSwitch" style="width:46px;height:25px;">
								<span class="m-switch-thumb" style="width:19px;height:19px;"></span>
							</button>
						</div>
					</div>
					<div class="klp-card klp-surface-stage live-comp-tile" data-klp-component="KlpCard">
						<div class="live-comp-tile-head"><span>KlpTextField · KlpSlider</span><span>INPUTS</span></div>
						<div style="display:grid;gap:8px;">
							<div class="klp-field" data-klp-component="KlpTextField">
								<input type="text" value="${isEn ? 'Kallopis Token' : 'Kallopis 風格字樣'}">
							</div>
							<div style="display:flex;align-items:center;gap:8px;" data-klp-component="KlpSlider">
								<input type="range" id="dock-live-slider" min="0" max="100" value="68" style="flex:1;accent-color:var(--klp-colors-accent);">
								<code id="dock-live-slider-val" class="klp-text-code klp-tone-muted" style="min-width:30px;text-align:right;">68%</code>
							</div>
						</div>
					</div>
					<div class="klp-card klp-surface-stage live-comp-tile" data-klp-component="KlpCard">
						<div class="live-comp-tile-head"><span>KlpAlert · KlpProgress</span><span>FEEDBACK</span></div>
						<div style="display:grid;gap:8px;">
							<div class="rep-callout" data-klp-component="KlpAlert" style="padding:7px 10px;font-size:11.5px;">${isEn ? 'Tokens update in real time with the right controls.' : '右側表單微調會即時反映於所有元件。'}</div>
							<div class="rich-progress" data-klp-component="KlpProgress"><i id="dock-live-progress" style="width:68%;"></i></div>
						</div>
					</div>
				</div>
			`;
			const sw = dock.querySelector('#dock-live-switch');
			if (sw) {
				sw.addEventListener('click', () => {
					const on = !sw.classList.contains('on');
					sw.classList.toggle('on', on);
					sw.setAttribute('aria-checked', String(on));
					const thumb = sw.querySelector('.m-switch-thumb');
					if (thumb) thumb.style.transform = on ? 'translateX(21px)' : 'translateX(0)';
				});
				const thumb = sw.querySelector('.m-switch-thumb');
				if (thumb) thumb.style.transform = 'translateX(21px)';
			}
			const sl = dock.querySelector('#dock-live-slider');
			if (sl) {
				sl.addEventListener('input', () => {
					dock.querySelector('#dock-live-slider-val').textContent = `${sl.value}%`;
					dock.querySelector('#dock-live-progress').style.width = `${sl.value}%`;
				});
			}
		}

		// 區塊 2：色票設計（線性計算演算法 + 設計師組合 + 相鄰色板 + 即時導出）
		const designerPresets = [
			{ id: 'default', label: { en: 'Theme Default', 'zh-Hant': '風格原色' }, hue: 0, warmth: 0, contrast: 100, sat: 100, dot: '#2563EB' },
			{ id: 'warm-paper', label: { en: 'Warm Paper', 'zh-Hant': '暖陽紙感' }, hue: 24, warmth: 55, contrast: 96, sat: 82, dot: '#B5852A' },
			{ id: 'nordic', label: { en: 'Nordic Slate', 'zh-Hant': '北歐冷岩' }, hue: -18, warmth: -65, contrast: 108, sat: 76, dot: '#475569' },
			{ id: 'sage', label: { en: 'Botanical Sage', 'zh-Hant': '森林鼠尾草' }, hue: -85, warmth: 20, contrast: 98, sat: 88, dot: '#2D8057' },
			{ id: 'indigo', label: { en: 'Indigo Pulse', 'zh-Hant': '靛藍脈衝' }, hue: 36, warmth: -35, contrast: 114, sat: 120, dot: '#5E6AD2' },
		];
		const paletteAlgo = { preset: 'default', hue: 0, warmth: 0, contrast: 100, sat: 100 };

		function hslToHex(h, s, l) {
			const hue = ((h % 360) + 360) % 360;
			const sat = Math.max(0, Math.min(100, s)) / 100;
			const lig = Math.max(0, Math.min(100, l)) / 100;
			const a = sat * Math.min(lig, 1 - lig);
			const f = n => {
				const k = (n + hue / 30) % 12;
				const c = lig - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
				return Math.round(255 * c).toString(16).padStart(2, '0');
			};
			return `#${f(0)}${f(8)}${f(4)}`.toUpperCase();
		}

		function computeLinearScales(theme) {
			const baseHueMap = {
				'elevation-v1': 221, 'micro-elevation-v1': 39, 'modern-minimal-v1': 24, 'kallopis-v1': 42,
				'dev-precision-v1': 234, 'quant-terminal-v1': 173, 'data-notebook-v1': 199, 'studio-canvas-v1': 205,
				'swiss-brutal-v1': 20, 'enterprise-clarity-v1': 216, 'clinical-calm-v1': 174, 'cyber-neon-v1': 292, 'spatial-glass-v1': 243,
			};
			const baseHue = (baseHueMap[theme.id] ?? 220) + paletteAlgo.hue;
			const neutralHue = paletteAlgo.warmth >= 0 ? 38 : 216;
			const neutralSat = Math.min(26, Math.abs(paletteAlgo.warmth) * 0.24 + 6);
			const cFactor = paletteAlgo.contrast / 100;
			const sFactor = paletteAlgo.sat / 100;
			const clampL = v => Math.max(4, Math.min(98, 50 + (v - 50) * cFactor));

			const inkSteps = [96, 88, 76, 60, 44, 28, 16, 8];
			const warmSteps = [96, 91, 84, 72, 54, 36, 22, 12];
			const accentSteps = [94, 82, 68, 54, 44, 34, 22];

			const primitives = {
				ink: inkSteps.map((l, i) => ({ name: `ink${(i + 1) * 100}`, hex: hslToHex(215, 5, clampL(l)) })),
				warmNeutral: warmSteps.map((l, i) => ({ name: `warmNeutral${(i + 1) * 100}`, hex: hslToHex(neutralHue, neutralSat, clampL(l)) })),
				accent: accentSteps.map((l, i) => ({ name: `accent${(i + 1) * 100}`, hex: hslToHex(baseHue, 68 * sFactor, clampL(l)) })),
				status: [
					{ name: 'success', hex: hslToHex(152, 56 * sFactor, currentMode === 'dark' ? 54 : 38) },
					{ name: 'warning', hex: hslToHex(38, 86 * sFactor, currentMode === 'dark' ? 58 : 48) },
					{ name: 'danger', hex: hslToHex(356, 76 * sFactor, currentMode === 'dark' ? 62 : 48) },
					{ name: 'info', hex: hslToHex(206, 78 * sFactor, currentMode === 'dark' ? 60 : 46) },
				],
			};

			const isDark = currentMode === 'dark';
			const semantics = {
				app: isDark ? primitives.warmNeutral[7].hex : primitives.warmNeutral[1].hex,
				surface: isDark ? primitives.warmNeutral[6].hex : primitives.warmNeutral[0].hex,
				surfaceInset: isDark ? primitives.ink[7].hex : primitives.warmNeutral[2].hex,
				surfaceMuted: isDark ? primitives.warmNeutral[5].hex : primitives.warmNeutral[2].hex,
				stageSurface: isDark ? primitives.warmNeutral[6].hex : '#FFFFFF',
				component: isDark ? primitives.warmNeutral[5].hex : '#FFFFFF',
				text: isDark ? primitives.ink[0].hex : primitives.ink[7].hex,
				textMuted: isDark ? primitives.ink[2].hex : primitives.ink[4].hex,
				border: isDark ? primitives.warmNeutral[5].hex : primitives.warmNeutral[3].hex,
				accent: isDark ? primitives.accent[2].hex : primitives.accent[3].hex,
				accentSoft: isDark ? primitives.accent[6].hex : primitives.accent[0].hex,
				success: primitives.status[0].hex,
				danger: primitives.status[2].hex,
			};
			return { primitives, semantics };
		}

		function applyCustomTokensToPreview(semantics) {
			const targets = [interactiveRepStage, document.getElementById('preview-live-components-dock'), refDemoCanvas, ...categoryVisuals];
			const hasOverride = paletteAlgo.hue !== 0 || paletteAlgo.warmth !== 0 || paletteAlgo.contrast !== 100 || paletteAlgo.sat !== 100;
			for (const el of targets) {
				if (!el) continue;
				for (const [k, v] of Object.entries(semantics)) {
					if (hasOverride) el.style.setProperty(`--klp-colors-${k}`, v);
					else el.style.removeProperty(`--klp-colors-${k}`);
				}
			}
		}

		function renderSwatchStrip(label, items, readonly = false) {
			if (readonly) {
				return `<div class="palette-group"><div class="palette-group-head"><span>${label}</span><span>${items.length}</span></div><div class="swatch-connected-strip" aria-readonly="true">${items.map(item => `<span class="swatch-cell-readonly" style="background:${item.hex}" title="${item.name}: ${item.hex}"><span class="swatch-cell-tip">${item.hex}</span></span>`).join('')}</div></div>`;
			}
			return `<div class="palette-group"><div class="palette-group-head"><span>${label}</span><span>${items.length}</span></div><div class="swatch-connected-strip">${items.map(item => `<button type="button" class="swatch-cell" style="background:${item.hex}" data-copy-hex="${item.hex}" data-token-name="${item.name}" title="${item.name}: ${item.hex}"><span class="swatch-cell-tip">${item.hex}</span></button>`).join('')}</div></div>`;
		}

		// 元件預覽頁右側：僅呈現唯讀 Primitive 基礎色階（不負責 Semantic），透過表單控制合法修改
		function renderPaletteStudio(theme) {
			const { primitives, semantics } = computeLinearScales(theme);
			applyCustomTokensToPreview(semantics);

			const primWall = document.getElementById('primitive-palette-wall');
			if (primWall) {
				primWall.innerHTML = [
					renderSwatchStrip('ink', primitives.ink, true),
					renderSwatchStrip('warmNeutral', primitives.warmNeutral, true),
					renderSwatchStrip('accentScale', primitives.accent, true),
					renderSwatchStrip('status', primitives.status, true),
				].join('');
			}

			const presetGrid = document.getElementById('designer-preset-grid');
			if (presetGrid) {
				presetGrid.innerHTML = designerPresets.map(p => `<button type="button" class="preset-chip" data-preset="${p.id}" aria-pressed="${paletteAlgo.preset === p.id}"><span class="preset-dot" style="background:${p.dot}"></span>${p.label[currentLang] || p.label.en}</button>`).join('');
				for (const btn of presetGrid.querySelectorAll('[data-preset]')) {
					btn.addEventListener('click', () => {
						const p = designerPresets.find(x => x.id === btn.dataset.preset);
						if (!p) return;
						Object.assign(paletteAlgo, { preset: p.id, hue: p.hue, warmth: p.warmth, contrast: p.contrast, sat: p.sat });
						syncAlgoSliderInputs();
						renderPaletteStudio(theme);
					});
				}
			}
		}

		// =========================================================
		// 獨立色票設計頁（色環 + 和聲演算法 + 沿用現有設計庫 + Primitive 導出）
		// =========================================================
		const colorLibraries = [
			{ id: 'kallopis', label: { en: 'Kallopis Parchment', 'zh-Hant': 'Kallopis 暖紙' }, hue: 42, sat: 64, warmth: 48, contrast: 98, harmony: 'analogous', dot: '#B5852A' },
			{ id: 'tailwind', label: { en: 'Tailwind Sky', 'zh-Hant': 'Tailwind 晴藍' }, hue: 204, sat: 84, warmth: -20, contrast: 104, harmony: 'analogous', dot: '#0284C7' },
			{ id: 'radix', label: { en: 'Radix Indigo', 'zh-Hant': 'Radix 靛藍' }, hue: 231, sat: 76, warmth: -36, contrast: 108, harmony: 'complementary', dot: '#3E63DD' },
			{ id: 'apple', label: { en: 'Apple HIG Blue', 'zh-Hant': 'Apple HIG 藍' }, hue: 211, sat: 94, warmth: -10, contrast: 102, harmony: 'mono', dot: '#007AFF' },
			{ id: 'material', label: { en: 'Material Emerald', 'zh-Hant': 'Material 翠綠' }, hue: 158, sat: 68, warmth: 12, contrast: 100, harmony: 'triadic', dot: '#10B981' },
			{ id: 'linear', label: { en: 'Linear Violet', 'zh-Hant': 'Linear 紫羅蘭' }, hue: 248, sat: 78, warmth: -48, contrast: 112, harmony: 'analogous', dot: '#5E6AD2' },
			{ id: 'bloomberg', label: { en: 'Quant Amber', 'zh-Hant': '金融琥珀' }, hue: 34, sat: 90, warmth: -40, contrast: 118, harmony: 'complementary', dot: '#F59E0B' },
			{ id: 'terracotta', label: { en: 'Warm Terracotta', 'zh-Hant': '暖陶紅土' }, hue: 16, sat: 74, warmth: 58, contrast: 96, harmony: 'triadic', dot: '#D95D39' },
		];
		const colorStudio = { engine: 'oklch', library: 'radix', hue: 250, sat: 76, oklchL: 0.60, oklchC: 0.16, warmth: -36, contrast: 108, harmony: 'analogous' };

		// OKLCH → sRGB HEX 精確轉換（Björn Ottosson OKLab 矩陣 + 邊界夾緊，確保同亮轉換準確度）
		function oklchToHex(L, C, H) {
			const hr = (((H % 360) + 360) % 360) * (Math.PI / 180);
			const a = C * Math.cos(hr);
			const b = C * Math.sin(hr);
			const l_ = L + 0.3963377774 * a + 0.2158037573 * b;
			const m_ = L - 0.1055613458 * a - 0.0638541728 * b;
			const s_ = L - 0.0894841775 * a - 1.2914855480 * b;
			const l = l_ * l_ * l_;
			const m = m_ * m_ * m_;
			const s = s_ * s_ * s_;
			const toSrgb = x => {
				const cl = Math.max(0, Math.min(1, x));
				const g = cl <= 0.0031308 ? 12.92 * cl : 1.055 * Math.pow(cl, 1 / 2.4) - 0.055;
				return Math.round(Math.max(0, Math.min(1, g)) * 255).toString(16).padStart(2, '0');
			};
			const r = +4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s;
			const g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s;
			const bl = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s;
			return `#${toSrgb(r)}${toSrgb(g)}${toSrgb(bl)}`.toUpperCase();
		}

		function getHarmonyOffsets(harmony) {
			if (harmony === 'mono') return [0, 0];
			if (harmony === 'analogous') return [30, -30];
			if (harmony === 'complementary') return [180, 150];
			return [120, 240];
		}

		function computeColorStudioPrimitives() {
			const cFactor = colorStudio.contrast / 100;
			const [hOff1, hOff2] = getHarmonyOffsets(colorStudio.harmony);
			const secHue = (colorStudio.hue + hOff1 + 360) % 360;
			const tertHue = (colorStudio.hue + hOff2 + 360) % 360;

			if (colorStudio.engine === 'oklch') {
				const lSteps = [0.97, 0.91, 0.83, 0.74, colorStudio.oklchL, 0.50, 0.40, 0.30, 0.20];
				const clampOklchL = v => Math.max(0.12, Math.min(0.98, 0.55 + (v - 0.55) * cFactor));
				const neutralHue = colorStudio.warmth >= 0 ? 75 : 255;
				const neutralC = Math.min(0.032, Math.abs(colorStudio.warmth) * 0.00028 + 0.004);
				const makeOklchScale = (prefix, hue, chroma) => lSteps.map((lv, i) => {
					const lVal = clampOklchL(lv);
					const cTaper = Math.sin(Math.min(1, Math.max(0.08, lVal)) * Math.PI);
					return { name: `${prefix}${(i + 1) * 100}`, hex: oklchToHex(lVal, chroma * (0.45 + 0.55 * cTaper), hue) };
				});
				return {
					primary: makeOklchScale('primary', colorStudio.hue, colorStudio.oklchC),
					secondary: makeOklchScale('secondary', secHue, colorStudio.oklchC * 0.92),
					tertiary: makeOklchScale('tertiary', tertHue, colorStudio.oklchC * 0.85),
					neutral: makeOklchScale('neutral', neutralHue, neutralC),
					ink: [0.97, 0.88, 0.76, 0.62, 0.48, 0.34, 0.22, 0.13].map((lv, i) => ({ name: `ink${(i + 1) * 100}`, hex: oklchToHex(clampOklchL(lv), 0.005, 250) })),
				};
			}

			const clampL = v => Math.max(5, Math.min(97, 50 + (v - 50) * cFactor));
			const steps = [96, 88, 78, 66, 54, 44, 34, 24, 14];
			const neutralHue = colorStudio.warmth >= 0 ? 38 : 216;
			const neutralSat = Math.min(24, Math.abs(colorStudio.warmth) * 0.22 + 5);
			return {
				primary: steps.map((l, i) => ({ name: `primary${(i + 1) * 100}`, hex: hslToHex(colorStudio.hue, colorStudio.sat, clampL(l)) })),
				secondary: steps.map((l, i) => ({ name: `secondary${(i + 1) * 100}`, hex: hslToHex(secHue, Math.max(20, colorStudio.sat * 0.85), clampL(l)) })),
				tertiary: steps.map((l, i) => ({ name: `tertiary${(i + 1) * 100}`, hex: hslToHex(tertHue, Math.max(18, colorStudio.sat * 0.78), clampL(l)) })),
				neutral: steps.map((l, i) => ({ name: `neutral${(i + 1) * 100}`, hex: hslToHex(neutralHue, neutralSat, clampL(l)) })),
				ink: [96, 86, 72, 56, 40, 26, 15, 7].map((l, i) => ({ name: `ink${(i + 1) * 100}`, hex: hslToHex(215, 6, clampL(l)) })),
			};
		}

		function positionWheelMarker(el, hueDeg, satPct) {
			if (!el) return;
			const radius = 112;
			const r = (Math.max(12, Math.min(100, satPct)) / 100) * (radius - 14);
			const rad = (hueDeg * Math.PI) / 180;
			const x = radius + Math.cos(rad) * r;
			const y = radius + Math.sin(rad) * r;
			el.style.left = `${x.toFixed(1)}px`;
			el.style.top = `${y.toFixed(1)}px`;
			el.style.background = hslToHex(hueDeg, satPct, 52);
		}

		function renderColorDesignPage() {
			const libGrid = document.getElementById('color-library-presets');
			if (libGrid) {
				libGrid.innerHTML = colorLibraries.map(lib => `<button type="button" class="preset-chip" data-color-lib="${lib.id}" aria-pressed="${colorStudio.library === lib.id}"><span class="preset-dot" style="background:${lib.dot}"></span>${lib.label[currentLang] || lib.label.en}</button>`).join('');
				for (const btn of libGrid.querySelectorAll('[data-color-lib]')) {
					btn.addEventListener('click', () => {
						const lib = colorLibraries.find(x => x.id === btn.dataset.colorLib);
						if (!lib) return;
						Object.assign(colorStudio, { library: lib.id, hue: lib.hue, sat: lib.sat, warmth: lib.warmth, contrast: lib.contrast, harmony: lib.harmony });
						renderColorDesignPage();
					});
				}
			}

			const isOklch = colorStudio.engine === 'oklch';
			document.getElementById('oklch-engine-panel').hidden = !isOklch;
			document.getElementById('wheel-engine-panel').hidden = isOklch;
			for (const b of document.querySelectorAll('#color-engine-tabs [data-color-engine]')) {
				b.setAttribute('aria-selected', String(b.dataset.colorEngine === colorStudio.engine));
			}

			// 更新 OKLCH 等亮色相帶與跨色相同亮對照卡
			const oklchStrip = document.getElementById('oklch-hue-strip');
			if (oklchStrip) {
				const stops = [];
				for (let deg = 0; deg <= 360; deg += 30) stops.push(`${oklchToHex(colorStudio.oklchL, colorStudio.oklchC, deg)} ${(deg / 360 * 100).toFixed(1)}%`);
				oklchStrip.style.background = `linear-gradient(90deg, ${stops.join(', ')})`;
				oklchStrip.setAttribute('aria-valuenow', String(colorStudio.hue));
				const marker = document.getElementById('oklch-hue-marker');
				if (marker) {
					marker.style.left = `${(colorStudio.hue / 360) * 100}%`;
					marker.style.background = oklchToHex(colorStudio.oklchL, colorStudio.oklchC, colorStudio.hue);
				}
				const readoutEl = document.getElementById('oklch-readout');
				if (readoutEl) readoutEl.textContent = `oklch(${colorStudio.oklchL.toFixed(2)} ${colorStudio.oklchC.toFixed(2)} ${colorStudio.hue})`;
				document.getElementById('cd-slider-oklch-l').value = Math.round(colorStudio.oklchL * 100);
				document.getElementById('cd-slider-oklch-c').value = Math.round(colorStudio.oklchC * 100);
				document.getElementById('cd-out-oklch-l').textContent = colorStudio.oklchL.toFixed(2);
				document.getElementById('cd-out-oklch-c').textContent = colorStudio.oklchC.toFixed(2);

				const eqRow = document.getElementById('oklch-equal-l-row');
				if (eqRow) {
					const [off1, off2] = getHarmonyOffsets(colorStudio.harmony);
					const eqItems = [
						{ tag: 'PRI', h: colorStudio.hue },
						{ tag: 'SEC', h: (colorStudio.hue + off1 + 360) % 360 },
						{ tag: 'TER', h: (colorStudio.hue + off2 + 360) % 360 },
						{ tag: 'OK', h: 152 },
						{ tag: 'WARN', h: 82 },
						{ tag: 'ERR', h: 26 },
					];
					const fg = colorStudio.oklchL > 0.68 ? '#18181B' : '#FFFFFF';
					eqRow.innerHTML = eqItems.map(it => {
						const hex = oklchToHex(colorStudio.oklchL, colorStudio.oklchC, it.h);
						return `<div class="oklch-eq-chip" style="background:${hex};color:${fg};" title="oklch(${colorStudio.oklchL.toFixed(2)} ${colorStudio.oklchC.toFixed(2)} ${it.h}) = ${hex}"><span>${it.tag}</span><span>L=${colorStudio.oklchL.toFixed(2)}</span></div>`;
					}).join('');
				}
			}

			const wheel = document.getElementById('color-wheel');
			if (wheel) wheel.setAttribute('aria-valuenow', String(colorStudio.hue));
			const [hOff1, hOff2] = getHarmonyOffsets(colorStudio.harmony);
			positionWheelMarker(document.getElementById('wheel-handle'), colorStudio.hue, colorStudio.sat);
			positionWheelMarker(document.getElementById('wheel-harmony-1'), (colorStudio.hue + hOff1 + 360) % 360, colorStudio.sat * 0.85);
			positionWheelMarker(document.getElementById('wheel-harmony-2'), (colorStudio.hue + hOff2 + 360) % 360, colorStudio.sat * 0.78);
			const primaryHex = hslToHex(colorStudio.hue, colorStudio.sat, 52);
			const chip = document.getElementById('wheel-primary-chip');
			if (chip) chip.style.background = primaryHex;
			const readout = document.getElementById('wheel-primary-readout');
			if (readout) readout.textContent = `${primaryHex} · HSL(${colorStudio.hue}°, ${colorStudio.sat}%, 52%)`;

			document.getElementById('cd-slider-hue').value = colorStudio.hue;
			document.getElementById('cd-slider-sat').value = colorStudio.sat;
			document.getElementById('cd-slider-warmth').value = colorStudio.warmth;
			document.getElementById('cd-slider-contrast').value = colorStudio.contrast;
			document.getElementById('cd-out-hue').textContent = `${colorStudio.hue}°`;
			document.getElementById('cd-out-sat').textContent = `${colorStudio.sat}%`;
			document.getElementById('cd-out-warmth').textContent = `${colorStudio.warmth}`;
			document.getElementById('cd-out-contrast').textContent = `${colorStudio.contrast}%`;
			for (const b of document.querySelectorAll('#harmony-algo-tabs [data-harmony]')) {
				b.setAttribute('aria-selected', String(b.dataset.harmony === colorStudio.harmony));
			}

			const prims = computeColorStudioPrimitives();
			const stripsEl = document.getElementById('color-studio-strips');
			if (stripsEl) {
				stripsEl.innerHTML = [
					renderSwatchStrip(`primaryScale (${colorStudio.hue}°)`, prims.primary, false),
					renderSwatchStrip(`secondaryScale (${colorStudio.harmony})`, prims.secondary, false),
					renderSwatchStrip('tertiaryScale', prims.tertiary, false),
					renderSwatchStrip('neutralScale', prims.neutral, false),
					renderSwatchStrip('inkScale', prims.ink, false),
				].join('');
				const statusEl = document.getElementById('palette-copy-status');
				for (const cell of stripsEl.querySelectorAll('.swatch-cell[data-copy-hex]')) {
					cell.addEventListener('click', async () => {
						try {
							await navigator.clipboard.writeText(cell.dataset.copyHex);
							if (statusEl) statusEl.textContent = `COPIED ${cell.dataset.tokenName} (${cell.dataset.copyHex})`;
						} catch {}
					});
				}
			}

			updateTokenExportCode({ id: `primitive-${colorStudio.library}` }, prims, {
				accent: prims.primary[4].hex,
				surface: prims.neutral[0].hex,
			});
		}

		// OKLCH 引擎切換與等亮色相帶互動
		for (const b of document.querySelectorAll('#color-engine-tabs [data-color-engine]')) {
			b.addEventListener('click', () => { colorStudio.engine = b.dataset.colorEngine; renderColorDesignPage(); });
		}
		const oklchStripEl = document.getElementById('oklch-hue-strip');
		if (oklchStripEl) {
			let draggingOklch = false;
			function pickOklchHue(e) {
				const rect = oklchStripEl.getBoundingClientRect();
				const ratio = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
				colorStudio.hue = Math.round(ratio * 360);
				colorStudio.library = 'custom';
				renderColorDesignPage();
			}
			oklchStripEl.addEventListener('pointerdown', e => { draggingOklch = true; oklchStripEl.setPointerCapture(e.pointerId); pickOklchHue(e); });
			oklchStripEl.addEventListener('pointermove', e => { if (draggingOklch) pickOklchHue(e); });
			oklchStripEl.addEventListener('pointerup', () => { draggingOklch = false; });
		}
		document.getElementById('cd-slider-oklch-l').addEventListener('input', e => {
			colorStudio.oklchL = Number(e.target.value) / 100;
			colorStudio.library = 'custom';
			renderColorDesignPage();
		});
		document.getElementById('cd-slider-oklch-c').addEventListener('input', e => {
			colorStudio.oklchC = Number(e.target.value) / 100;
			colorStudio.library = 'custom';
			renderColorDesignPage();
		});

		// 色環滑鼠／觸控互動
		const colorWheelEl = document.getElementById('color-wheel');
		if (colorWheelEl) {
			let draggingWheel = false;
			function pickWheelPoint(e) {
				const rect = colorWheelEl.getBoundingClientRect();
				const cx = rect.left + rect.width / 2;
				const cy = rect.top + rect.height / 2;
				const dx = e.clientX - cx;
				const dy = e.clientY - cy;
				const angle = (Math.atan2(dy, dx) * 180) / Math.PI;
				colorStudio.hue = Math.round((angle + 360) % 360);
				const dist = Math.min(rect.width / 2, Math.hypot(dx, dy));
				colorStudio.sat = Math.max(15, Math.min(100, Math.round((dist / (rect.width / 2)) * 100)));
				colorStudio.library = 'custom';
				renderColorDesignPage();
			}
			colorWheelEl.addEventListener('pointerdown', e => { draggingWheel = true; colorWheelEl.setPointerCapture(e.pointerId); pickWheelPoint(e); });
			colorWheelEl.addEventListener('pointermove', e => { if (draggingWheel) pickWheelPoint(e); });
			colorWheelEl.addEventListener('pointerup', () => { draggingWheel = false; });
			colorWheelEl.addEventListener('keydown', e => {
				if (e.key === 'ArrowRight' || e.key === 'ArrowUp') { colorStudio.hue = (colorStudio.hue + 10) % 360; colorStudio.library = 'custom'; renderColorDesignPage(); }
				if (e.key === 'ArrowLeft' || e.key === 'ArrowDown') { colorStudio.hue = (colorStudio.hue + 350) % 360; colorStudio.library = 'custom'; renderColorDesignPage(); }
			});
		}
		for (const b of document.querySelectorAll('#harmony-algo-tabs [data-harmony]')) {
			b.addEventListener('click', () => { colorStudio.harmony = b.dataset.harmony; renderColorDesignPage(); });
		}
		for (const [id, key] of [['cd-slider-hue', 'hue'], ['cd-slider-sat', 'sat'], ['cd-slider-warmth', 'warmth'], ['cd-slider-contrast', 'contrast']]) {
			document.getElementById(id).addEventListener('input', e => {
				colorStudio.library = 'custom';
				colorStudio[key] = Number(e.target.value);
				renderColorDesignPage();
			});
		}
		document.getElementById('apply-color-to-preview-btn').addEventListener('click', () => {
			paletteAlgo.preset = 'custom';
			paletteAlgo.hue = Math.max(-180, Math.min(180, colorStudio.hue - 221));
			paletteAlgo.warmth = colorStudio.warmth;
			paletteAlgo.contrast = colorStudio.contrast;
			paletteAlgo.sat = Math.max(20, Math.min(140, Math.round((colorStudio.sat / 72) * 100)));
			syncAlgoSliderInputs();
			navigateTo('style-preview', selectedThemeId);
		});

		// =========================================================
		// 獨立布局設計頁（線上容器拖放編輯 + 即時預覽 + 匯出 Schema）
		// =========================================================
		const layoutBlockDefs = [
			{ type: 'KlpAppHeader', defaultSlot: 'header', label: { en: 'Top Bar', 'zh-Hant': '頂部工具列' }, desc: 'App shell header' },
			{ type: 'KlpFileExplorer', defaultSlot: 'sidebar', label: { en: 'Sidebar Nav', 'zh-Hant': '側欄導覽' }, desc: 'Explorer / tree nav' },
			{ type: 'KlpContentHost', defaultSlot: 'stage', label: { en: 'Main Stage', 'zh-Hant': '主內容舞台' }, desc: 'Primary workspace view' },
			{ type: 'KlpCardGrid', defaultSlot: 'stage', label: { en: 'Card Grid', 'zh-Hant': '卡片網格' }, desc: 'Responsive 3-col cards' },
			{ type: 'KlpLayoutPane', defaultSlot: 'inspector', label: { en: 'Inspector Pane', 'zh-Hant': '右側屬性欄' }, desc: 'Live details & properties' },
			{ type: 'KlpLayoutRow', defaultSlot: 'stage', label: { en: 'Split Row', 'zh-Hant': '雙欄分割列' }, desc: 'Horizontal 2-pane split' },
			{ type: 'KlpStatusBar', defaultSlot: 'footer', label: { en: 'Status Bar', 'zh-Hant': '底部狀態列' }, desc: 'Compact workspace footer' },
		];
		let layoutNextId = 10;
		let layoutState = {
			header: [{ id: 'blk-1', type: 'KlpAppHeader' }],
			sidebar: [{ id: 'blk-2', type: 'KlpFileExplorer' }],
			stage: [{ id: 'blk-3', type: 'KlpContentHost' }, { id: 'blk-4', type: 'KlpCardGrid' }],
			inspector: [{ id: 'blk-5', type: 'KlpLayoutPane' }],
			footer: [{ id: 'blk-6', type: 'KlpStatusBar' }],
		};
		let selectedLayoutBlockId = 'blk-3';
		let layoutSchemaFmt = 'json';
		let layoutPreviewMode = 'edit';

		function applyLayoutPreset(name) {
			if (name === 'workbench') {
				layoutState = {
					header: [{ id: 'blk-1', type: 'KlpAppHeader' }],
					sidebar: [{ id: 'blk-2', type: 'KlpFileExplorer' }],
					stage: [{ id: 'blk-3', type: 'KlpContentHost' }],
					inspector: [],
					footer: [],
				};
				selectedLayoutBlockId = 'blk-3';
			} else if (name === 'ide') {
				layoutState = {
					header: [{ id: 'blk-1', type: 'KlpAppHeader' }],
					sidebar: [{ id: 'blk-2', type: 'KlpFileExplorer' }],
					stage: [{ id: 'blk-3', type: 'KlpContentHost' }, { id: 'blk-4', type: 'KlpLayoutRow' }],
					inspector: [{ id: 'blk-5', type: 'KlpLayoutPane' }],
					footer: [{ id: 'blk-6', type: 'KlpStatusBar' }],
				};
				selectedLayoutBlockId = 'blk-3';
			} else if (name === 'dashboard') {
				layoutState = {
					header: [{ id: 'blk-1', type: 'KlpAppHeader' }],
					sidebar: [{ id: 'blk-2', type: 'KlpFileExplorer' }],
					stage: [{ id: 'blk-3', type: 'KlpCardGrid' }, { id: 'blk-4', type: 'KlpLayoutRow' }],
					inspector: [{ id: 'blk-5', type: 'KlpLayoutPane' }],
					footer: [],
				};
				selectedLayoutBlockId = 'blk-3';
			} else {
				layoutState = { header: [], sidebar: [], stage: [], inspector: [], footer: [] };
				selectedLayoutBlockId = null;
			}
			renderLayoutDesignPage();
		}

		function addLayoutBlock(type, slot) {
			const def = layoutBlockDefs.find(d => d.type === type);
			if (!def) return;
			const targetSlot = slot || def.defaultSlot;
			const id = `blk-${++layoutNextId}`;
			layoutState[targetSlot].push({ id, type });
			selectedLayoutBlockId = id;
			renderLayoutDesignPage();
		}

		function buildLayoutSchemaText() {
			const schemaObj = {
				schemaVersion: '1.0.0',
				system: 'kallopis',
				theme: selectedThemeId,
				slots: Object.fromEntries(Object.entries(layoutState).map(([slot, list]) => [slot, list.map(item => ({ id: item.id, component: item.type }))])),
			};
			if (layoutSchemaFmt === 'json') return JSON.stringify(schemaObj, null, '\t');
			const renderSlot = (slot) => layoutState[slot].map(b => `\t\t\t<${b.type} key="${b.id}" />`).join('\n');
			return `import { KlpAppLayout, KlpWorkspace } from '@kallopis/react';\n\nexport function GeneratedLayout() {\n\treturn (\n\t\t<KlpAppLayout data-klp-theme="${selectedThemeId}">\n\t\t\t{/* Header */}\n${renderSlot('header') || '\t\t\t{/* empty */}\n'}\n\t\t\t<KlpWorkspace>\n\t\t\t\t{/* Sidebar */}\n${renderSlot('sidebar')}\n\t\t\t\t{/* Main Stage */}\n${renderSlot('stage')}\n\t\t\t\t{/* Inspector */}\n${renderSlot('inspector')}\n\t\t\t</KlpWorkspace>\n\t\t\t{/* Footer */}\n${renderSlot('footer')}\n\t\t</KlpAppLayout>\n\t);\n}`;
		}

		function renderLayoutDesignPage() {
			const paletteList = document.getElementById('layout-palette-list');
			if (paletteList) {
				paletteList.innerHTML = layoutBlockDefs.map(def => `
					<div class="layout-block-item" draggable="true" data-drag-type="${def.type}">
						<span>${def.label[currentLang] || def.label.en}</span>
						<button type="button" class="layout-mini-icon-btn" data-quick-add="${def.type}" title="Add to default slot">+</button>
					</div>
				`).join('');
				for (const item of paletteList.querySelectorAll('[data-drag-type]')) {
					item.addEventListener('dragstart', e => {
						e.dataTransfer.setData('text/plain', item.dataset.dragType);
						e.dataTransfer.effectAllowed = 'copy';
					});
				}
				for (const btn of paletteList.querySelectorAll('[data-quick-add]')) {
					btn.addEventListener('click', e => { e.stopPropagation(); addLayoutBlock(btn.dataset.quickAdd); });
				}
			}

			const shell = document.getElementById('layout-canvas-shell');
			if (shell) shell.classList.toggle('live-preview-mode', layoutPreviewMode === 'preview');
			const canvas = document.getElementById('layout-drop-canvas');
			if (canvas) {
				canvas.dataset.klpTheme = selectedThemeId;
				canvas.dataset.klpMode = currentMode;
			}

			for (const zone of document.querySelectorAll('.layout-dropzone[data-slot]')) {
				const slot = zone.dataset.slot;
				const itemsBox = zone.querySelector('.layout-zone-items');
				const list = layoutState[slot] || [];
				itemsBox.innerHTML = list.map((blk, idx) => {
					const def = layoutBlockDefs.find(d => d.type === blk.type) || { label: { en: blk.type, 'zh-Hant': blk.type }, desc: '' };
					return `
						<div class="layout-placed-card ${blk.id === selectedLayoutBlockId ? 'selected' : ''}" data-select-blk="${blk.id}" data-slot="${slot}">
							<div class="layout-placed-head">
								<span>${def.label[currentLang] || def.label.en}</span>
								<div class="layout-placed-actions">
									<button type="button" class="layout-mini-icon-btn" data-move-blk="${blk.id}" data-dir="-1" ${idx === 0 ? 'disabled' : ''}>↑</button>
									<button type="button" class="layout-mini-icon-btn" data-move-blk="${blk.id}" data-dir="1" ${idx === list.length - 1 ? 'disabled' : ''}>↓</button>
									<button type="button" class="layout-mini-icon-btn" data-del-blk="${blk.id}">×</button>
								</div>
							</div>
							<span style="font:11px Consolas,monospace;color:var(--klp-colors-textMuted);">${blk.type}</span>
						</div>
					`;
				}).join('');

				for (const card of itemsBox.querySelectorAll('[data-select-blk]')) {
					card.addEventListener('click', () => { selectedLayoutBlockId = card.dataset.selectBlk; renderLayoutDesignPage(); });
				}
				for (const mv of itemsBox.querySelectorAll('[data-move-blk]')) {
					mv.addEventListener('click', e => {
						e.stopPropagation();
						const dir = Number(mv.dataset.dir);
						const idx = list.findIndex(x => x.id === mv.dataset.moveBlk);
						const target = idx + dir;
						if (idx > -1 && target >= 0 && target < list.length) {
							[list[idx], list[target]] = [list[target], list[idx]];
							renderLayoutDesignPage();
						}
					});
				}
				for (const del of itemsBox.querySelectorAll('[data-del-blk]')) {
					del.addEventListener('click', e => {
						e.stopPropagation();
						layoutState[slot] = list.filter(x => x.id !== del.dataset.delBlk);
						if (selectedLayoutBlockId === del.dataset.delBlk) selectedLayoutBlockId = null;
						renderLayoutDesignPage();
					});
				}
			}

			const propsEl = document.getElementById('layout-selected-props');
			const allBlocks = Object.entries(layoutState).flatMap(([slot, list]) => list.map(b => ({ ...b, slot })));
			const sel = allBlocks.find(b => b.id === selectedLayoutBlockId);
			if (propsEl) {
				propsEl.textContent = sel
					? `${currentLang === 'en' ? 'Selected' : '已選取'}: ${sel.type} (${sel.slot})`
					: (currentLang === 'en' ? `Total containers: ${allBlocks.length}` : `畫布容器總數：${allBlocks.length}`);
			}
			const schemaViewer = document.getElementById('layout-schema-viewer');
			if (schemaViewer) schemaViewer.textContent = buildLayoutSchemaText();
		}

		for (const zone of document.querySelectorAll('.layout-dropzone[data-slot]')) {
			zone.addEventListener('dragover', e => { e.preventDefault(); zone.classList.add('drag-over'); });
			zone.addEventListener('dragleave', () => zone.classList.remove('drag-over'));
			zone.addEventListener('drop', e => {
				e.preventDefault();
				zone.classList.remove('drag-over');
				const type = e.dataTransfer.getData('text/plain');
				if (type) addLayoutBlock(type, zone.dataset.slot);
			});
		}
		for (const btn of document.querySelectorAll('[data-layout-preset]')) {
			btn.addEventListener('click', () => applyLayoutPreset(btn.dataset.layoutPreset));
		}
		document.getElementById('layout-clear-btn').addEventListener('click', () => applyLayoutPreset('clear'));
		for (const btn of document.querySelectorAll('#layout-mode-tabs [data-layout-mode]')) {
			btn.addEventListener('click', () => {
				layoutPreviewMode = btn.dataset.layoutMode;
				for (const b of document.querySelectorAll('#layout-mode-tabs [data-layout-mode]')) b.setAttribute('aria-selected', String(b.dataset.layoutMode === layoutPreviewMode));
				renderLayoutDesignPage();
			});
		}
		for (const btn of document.querySelectorAll('#schema-fmt-tabs [data-schema-fmt]')) {
			btn.addEventListener('click', () => {
				layoutSchemaFmt = btn.dataset.schemaFmt;
				for (const b of document.querySelectorAll('#schema-fmt-tabs [data-schema-fmt]')) b.setAttribute('aria-selected', String(b.dataset.schemaFmt === layoutSchemaFmt));
				renderLayoutDesignPage();
			});
		}
		document.getElementById('copy-schema-btn').addEventListener('click', async () => {
			const btn = document.getElementById('copy-schema-btn');
			const dict = i18n[currentLang] || i18n.en;
			try {
				await navigator.clipboard.writeText(document.getElementById('layout-schema-viewer').textContent);
				btn.textContent = '✓ Copied';
				setTimeout(() => { btn.textContent = dict.copySchemaBtn; }, 1400);
			} catch {}
		});
		document.getElementById('export-schema-btn').addEventListener('click', () => {
			const ext = layoutSchemaFmt === 'react' ? 'tsx' : 'json';
			const blob = new Blob([document.getElementById('layout-schema-viewer').textContent], { type: 'text/plain;charset=utf-8' });
			const url = URL.createObjectURL(blob);
			const a = document.createElement('a');
			a.href = url;
			a.download = `kallopis-layout-schema.${ext}`;
			a.click();
			URL.revokeObjectURL(url);
		});

		function syncAlgoSliderInputs() {
			document.getElementById('slider-hue').value = paletteAlgo.hue;
			document.getElementById('slider-warmth').value = paletteAlgo.warmth;
			document.getElementById('slider-contrast').value = paletteAlgo.contrast;
			document.getElementById('slider-sat').value = paletteAlgo.sat;
			document.getElementById('out-hue').textContent = `${paletteAlgo.hue}°`;
			document.getElementById('out-warmth').textContent = `${paletteAlgo.warmth}`;
			document.getElementById('out-contrast').textContent = `${paletteAlgo.contrast}%`;
			document.getElementById('out-sat').textContent = `${paletteAlgo.sat}%`;
		}

		for (const [id, key] of [['slider-hue', 'hue'], ['slider-warmth', 'warmth'], ['slider-contrast', 'contrast'], ['slider-sat', 'sat']]) {
			document.getElementById(id).addEventListener('input', e => {
				paletteAlgo.preset = 'custom';
				paletteAlgo[key] = Number(e.target.value);
				syncAlgoSliderInputs();
				const theme = themes.find(t => t.id === selectedThemeId) || themes[0];
				renderPaletteStudio(resolveEffectiveTheme(theme));
			});
		}
		document.getElementById('reset-palette-btn').addEventListener('click', () => {
			Object.assign(paletteAlgo, { preset: 'default', hue: 0, warmth: 0, contrast: 100, sat: 100 });
			syncAlgoSliderInputs();
			const theme = themes.find(t => t.id === selectedThemeId) || themes[0];
			renderPaletteStudio(resolveEffectiveTheme(theme));
		});

		function updateTokenExportCode(theme, primitives, semantics) {
			const viewer = document.getElementById('token-file-viewer');
			const status = document.getElementById('token-file-status');
			const cssLines = Object.entries(semantics).map(([k, v]) => `\t--klp-colors-${k}: ${v};`).join('\n');
			if (selectedTokenFmt === 'css') {
				viewer.textContent = `/* Kallopis Style Export: ${theme.id} (${currentMode}) */\n[data-klp-theme="${theme.id}"][data-klp-mode="${currentMode}"] {\n${cssLines}\n}`;
			} else if (selectedTokenFmt === 'js') {
				viewer.textContent = `export const kallopisTheme = ${JSON.stringify({ id: theme.id, mode: currentMode, algo: paletteAlgo, semantics, primitives }, null, '\t')};\n`;
			} else if (selectedTokenFmt === 'json') {
				viewer.textContent = JSON.stringify({ id: theme.id, mode: currentMode, semantics, primitives }, null, '\t');
			} else {
				viewer.textContent = `// Kallopis Flutter Theme (${theme.id} · ${currentMode})\nimport 'package:kallopis/kallopis_theme.dart';\n\nfinal theme = KlpThemeData.fromTokens(\n\tid: '${theme.id}',\n\taccent: const Color(0xFF${semantics.accent.slice(1)}),\n\tsurface: const Color(0xFF${semantics.surface.slice(1)}),\n);`;
			}
			status.textContent = `${theme.id}.${selectedTokenFmt} · LIVE`;
		}

		for (const fmtBtn of document.querySelectorAll('#token-format-tabs [data-token-fmt]')) {
			fmtBtn.addEventListener('click', () => {
				selectedTokenFmt = fmtBtn.dataset.tokenFmt;
				for (const b of document.querySelectorAll('#token-format-tabs [data-token-fmt]')) b.setAttribute('aria-selected', String(b.dataset.tokenFmt === selectedTokenFmt));
				renderColorDesignPage();
			});
		}

		document.getElementById('copy-full-token-btn').addEventListener('click', async () => {
			const btn = document.getElementById('copy-full-token-btn');
			const dict = i18n[currentLang] || i18n.en;
			try {
				await navigator.clipboard.writeText(document.getElementById('token-file-viewer').textContent);
				btn.textContent = '✓ Copied';
				setTimeout(() => { btn.textContent = dict.copyFullTokens; }, 1400);
			} catch {}
		});

		document.getElementById('download-live-token-btn').addEventListener('click', () => {
			const theme = resolveEffectiveTheme(themes.find(t => t.id === selectedThemeId) || themes[0]);
			const ext = selectedTokenFmt === 'flutter' ? 'dart' : selectedTokenFmt;
			const blob = new Blob([document.getElementById('token-file-viewer').textContent], { type: 'text/plain;charset=utf-8' });
			const url = URL.createObjectURL(blob);
			const a = document.createElement('a');
			a.href = url;
			a.download = `${theme.id}-${currentMode}.${ext}`;
			a.click();
			URL.revokeObjectURL(url);
		});

		// 區塊 4：嘗試其他風格（顯示其餘 11 套風格卡片導覽）
		function renderOtherStylesGrid() {
			const container = document.getElementById('other-styles-grid');
			const others = themes.filter(t => t.id !== selectedThemeId);
			container.innerHTML = others.map(t => `
				<button type="button" class="style-grid-card" data-other-theme="${t.id}" data-klp-component="KlpCard">
					<div class="rep-canvas" data-klp-theme="${t.id}" data-klp-mode="${currentMode}" style="height:126px;display:flex;flex-direction:column;justify-content:space-between;padding:14px;">
						<span class="eyebrow" style="font-size:9.5px;">${t.id}</span>
						<div style="display:flex;gap:6px;">
							<span style="flex:1;height:28px;border-radius:6px;background:var(--klp-colors-surface);"></span>
							<span style="flex:1;height:28px;border-radius:6px;background:var(--klp-colors-component);"></span>
							<span style="flex:1;height:28px;border-radius:6px;background:var(--klp-colors-accent);"></span>
						</div>
					</div>
					<div class="revolve-card-footer">
						<span class="revolve-card-name">${t.name[currentLang] || t.name.en}</span>
						<span class="revolve-card-arrow">↗</span>
					</div>
				</button>
			`).join('');
			for (const btn of container.querySelectorAll('[data-other-theme]')) {
				btn.addEventListener('click', () => {
					selectedThemeId = btn.dataset.otherTheme;
					renderStylePreviewPage();
					window.scrollTo({ top: 0, behavior: 'smooth' });
				});
			}
		}

		// 參考文件頁：左側完整已註冊元件樹 + 右側上方獨立互動元件 + 下方多語言程式碼
		function renderReferenceNav(filter = '') {
			const tree = document.getElementById('ref-cat-tree');
			const prevScrollTop = tree.scrollTop;
			const openCats = new Set([...tree.querySelectorAll('details[data-cat-id][open]')].map(d => d.dataset.catId));
			openCats.add(activeRefCatId);
			const q = filter.trim().toLowerCase();
			const totalCount = registeredRegistry.reduce((sum, c) => sum + c.items.length, 0);
			document.getElementById('ref-total-count').textContent = currentLang === 'en' ? `${totalCount} Registered` : `${totalCount} 已註冊`;

			tree.innerHTML = registeredRegistry.map(cat => {
				const matched = cat.items.filter(item => !q || `${item.id} ${cat.title.en} ${cat.title['zh-Hant']}`.toLowerCase().includes(q));
				if (!matched.length) return '';
				const isOpen = Boolean(q) || openCats.has(cat.id);
				return `<details class="ref-cat-details" data-cat-id="${cat.id}" ${isOpen ? 'open' : ''}><summary><span>${cat.title[currentLang] || cat.title.en}</span><span class="eyebrow">${matched.length}</span></summary><div class="ref-cat-items">${matched.map(item => `<button type="button" class="ref-comp-btn" data-ref-cat="${cat.id}" data-ref-comp="${item.id}" aria-current="${item.id === activeRefCompId}">${item.id}</button>`).join('')}</div></details>`;
			}).join('');

			tree.scrollTop = prevScrollTop;

			for (const btn of tree.querySelectorAll('[data-ref-comp]')) {
				btn.addEventListener('click', () => {
					activeRefCatId = btn.dataset.refCat;
					activeRefCompId = btn.dataset.refComp;
					renderReferenceNav(document.getElementById('ref-search-input').value);
					renderReferenceStage();
				});
			}
		}

		document.getElementById('ref-search-input').addEventListener('input', e => renderReferenceNav(e.target.value));

		function renderRegisteredComponentDemo(compId, container) {
			const isEn = currentLang === 'en';
			if (compId === 'KlpTextField') {
				container.innerHTML = `<div class="demo-card-shell"><div class="m-field"><input type="text" id="ref-tf" placeholder=" " maxlength="32" value="Kallopis"><label for="ref-tf">${isEn ? 'Project Name' : '專案名稱'}</label></div><div class="m-field-meta"><span id="ref-tf-msg">${isEn ? '✓ Valid' : '✓ 格式正確'}</span><span id="ref-tf-cnt">8 / 32</span></div></div>`;
				const inp = container.querySelector('#ref-tf');
				inp.addEventListener('input', () => {
					const ok = inp.value.trim().length >= 2;
					container.querySelector('#ref-tf-cnt').textContent = `${inp.value.length} / 32`;
					container.querySelector('#ref-tf-msg').textContent = ok ? (isEn ? '✓ Valid' : '✓ 格式正確') : (isEn ? 'Min 2 chars' : '至少 2 字元');
				});
			} else if (compId === 'KlpTextArea') {
				container.innerHTML = `<div class="demo-card-shell"><label style="display:block;font-size:12px;color:var(--klp-colors-textMuted);margin-bottom:6px;">${isEn ? 'Notes' : '多行備註'}</label><textarea rows="4" style="width:100%;padding:10px 12px;border-radius:var(--style-radius);border:1px solid var(--klp-colors-border);background:var(--klp-colors-component);color:var(--klp-colors-text);font:inherit;">${isEn ? 'Semantic style constraints keep cross-framework apps consistent.' : '語意風格約束讓跨框架應用保持一致秩序。'}</textarea></div>`;
			} else if (compId === 'KlpSwitch') {
				container.innerHTML = `<div class="demo-card-shell"><div class="m-switch-row"><div><strong>${isEn ? 'Enable Style Constraints' : '啟用風格約束'}</strong><div style="font-size:12px;color:var(--klp-colors-textMuted);">${isEn ? 'KlpSwitch toggle control' : 'KlpSwitch 切換開關'}</div></div><button type="button" class="m-switch on" role="switch" aria-checked="true"><span class="m-switch-thumb"></span></button></div></div>`;
				const sw = container.querySelector('.m-switch');
				sw.addEventListener('click', () => { const on = !sw.classList.contains('on'); sw.classList.toggle('on', on); sw.setAttribute('aria-checked', String(on)); });
			} else if (compId === 'KlpCheckbox') {
				container.innerHTML = `<div class="demo-card-shell" style="display:grid;gap:10px;">${(isEn ? ['Include React TSX', 'Include Flutter Dart', 'Export AI Skills'] : ['包含 React TSX', '包含 Flutter Dart', '匯出 AI Skills']).map((l, i) => `<label style="display:flex;align-items:center;gap:10px;cursor:pointer;font-size:14px;"><input type="checkbox" ${i < 2 ? 'checked' : ''} style="width:17px;height:17px;accent-color:var(--klp-colors-accent);"><span>${l}</span></label>`).join('')}</div>`;
			} else if (compId === 'KlpRadioGroup') {
				container.innerHTML = `<div class="demo-card-shell" style="display:grid;gap:10px;">${(isEn ? ['Micro Elevation', 'Full Glass', 'Hairline'] : ['微立體', '飽滿玻璃', '平面細線']).map((l, i) => `<label style="display:flex;align-items:center;gap:10px;cursor:pointer;font-size:14px;"><input type="radio" name="klp-demo-radio" ${i === 0 ? 'checked' : ''} style="width:16px;height:16px;accent-color:var(--klp-colors-accent);"><span>${l}</span></label>`).join('')}</div>`;
			} else if (compId === 'KlpSelect' || compId === 'KlpComboBox' || compId === 'KlpMultiSelect') {
				const opts = isEn ? ['Elevation', 'Editorial Minimal', 'Dev Precision', 'Quant Terminal'] : ['立體浮層', '編輯簡約', '開發精密', '金融終端'];
				container.innerHTML = `<div class="demo-card-shell" style="display:flex;justify-content:center;"><div class="klp-custom-dropdown"><button type="button" class="klp-dd-trigger" id="ref-dd-btn"><span id="ref-dd-val">${opts[0]}</span><span>▾</span></button><div class="klp-dd-menu" id="ref-dd-menu" hidden>${opts.map((o, i) => `<button type="button" class="klp-dd-opt" data-opt="${o}" aria-selected="${i === 0}">${o}</button>`).join('')}</div></div></div>`;
				const btn = container.querySelector('#ref-dd-btn');
				const menu = container.querySelector('#ref-dd-menu');
				const val = container.querySelector('#ref-dd-val');
				btn.addEventListener('click', () => { menu.hidden = !menu.hidden; });
				for (const o of menu.querySelectorAll('[data-opt]')) {
					o.addEventListener('click', () => {
						val.textContent = o.dataset.opt;
						for (const x of menu.querySelectorAll('[data-opt]')) x.setAttribute('aria-selected', String(x === o));
						menu.hidden = true;
					});
				}
			} else if (compId === 'KlpSlider') {
				container.innerHTML = `<div class="demo-card-shell"><div class="algo-slider-row"><label><span>${isEn ? 'Corner Radius' : '圓角比例'}</span><output id="ref-sl-out">12px</output></label><input type="range" id="ref-sl-in" min="0" max="24" value="12"></div></div>`;
				const sl = container.querySelector('#ref-sl-in');
				sl.addEventListener('input', () => { container.querySelector('#ref-sl-out').textContent = `${sl.value}px`; });
			} else if (compId === 'KlpButton' || compId === 'KlpSplitButton' || compId === 'KlpSystemAction') {
				motionComponents.find(c => c.id === 'button-micro').render(container, 0, currentLang);
			} else if (compId === 'KlpIconButton') {
				motionComponents.find(c => c.id === 'icon-morph').render(container, 0, currentLang);
			} else if (compId === 'KlpTabs') {
				motionComponents.find(c => c.id === 'tab-bar').render(container, 0, currentLang);
			} else if (compId === 'KlpTooltip') {
				motionComponents.find(c => c.id === 'tooltip-motion').render(container, 0, currentLang);
			} else if (compId === 'KlpDrawer') {
				motionComponents.find(c => c.id === 'side-drawer').render(container, 0, currentLang);
			} else if (compId === 'KlpSkeleton') {
				motionComponents.find(c => c.id === 'skeleton-loading').render(container, 0, currentLang);
			} else if (compId === 'KlpSpinner') {
				container.innerHTML = `<div class="demo-card-shell" style="display:flex;align-items:center;justify-content:center;gap:14px;"><span class="m-spinner" style="width:26px;height:26px;"></span><span>${isEn ? 'Syncing tokens…' : '正在同步語意色票…'}</span></div>`;
			} else {
				container.innerHTML = `<div class="demo-card-shell" style="display:flex;flex-direction:column;gap:12px;"><div style="display:flex;justify-content:space-between;align-items:center;"><strong>${compId}</strong><span class="rich-badge">Registered</span></div><p style="margin:0;font-size:13px;color:var(--klp-colors-textMuted);">${isEn ? 'Live semantic preview adapting to the active style and Day/Night mode.' : '即時套用目前風格與深淺色模式的已註冊元件實景。'}</p><div style="display:flex;gap:8px;"><button type="button" class="klp-btn primary">${isEn ? 'Inspect' : '檢視互動'}</button><button type="button" class="klp-btn">${isEn ? 'Secondary' : '次要狀態'}</button></div></div>`;
			}
		}

		function buildComponentSnippets(compId, themeId) {
			return {
				react: `import { ${compId} } from '@kallopis/react';\n\nexport function Example() {\n\treturn (\n\t\t<${compId} data-klp-theme="${themeId}" />\n\t);\n}`,
				flutter: `import 'package:kallopis/kallopis_foundation.dart';\n\nWidget build(BuildContext context) {\n\treturn ${compId}();\n}`,
				html: `<!-- ${compId} (${themeId}) -->\n<div data-klp-component="${compId}" data-klp-theme="${themeId}"></div>`,
			};
		}

		function renderReferenceStage() {
			const cat = registeredRegistry.find(c => c.id === activeRefCatId) || registeredRegistry[0];
			const item = cat.items.find(i => i.id === activeRefCompId) || cat.items[0];
			const theme = resolveEffectiveTheme(themes.find(t => t.id === selectedThemeId) || themes[0]);

			document.getElementById('ref-comp-cat').textContent = `${cat.title[currentLang] || cat.title.en} · REGISTERED`;
			document.getElementById('ref-comp-name').textContent = item.id;
			document.getElementById('ref-comp-desc').textContent = item.desc[currentLang] || item.desc.en;
			document.getElementById('ref-stage-style-badge').textContent = `${theme.id} · ${currentMode}`;

			refDemoCanvas.dataset.klpTheme = theme.id;
			refDemoCanvas.dataset.klpVisualStyle = theme.family;
			refDemoCanvas.dataset.klpVisualMode = currentMode;
			refDemoCanvas.dataset.klpMode = currentMode;
			refDemoCanvas.dataset.styleFamily = theme.family;
			renderRegisteredComponentDemo(item.id, refDemoCanvas);

			const snippets = buildComponentSnippets(item.id, theme.id);
			document.getElementById('code-viewer-block').textContent = snippets[selectedLang] || snippets.react;
		}

		function renderReferencePage() {
			renderReferenceNav(document.getElementById('ref-search-input').value);
			renderReferenceStage();
		}

		function renderStylePreviewPage() {
			const theme = themes.find(t => t.id === selectedThemeId) || themes[0];
			const effective = resolveEffectiveTheme(theme);
			document.getElementById('elevation-intensity-bar').hidden = !theme.adjustableElevation;
			document.getElementById('stage-theme-meta').textContent = `${theme.englishName} · ${effective.id}`;
			document.getElementById('stage-theme-title').textContent = theme.name[currentLang] || theme.name.en;
			document.getElementById('stage-theme-desc').textContent = theme.desc[currentLang] || theme.desc.en;
			renderInteractiveRepScreen({ ...theme, id: effective.id, family: effective.family, elevDepth: effective.elevDepth });
			syncCategoryExamples(effective);
			renderPaletteStudio(effective);
			renderOtherStylesGrid();
		}

		for (const langBtn of document.querySelectorAll('#code-lang-tabs [data-lang]')) {
			langBtn.addEventListener('click', () => {
				selectedLang = langBtn.dataset.lang;
				for (const b of document.querySelectorAll('#code-lang-tabs [data-lang]')) b.setAttribute('aria-selected', String(b.dataset.lang === selectedLang));
				renderReferenceStage();
			});
		}
		document.getElementById('copy-code-btn').addEventListener('click', async () => {
			const btn = document.getElementById('copy-code-btn');
			const dict = i18n[currentLang] || i18n.en;
			try { await navigator.clipboard.writeText(document.getElementById('code-viewer-block').textContent); btn.textContent = '✓'; setTimeout(() => { btn.textContent = dict.copyCode; }, 1200); } catch {}
		});

		applyLanguage('en');
		applyGlobalMode('light');
		const initRoute = document.documentElement.dataset.klpInitialRoute;
		if (initRoute && initRoute !== 'home') navigateTo(initRoute);
