// 由 styles/scripts/generate-themes.mjs 自動產生，禁止手改。
export const themeMetadata = Object.freeze([
	{
		"id": "micro-elevation-v1",
		"family": "micro-elevation",
		"version": "1.0.0",
		"name": "微立體",
		"englishName": "Micro Elevation",
		"defaultMode": "dark",
		"description": "溫潤深炭灰分層表面，結合微浮陰影與頂部微亮邊、琥珀金強調色與低對比膠囊選取態，適合長時間專注知識工作台。",
		"packPath": "styles/themes/micro-elevation-v1.json",
		"cssPath": "styles/themes/micro-elevation-v1.css",
		"jsPath": "styles/themes/micro-elevation-v1.js",
		"surfaceCssPath": "styles/themes/micro-elevation-v1.surface.css",
		"previewImage": "styles/images/theme-micro-elevation.jpg",
		"sourceReference": "Kallopis Micro Elevation Workbench",
		"surfaceStyle": "layered-charcoal-cards",
		"elevationStyle": "bevel-shadow",
		"typography": "Noto Sans TC · IBM Plex Mono",
		"palettePreview": {
			"light": [
				"#E8E5DE",
				"#F2F0EA",
				"#FAF9F6",
				"#22201C",
				"#B5852A"
			],
			"dark": [
				"#1A1A18",
				"#242320",
				"#2C2B28",
				"#EDEAE4",
				"#D4A853"
			]
		}
	},
	{
		"id": "modern-minimal-v1",
		"family": "modern-minimal",
		"version": "1.0.0",
		"name": "現代簡約風",
		"englishName": "Modern Minimal (Editorial)",
		"defaultMode": "light",
		"description": "取自 open-tag 的 Quietly Editorial 設計語彙：米白畫布 #F5F5F5、暖炭墨黑 #292524、1px 細線分隔、EB Garamond 編輯襯線與柔和漸層光暈點綴。",
		"packPath": "styles/themes/modern-minimal-v1.json",
		"cssPath": "styles/themes/modern-minimal-v1.css",
		"jsPath": "styles/themes/modern-minimal-v1.js",
		"surfaceCssPath": "styles/themes/modern-minimal-v1.surface.css",
		"previewImage": "styles/images/showcase-home.png",
		"sourceReference": "https://github.com/fancyboi999/open-tag",
		"surfaceStyle": "editorial-hairline",
		"elevationStyle": "flat-hairline",
		"typography": "EB Garamond · Inter · Noto Sans TC",
		"orbs": [
			"#A7E5D3",
			"#F4C5A8",
			"#C8B8E0",
			"#A8C8E8",
			"#E8B8C4"
		],
		"palettePreview": {
			"light": [
				"#F5F5F5",
				"#F0EFED",
				"#FFFFFF",
				"#292524",
				"#E7E5E4"
			],
			"dark": [
				"#0C0A09",
				"#141210",
				"#1C1917",
				"#FFFFFF",
				"#F4C5A8"
			]
		}
	},
	{
		"id": "kallopis-v1",
		"family": "kallopis",
		"version": "1.0.0",
		"name": "暖紙預設",
		"englishName": "Kallopis Parchment",
		"defaultMode": "light",
		"description": "Kallopis 原始暖紙視覺基準：parchment 層次與低對比中性控制項，支援四種標準模式。",
		"packPath": "styles/kallopis-v1.json",
		"cssPath": "styles/themes/kallopis-v1.css",
		"jsPath": "styles/themes/kallopis-v1.js",
		"surfaceCssPath": "styles/themes/kallopis-v1.surface.css",
		"previewImage": "styles/images/sidebar-stage-dark.png",
		"sourceReference": "docs/design-tokens/KALLOPIS-DESIGN-MAP.md",
		"surfaceStyle": "parchment-paper",
		"elevationStyle": "subtle-relief",
		"typography": "Noto Sans TC · IBM Plex Mono",
		"palettePreview": {
			"light": [
				"#E7E4DD",
				"#EFEDE7",
				"#F8F6F1",
				"#21201B",
				"#D3CFC4"
			],
			"dark": [
				"#201F1C",
				"#292724",
				"#35322D",
				"#F0EDE6",
				"#514B40"
			]
		}
	}
]);
export const themePacks = Object.freeze({
	"micro-elevation-v1": {
		"schemaVersion": 1,
		"id": "micro-elevation-v1",
		"version": "1.0.0",
		"primitives": {
			"parchment50": "#FFF8F6F1",
			"parchment75": "#FFF0EDE6",
			"parchment100": "#FFEFEDE7",
			"parchment150": "#FFE7E4DD",
			"parchment200": "#FFE1DDD2",
			"parchment250": "#FFD3CFC4",
			"parchment350": "#FFBAB5AA",
			"parchment550": "#FF6A655B",
			"parchment700": "#FF514B40",
			"parchment750": "#FF484339",
			"parchment800": "#FF35322D",
			"parchment825": "#FF33322C",
			"parchment900": "#FF292724",
			"parchment925": "#FF21201B",
			"parchment950": "#FF201F1C",
			"ink1000": "#FF000000",
			"transparent": "#00000000",
			"ink50": "#FFFFFFFF",
			"ink100": "#FFF2F0EB",
			"ink150": "#FFEAE7E1",
			"ink200": "#FFE6E3DC",
			"ink250": "#FFBCB8B0",
			"ink300": "#FFADA89E",
			"ink350": "#FF9E998F",
			"ink400": "#FF8E8982",
			"ink450": "#FF7F7A75",
			"ink500": "#FF6F6C67",
			"ink550": "#FF6B6459",
			"ink600": "#FF4F5151",
			"ink650": "#FF414344",
			"ink700": "#FF343637",
			"ink750": "#FF303030",
			"ink800": "#FF292929",
			"ink850": "#FF232323",
			"ink900": "#FF1D1D1D",
			"ink950": "#FF101010",
			"warmNeutral25": "#FFF5F2EC",
			"warmNeutral50": "#FFE4E1DA",
			"warmNeutral100": "#FFD6D0C6",
			"warmNeutral200": "#FFC8C0B4",
			"warmNeutral300": "#FFB8B2A4",
			"warmNeutral400": "#FF918A7B",
			"warmNeutral450": "#FF8C8477",
			"warmNeutral500": "#FF7A7566",
			"warmNeutral600": "#FF6A6256",
			"warmNeutral700": "#FF585249",
			"warmNeutral750": "#FF45413A",
			"warmNeutral800": "#FF433F3A",
			"warmNeutral900": "#FF34302B",
			"sand50": "#FFF8F1E2",
			"sand300": "#FFF0D79A",
			"sand500": "#FFE0BE73",
			"sand800": "#FF453D2B",
			"sand900": "#FF302B20",
			"gold50": "#FFF6EBD7",
			"gold300": "#FFE8BD70",
			"gold500": "#FFD3A152",
			"gold800": "#FF443725",
			"gold900": "#FF30271B",
			"ochre50": "#FFF3E4CF",
			"ochre300": "#FFDFA04E",
			"ochre500": "#FFC6823D",
			"ochre800": "#FF413222",
			"ochre900": "#FF2E241A",
			"terracotta50": "#FFEEDDD0",
			"terracotta300": "#FFC88745",
			"terracotta500": "#FFA96836",
			"terracotta800": "#FF3D2D22",
			"terracotta900": "#FF2C211B",
			"clay50": "#FFE9D8D1",
			"clay300": "#FFA86D43",
			"clay500": "#FF895137",
			"clay800": "#FF382A23",
			"clay900": "#FF291F1C",
			"umber50": "#FFE4D5D1",
			"umber300": "#FF89573E",
			"umber500": "#FF683E33",
			"umber800": "#FF332724",
			"umber900": "#FF261D1C",
			"green100": "#FFDFF0E5",
			"green400": "#FF67AE86",
			"green500": "#FF51B77B",
			"green600": "#FF2D8057",
			"green800": "#FF243B2D",
			"green900": "#FF1D3025",
			"red100": "#FFFAE3E2",
			"red300": "#FFFA6C73",
			"red400": "#FFD27B74",
			"red600": "#FFA7443F",
			"red800": "#FF472925",
			"red900": "#FF3B2320",
			"amber500": "#FFF6B52E",
			"blue500": "#FF5499DF",
			"scrim": "#99010202",
			"line": "#00000000",
			"transparentSurface": "#9426292D",
			"transparentSurfaceInset": "#A8404449",
			"pureWhite": "#FFFFFFFF",
			"pureBlack": "#FF000000",
			"accent-ink-light": "#FF1D1D1D",
			"accent-ink-dark": "#FFFFFFFF",
			"accent-terracotta-light": "#FF92563C",
			"accent-terracotta-dark": "#FFCB8E72",
			"accent-ochre-light": "#FF7D612F",
			"accent-ochre-dark": "#FFB99860",
			"accent-olive-light": "#FF5E6A39",
			"accent-olive-dark": "#FF94A366",
			"accent-slate-light": "#FF4E678A",
			"accent-slate-dark": "#FF879EBD",
			"accent-crimson-light": "#FF9F4B59",
			"accent-crimson-dark": "#FFCE8A95",
			"color-b8292724": "#B8292724",
			"color-b835322d": "#B835322D",
			"space0": 0,
			"space50": 2,
			"space100": 4,
			"space200": 8,
			"space250": 10,
			"space300": 12,
			"space400": 16,
			"space600": 24,
			"space800": 32,
			"space1000": 40,
			"space1200": 48,
			"space1600": 64,
			"space2400": 96,
			"radius0": 0,
			"radius50": 2,
			"radius100": 4,
			"radius150": 6,
			"radius200": 8,
			"radius250": 10,
			"radius300": 12,
			"radius400": 16,
			"radiusFull": 9999,
			"stroke0": 0,
			"stroke100": 1,
			"stroke200": 2,
			"font100": 10,
			"font200": 12,
			"font300": 14,
			"font400": 16,
			"font500": 18,
			"font600": 22,
			"font700": 28,
			"font800": 36,
			"font900": 48,
			"font1000": 64,
			"tracking0": 0,
			"trackingTight": -0.5,
			"trackingWide": 1.2,
			"trackingWider": 1.32,
			"length-30": 30,
			"length-56": 56,
			"length-20": 20,
			"length-60": 60,
			"length-74": 74,
			"length-170": 170,
			"length-11": 11,
			"length-3": 3,
			"length-5": 5,
			"length-7": 7,
			"length-3_5": 3.5,
			"length-41_4": 41.4,
			"length-168": 168,
			"length-26": 26,
			"length-520": 520,
			"length-320": 320,
			"length-120": 120,
			"length-9": 9,
			"length-220": 220,
			"length-192": 192,
			"length-128": 128,
			"length-112": 112,
			"length-10_5": 10.5,
			"length-336": 336,
			"length-300": 300,
			"length-350": 350,
			"length-400": 400,
			"length-800": 800,
			"length-960": 960,
			"length-1120": 1120,
			"length-200": 200,
			"length-360": 360,
			"length-480": 480,
			"length-1380": 1380,
			"length-880": 880,
			"length-260": 260,
			"length-820": 820,
			"length-minus-1": -1,
			"leading100": 1.125,
			"leading116": 1.166,
			"leading120": 1.2,
			"leading122": 1.222,
			"leading127": 1.272,
			"leading128": 1.285,
			"leading133": 1.333,
			"leading142": 1.428,
			"leading150": 1.5,
			"leading155": 1.555,
			"leading150Legacy": 1.2,
			"leading200": 1.25,
			"leading300": 1.3,
			"leading350": 1.35,
			"leading400": 1.4,
			"leading450": 1.45,
			"leading500": 1.5,
			"leading550": 1.55,
			"leading650": 1.65,
			"ratio-0_4": 0.4,
			"ratio-0_35": 0.35,
			"ratio-0_32": 0.32,
			"ratio-0_22": 0.22,
			"ratio-0_06": 0.06,
			"ratio-8": 8,
			"ratio-2": 2,
			"ratio-3": 3,
			"ratio-6": 6,
			"weight400": 400,
			"weight500": 500,
			"weight600": 600,
			"weight700": 700,
			"weight800": 800,
			"duration0": 0,
			"duration100": 120,
			"duration150": 140,
			"duration400": 450,
			"duration500": 500,
			"duration-4000": 4000,
			"duration-1000": 1000,
			"easeStandard": "[0.215, 0.61, 0.355, 1.0]",
			"easeEmphasized": "[0.645, 0.045, 0.355, 1.0]",
			"opacity100": 0.1,
			"opacity120": 0.12,
			"opacity140": 0.14,
			"opacity160": 0.16,
			"opacity180": 0.18,
			"opacity220": 0.22,
			"opacity280": 0.28,
			"opacity320": 0.32,
			"opacity350": 0.35,
			"opacity440": 0.44,
			"opacity480": 0.48,
			"opacity550": 0.55,
			"opacity620": 0.62,
			"opacity720": 0.72,
			"opacity780": 0.78,
			"opacity820": 0.82,
			"opacity-0_13333333333333333": 0.13333333333333333,
			"opacity-0_6": 0.6,
			"opacity-0_88": 0.88,
			"opacity-0_47843137254901963": 0.47843137254901963,
			"opacity-0_1803921568627451": 0.1803921568627451,
			"opacity-0_07058823529411765": 0.07058823529411765,
			"opacity-0_8509803921568627": 0.8509803921568627,
			"family-packages-kallopis-noto-sans-tc": "packages/kallopis/Noto Sans TC",
			"family-noto-sans-tc": "Noto Sans TC",
			"family-microsoft-jhenghei-ui": "Microsoft JhengHei UI",
			"family-microsoft-jhenghei": "Microsoft JhengHei",
			"family-pingfang-tc": "PingFang TC",
			"family-sans-serif": "sans-serif",
			"family-packages-kallopis-ibm-plex-mono": "packages/kallopis/IBM Plex Mono",
			"family-ibm-plex-mono": "IBM Plex Mono",
			"family-consolas": "Consolas",
			"family-courier-new": "Courier New",
			"family-monospace": "monospace",
			"string-shadow": "shadow",
			"count-4": 4,
			"count-8": 8,
			"length-15": 15,
			"meDarkApp": "#FF1A1A18",
			"meDarkSurface": "#FF242320",
			"meDarkInset": "#FF1E1D1B",
			"meDarkMuted": "#FF2A2925",
			"meDarkComponent": "#FF353430",
			"meDarkStage": "#FF2C2B28",
			"meDarkRaised": "#FF302F2B",
			"meDarkBorder": "#FF3C3A36",
			"meDarkBorderStrong": "#FF524F49",
			"meDarkText": "#FFEDEAE4",
			"meDarkMutedText": "#FFA8A49B",
			"meDarkFaintText": "#FF6F6B63",
			"meDarkAmber": "#FFD4A853",
			"meDarkAmberSoft": "#FF3F3523",
			"meDarkHover": "#FF3E3C37",
			"meLightApp": "#FFE8E5DE",
			"meLightSurface": "#FFF2F0EA",
			"meLightInset": "#FFE2DFD7",
			"meLightMuted": "#FFE9E6DF",
			"meLightComponent": "#FFFFFFFF",
			"meLightStage": "#FFFAF9F6",
			"meLightRaised": "#FFFAF9F6",
			"meLightBorder": "#FFD8D4CA",
			"meLightBorderStrong": "#FFBDB8AC",
			"meLightText": "#FF22201C",
			"meLightMutedText": "#FF6A655B",
			"meLightFaintText": "#FF8D887D",
			"meLightAmber": "#FFB5852A",
			"meLightAmberSoft": "#FFF3E7CD",
			"meLightHover": "#FFE6E2D8",
			"meTransSurface": "#D9242320",
			"meTransStage": "#E62C2B28",
			"meRadiusPanel": 10
		},
		"semantics": {
			"theme.colors.app": {
				"light": "p(meLightApp)",
				"dark": "p(meDarkApp)",
				"ultraDark": "p(ink950)",
				"transparent": "p(transparent)"
			},
			"theme.colors.surface": {
				"light": "p(meLightSurface)",
				"dark": "p(meDarkSurface)",
				"ultraDark": "p(meDarkApp)",
				"transparent": "p(meTransSurface)"
			},
			"theme.colors.surfaceInset": {
				"light": "p(meLightInset)",
				"dark": "p(meDarkInset)",
				"ultraDark": "p(ink950)",
				"transparent": "p(meDarkInset)"
			},
			"theme.colors.surfaceMuted": {
				"light": "p(meLightMuted)",
				"dark": "p(meDarkMuted)",
				"ultraDark": "p(meDarkSurface)",
				"transparent": "p(meDarkMuted)"
			},
			"theme.colors.component": {
				"light": "p(meLightComponent)",
				"dark": "p(meDarkComponent)",
				"ultraDark": "p(meDarkSurface)",
				"transparent": "p(meDarkComponent)"
			},
			"theme.colors.stageSurface": {
				"light": "p(meLightStage)",
				"dark": "p(meDarkStage)",
				"ultraDark": "p(meDarkSurface)",
				"transparent": "p(meTransStage)"
			},
			"theme.colors.overlay": {
				"light": "p(meLightRaised)",
				"dark": "p(meDarkRaised)",
				"ultraDark": "p(meDarkSurface)",
				"transparent": "p(meDarkRaised)"
			},
			"theme.colors.surfaceRaised": {
				"light": "p(meLightRaised)",
				"dark": "p(meDarkRaised)",
				"ultraDark": "p(meDarkSurface)",
				"transparent": "p(meDarkRaised)"
			},
			"theme.colors.modalScrim": {
				"light": "p(scrim)",
				"dark": "p(scrim)",
				"ultraDark": "p(scrim)",
				"transparent": "p(scrim)"
			},
			"theme.colors.guide": {
				"light": "p(meLightBorder)",
				"dark": "p(meDarkBorder)",
				"ultraDark": "p(meDarkBorder)",
				"transparent": "p(meDarkBorder)"
			},
			"theme.colors.divider": {
				"light": "p(meLightBorder)",
				"dark": "p(meDarkBorder)",
				"ultraDark": "p(meDarkBorder)",
				"transparent": "p(meDarkBorder)"
			},
			"theme.colors.pagePattern": {
				"light": "p(meLightBorder)",
				"dark": "p(meDarkBorder)",
				"ultraDark": "p(meDarkBorder)",
				"transparent": "p(meDarkBorder)"
			},
			"theme.colors.text": {
				"light": "p(meLightText)",
				"dark": "p(meDarkText)",
				"ultraDark": "p(meDarkText)",
				"transparent": "p(meDarkText)"
			},
			"theme.colors.textMuted": {
				"light": "p(meLightMutedText)",
				"dark": "p(meDarkMutedText)",
				"ultraDark": "p(meDarkMutedText)",
				"transparent": "p(meDarkMutedText)"
			},
			"theme.colors.textFaint": {
				"light": "p(meLightFaintText)",
				"dark": "p(meDarkFaintText)",
				"ultraDark": "p(meDarkFaintText)",
				"transparent": "p(meDarkFaintText)"
			},
			"theme.colors.border": {
				"light": "p(meLightBorder)",
				"dark": "p(meDarkBorder)",
				"ultraDark": "p(meDarkBorder)",
				"transparent": "p(meDarkBorder)"
			},
			"theme.colors.borderStrong": {
				"light": "p(meLightBorderStrong)",
				"dark": "p(meDarkBorderStrong)",
				"ultraDark": "p(meDarkBorderStrong)",
				"transparent": "p(meDarkBorderStrong)"
			},
			"theme.colors.brand": {
				"light": "p(meLightHover)",
				"dark": "p(meDarkComponent)",
				"ultraDark": "p(meDarkRaised)",
				"transparent": "p(meDarkComponent)"
			},
			"theme.colors.accent": {
				"light": "p(meLightAmber)",
				"dark": "p(meDarkAmber)",
				"ultraDark": "p(meDarkAmber)",
				"transparent": "p(meDarkAmber)"
			},
			"theme.colors.accentSoft": {
				"light": "p(meLightAmberSoft)",
				"dark": "p(meDarkAmberSoft)",
				"ultraDark": "p(meDarkAmberSoft)",
				"transparent": "p(meDarkAmberSoft)"
			},
			"theme.colors.interaction": {
				"light": "p(meLightAmber)",
				"dark": "p(meDarkAmber)",
				"ultraDark": "p(meDarkAmber)",
				"transparent": "p(meDarkAmber)"
			},
			"theme.colors.interactionSoft": {
				"light": "p(meLightHover)",
				"dark": "p(meDarkHover)",
				"ultraDark": "p(meDarkHover)",
				"transparent": "p(meDarkHover)"
			},
			"theme.colors.success": {
				"light": "p(green500)",
				"dark": "p(green500)",
				"ultraDark": "p(green500)",
				"transparent": "p(green500)"
			},
			"theme.colors.warning": {
				"light": "p(amber500)",
				"dark": "p(amber500)",
				"ultraDark": "p(amber500)",
				"transparent": "p(amber500)"
			},
			"theme.colors.danger": {
				"light": "p(red300)",
				"dark": "p(red300)",
				"ultraDark": "p(red300)",
				"transparent": "p(red300)"
			},
			"theme.colors.info": {
				"light": "p(blue500)",
				"dark": "p(blue500)",
				"ultraDark": "p(blue500)",
				"transparent": "p(blue500)"
			},
			"theme.colors.onStatus": {
				"light": "p(ink50)",
				"dark": "p(ink50)",
				"ultraDark": "p(ink50)",
				"transparent": "p(ink50)"
			},
			"theme.colors.onLightBackground": {
				"light": "p(meLightText)",
				"dark": "p(meLightText)",
				"ultraDark": "p(meLightText)",
				"transparent": "p(meLightText)"
			},
			"theme.colors.onDarkBackground": {
				"light": "p(meDarkText)",
				"dark": "p(meDarkText)",
				"ultraDark": "p(meDarkText)",
				"transparent": "p(meDarkText)"
			},
			"theme.colors.mutedOnLightBackground": {
				"light": "p(parchment550)",
				"dark": "p(parchment550)",
				"ultraDark": "p(ink550)",
				"transparent": "p(parchment550)"
			},
			"theme.colors.mutedOnDarkBackground": {
				"light": "p(parchment350)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink300)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.faintOnBackground": {
				"light": "p(parchment550)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink400)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.transparent": {
				"light": "p(transparent)",
				"dark": "p(transparent)",
				"ultraDark": "p(transparent)",
				"transparent": "p(transparent)"
			},
			"theme.typography.sansFamily": {
				"light": "p(family-packages-kallopis-noto-sans-tc)",
				"dark": "p(family-packages-kallopis-noto-sans-tc)",
				"ultraDark": "p(family-packages-kallopis-noto-sans-tc)",
				"transparent": "p(family-packages-kallopis-noto-sans-tc)"
			},
			"theme.typography.sansFallback": {
				"light": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"dark": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"ultraDark": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"transparent": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]"
			},
			"theme.typography.monoFamily": {
				"light": "p(family-packages-kallopis-ibm-plex-mono)",
				"dark": "p(family-packages-kallopis-ibm-plex-mono)",
				"ultraDark": "p(family-packages-kallopis-ibm-plex-mono)",
				"transparent": "p(family-packages-kallopis-ibm-plex-mono)"
			},
			"theme.typography.monoFallback": {
				"light": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"dark": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"ultraDark": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"transparent": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]"
			},
			"theme.typography.uiFamily": {
				"light": "p(family-packages-kallopis-noto-sans-tc)",
				"dark": "p(family-packages-kallopis-noto-sans-tc)",
				"ultraDark": "p(family-packages-kallopis-noto-sans-tc)",
				"transparent": "p(family-packages-kallopis-noto-sans-tc)"
			},
			"theme.typography.bodyFamily": {
				"light": "p(family-packages-kallopis-noto-sans-tc)",
				"dark": "p(family-packages-kallopis-noto-sans-tc)",
				"ultraDark": "p(family-packages-kallopis-noto-sans-tc)",
				"transparent": "p(family-packages-kallopis-noto-sans-tc)"
			},
			"theme.typography.codeFamily": {
				"light": "p(family-packages-kallopis-ibm-plex-mono)",
				"dark": "p(family-packages-kallopis-ibm-plex-mono)",
				"ultraDark": "p(family-packages-kallopis-ibm-plex-mono)",
				"transparent": "p(family-packages-kallopis-ibm-plex-mono)"
			},
			"theme.typography.micro": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.typography.caption": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.typography.sub": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.typography.body": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.typography.lead": {
				"light": "p(font500)",
				"dark": "p(font500)",
				"ultraDark": "p(font500)",
				"transparent": "p(font500)"
			},
			"theme.typography.h4": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.typography.h3": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.typography.h2": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.typography.h1": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.typography.display": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.typography.label": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.typography.section": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.typography.headingSmall": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.typography.heading": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.typography.title": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.typography.microLeading": {
				"light": "p(leading120)",
				"dark": "p(leading120)",
				"ultraDark": "p(leading120)",
				"transparent": "p(leading120)"
			},
			"theme.typography.captionLeading": {
				"light": "p(leading133)",
				"dark": "p(leading133)",
				"ultraDark": "p(leading133)",
				"transparent": "p(leading133)"
			},
			"theme.typography.subLeading": {
				"light": "p(leading142)",
				"dark": "p(leading142)",
				"ultraDark": "p(leading142)",
				"transparent": "p(leading142)"
			},
			"theme.typography.bodyLeading": {
				"light": "p(leading150)",
				"dark": "p(leading150)",
				"ultraDark": "p(leading150)",
				"transparent": "p(leading150)"
			},
			"theme.typography.leadLeading": {
				"light": "p(leading155)",
				"dark": "p(leading155)",
				"ultraDark": "p(leading155)",
				"transparent": "p(leading155)"
			},
			"theme.typography.h4Leading": {
				"light": "p(leading127)",
				"dark": "p(leading127)",
				"ultraDark": "p(leading127)",
				"transparent": "p(leading127)"
			},
			"theme.typography.h3Leading": {
				"light": "p(leading128)",
				"dark": "p(leading128)",
				"ultraDark": "p(leading128)",
				"transparent": "p(leading128)"
			},
			"theme.typography.h2Leading": {
				"light": "p(leading122)",
				"dark": "p(leading122)",
				"ultraDark": "p(leading122)",
				"transparent": "p(leading122)"
			},
			"theme.typography.h1Leading": {
				"light": "p(leading116)",
				"dark": "p(leading116)",
				"ultraDark": "p(leading116)",
				"transparent": "p(leading116)"
			},
			"theme.typography.displayLeading": {
				"light": "p(leading100)",
				"dark": "p(leading100)",
				"ultraDark": "p(leading100)",
				"transparent": "p(leading100)"
			},
			"theme.typography.headingLeading": {
				"light": "p(leading122)",
				"dark": "p(leading122)",
				"ultraDark": "p(leading122)",
				"transparent": "p(leading122)"
			},
			"theme.typography.codeLeading": {
				"light": "p(leading142)",
				"dark": "p(leading142)",
				"ultraDark": "p(leading142)",
				"transparent": "p(leading142)"
			},
			"theme.typography.readingLeading": {
				"light": "p(leading155)",
				"dark": "p(leading155)",
				"ultraDark": "p(leading155)",
				"transparent": "p(leading155)"
			},
			"theme.typography.labelLeading": {
				"light": "p(leading133)",
				"dark": "p(leading133)",
				"ultraDark": "p(leading133)",
				"transparent": "p(leading133)"
			},
			"theme.typography.labelTracking": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.typography.displayTracking": {
				"light": "p(trackingTight)",
				"dark": "p(trackingTight)",
				"ultraDark": "p(trackingTight)",
				"transparent": "p(trackingTight)"
			},
			"theme.typography.regular": {
				"light": "p(weight400)",
				"dark": "p(weight400)",
				"ultraDark": "p(weight400)",
				"transparent": "p(weight400)"
			},
			"theme.typography.medium": {
				"light": "p(weight400)",
				"dark": "p(weight400)",
				"ultraDark": "p(weight400)",
				"transparent": "p(weight400)"
			},
			"theme.typography.semiBold": {
				"light": "p(weight600)",
				"dark": "p(weight600)",
				"ultraDark": "p(weight600)",
				"transparent": "p(weight600)"
			},
			"theme.typography.bold": {
				"light": "p(weight700)",
				"dark": "p(weight700)",
				"ultraDark": "p(weight700)",
				"transparent": "p(weight700)"
			},
			"theme.typography.extraBold": {
				"light": "p(weight700)",
				"dark": "p(weight700)",
				"ultraDark": "p(weight700)",
				"transparent": "p(weight700)"
			},
			"theme.typography.strong": {
				"light": "p(weight600)",
				"dark": "p(weight600)",
				"ultraDark": "p(weight600)",
				"transparent": "p(weight600)"
			},
			"theme.spacing.space0_5": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.spacing.space1": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.space2": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.space3": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.space4": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.space6": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.space8": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.space12": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.space16": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.spacing.space24": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.spacing.hairline": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.spacing.tight": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.contentInlineGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.contentStackGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.contentInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.controlContentGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.controlInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.actionGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromeGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromePanelInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromeToolbarGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationItemInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationRailInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationRailItemGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayContentInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayHeadingGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayItemGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationSectionGap": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.spacing.appFrameInset": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.windowHeaderMargin": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.dockMargin": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.base": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.comfortable": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.loose": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.section": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.sectionLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.page": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.spacing.pageLarge": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.spacing.controlPaddingXSmall": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.controlPaddingX": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.controlPaddingXLarge": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.controlPaddingXXLarge": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.controlPaddingY": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.containerPadding": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.itemGap": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.groupGap": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.controlHeightXSmall": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.spacing.controlHeightSmall": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.spacing.controlHeight": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.spacing.controlHeightLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.controlHeightXLarge": {
				"light": "p(length-56)",
				"dark": "p(length-56)",
				"ultraDark": "p(length-56)",
				"transparent": "p(length-56)"
			},
			"theme.spacing.iconSmall": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.spacing.iconBase": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.iconGlyph": {
				"light": "p(font500)",
				"dark": "p(font500)",
				"ultraDark": "p(font500)",
				"transparent": "p(font500)"
			},
			"theme.spacing.icon": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.spacing.iconMedium": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.iconLarge": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.chromeHeader": {
				"light": "p(length-60)",
				"dark": "p(length-60)",
				"ultraDark": "p(length-60)",
				"transparent": "p(length-60)"
			},
			"theme.spacing.chromeStatusBar": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.spacing.chromeRail": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.chromeTab": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.iconButton": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.iconTiny": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.spacing.indicatorDot": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.spacing.indicatorDotLarge": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.noticeIconSlot": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.spacing.toastIconSlot": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.spacing.gutterNumber": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.gutterMarker": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.spacing.micro": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.spacing.calendarContentCell": {
				"light": "p(length-74)",
				"dark": "p(length-74)",
				"ultraDark": "p(length-74)",
				"transparent": "p(length-74)"
			},
			"theme.spacing.gridTileWidth": {
				"light": "p(length-170)",
				"dark": "p(length-170)",
				"ultraDark": "p(length-170)",
				"transparent": "p(length-170)"
			},
			"theme.spacing.iconMicro": {
				"light": "p(length-11)",
				"dark": "p(length-11)",
				"ultraDark": "p(length-11)",
				"transparent": "p(length-11)"
			},
			"theme.spacing.avatarSmall": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.progressTrack": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.spacing.skeletonLine": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.spacing.railItem": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.shape.none": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.shape.sm": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.control": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.shape.controlInner": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.shape.toggleTrack": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.shape.card": {
				"light": "p(radius200)",
				"dark": "p(radius200)",
				"ultraDark": "p(radius200)",
				"transparent": "p(radius200)"
			},
			"theme.shape.panel": {
				"light": "p(meRadiusPanel)",
				"dark": "p(meRadiusPanel)",
				"ultraDark": "p(meRadiusPanel)",
				"transparent": "p(meRadiusPanel)"
			},
			"theme.shape.pill": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.shape.hairline": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.shape.stroke": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.dashedLength": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.shape.dashedGap": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.dashedOpacity": {
				"light": "p(opacity780)",
				"dark": "p(opacity780)",
				"ultraDark": "p(opacity780)",
				"transparent": "p(opacity780)"
			},
			"theme.motion.themeTransition": {
				"light": "p(duration0)",
				"dark": "p(duration0)",
				"ultraDark": "p(duration0)",
				"transparent": "p(duration0)"
			},
			"theme.motion.styleTransition": {
				"light": "p(duration0)",
				"dark": "p(duration0)",
				"ultraDark": "p(duration0)",
				"transparent": "p(duration0)"
			},
			"theme.motion.stateTransition": {
				"light": "p(duration150)",
				"dark": "p(duration150)",
				"ultraDark": "p(duration150)",
				"transparent": "p(duration150)"
			},
			"theme.motion.overlayEnter": {
				"light": "p(duration150)",
				"dark": "p(duration150)",
				"ultraDark": "p(duration150)",
				"transparent": "p(duration150)"
			},
			"theme.motion.overlayExit": {
				"light": "p(duration100)",
				"dark": "p(duration100)",
				"ultraDark": "p(duration100)",
				"transparent": "p(duration100)"
			},
			"theme.motion.toastDwell": {
				"light": "p(duration500)",
				"dark": "p(duration500)",
				"ultraDark": "p(duration500)",
				"transparent": "p(duration500)"
			},
			"theme.motion.tooltipDelay": {
				"light": "p(duration400)",
				"dark": "p(duration400)",
				"ultraDark": "p(duration400)",
				"transparent": "p(duration400)"
			},
			"theme.motion.tooltipDwell": {
				"light": "p(duration-4000)",
				"dark": "p(duration-4000)",
				"ultraDark": "p(duration-4000)",
				"transparent": "p(duration-4000)"
			},
			"theme.motion.spinnerCycle": {
				"light": "p(duration-1000)",
				"dark": "p(duration-1000)",
				"ultraDark": "p(duration-1000)",
				"transparent": "p(duration-1000)"
			},
			"theme.motion.longPressThreshold": {
				"light": "p(duration500)",
				"dark": "p(duration500)",
				"ultraDark": "p(duration500)",
				"transparent": "p(duration500)"
			},
			"theme.motion.standard": {
				"light": "p(easeStandard)",
				"dark": "p(easeStandard)",
				"ultraDark": "p(easeStandard)",
				"transparent": "p(easeStandard)"
			},
			"theme.motion.emphasized": {
				"light": "p(easeEmphasized)",
				"dark": "p(easeEmphasized)",
				"ultraDark": "p(easeEmphasized)",
				"transparent": "p(easeEmphasized)"
			},
			"theme.surface.separation": {
				"light": "p(string-shadow)",
				"dark": "p(string-shadow)",
				"ultraDark": "p(string-shadow)",
				"transparent": "p(string-shadow)"
			},
			"theme.surface.overlayBlur": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.surface.overlaySpread": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.surface.overlayOffsetY": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.surface.overlayShadowOpacity": {
				"light": "p(opacity-0_13333333333333333)",
				"dark": "p(opacity-0_13333333333333333)",
				"ultraDark": "p(opacity-0_13333333333333333)",
				"transparent": "p(opacity-0_13333333333333333)"
			},
			"theme.surface.scrimOpacity": {
				"light": "p(opacity-0_6)",
				"dark": "p(opacity-0_6)",
				"ultraDark": "p(opacity-0_6)",
				"transparent": "p(opacity-0_6)"
			},
			"theme.surface.selectionWashOpacity": {
				"light": "p(opacity100)",
				"dark": "p(opacity100)",
				"ultraDark": "p(opacity100)",
				"transparent": "p(opacity100)"
			},
			"theme.surface.focusWashOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.statusFillOpacity": {
				"light": "p(opacity160)",
				"dark": "p(opacity160)",
				"ultraDark": "p(opacity160)",
				"transparent": "p(opacity160)"
			},
			"theme.surface.pressProgressOpacity": {
				"light": "p(opacity550)",
				"dark": "p(opacity550)",
				"ultraDark": "p(opacity550)",
				"transparent": "p(opacity550)"
			},
			"theme.surface.diffFillOpacity": {
				"light": "p(opacity120)",
				"dark": "p(opacity120)",
				"ultraDark": "p(opacity120)",
				"transparent": "p(opacity120)"
			},
			"theme.surface.gridLineOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.veilOpacity": {
				"light": "p(opacity820)",
				"dark": "p(opacity820)",
				"ultraDark": "p(opacity820)",
				"transparent": "p(opacity820)"
			},
			"theme.surface.statusRowOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.statusRowSelectedOpacity": {
				"light": "p(opacity320)",
				"dark": "p(opacity320)",
				"ultraDark": "p(opacity320)",
				"transparent": "p(opacity320)"
			},
			"theme.surface.statusRowOpacityDark": {
				"light": "p(opacity280)",
				"dark": "p(opacity280)",
				"ultraDark": "p(opacity280)",
				"transparent": "p(opacity280)"
			},
			"theme.surface.statusRowSelectedOpacityDark": {
				"light": "p(opacity480)",
				"dark": "p(opacity480)",
				"ultraDark": "p(opacity480)",
				"transparent": "p(opacity480)"
			},
			"theme.surface.frostedOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.frostedVeilOpacity": {
				"light": "p(opacity120)",
				"dark": "p(opacity120)",
				"ultraDark": "p(opacity120)",
				"transparent": "p(opacity120)"
			},
			"theme.surface.backdropBlurSigma": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.surface.dragOpacity": {
				"light": "p(opacity820)",
				"dark": "p(opacity820)",
				"ultraDark": "p(opacity820)",
				"transparent": "p(opacity820)"
			},
			"theme.surface.dragSourceOpacity": {
				"light": "p(opacity350)",
				"dark": "p(opacity350)",
				"ultraDark": "p(opacity350)",
				"transparent": "p(opacity350)"
			},
			"theme.surface.themePreviewDisabledOpacity": {
				"light": "p(opacity620)",
				"dark": "p(opacity620)",
				"ultraDark": "p(opacity620)",
				"transparent": "p(opacity620)"
			},
			"theme.surface.listStatusOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.listStatusSelectedOpacity": {
				"light": "p(opacity320)",
				"dark": "p(opacity320)",
				"ultraDark": "p(opacity320)",
				"transparent": "p(opacity320)"
			},
			"theme.surface.accentSoftOpacityLight": {
				"light": "p(opacity160)",
				"dark": "p(opacity160)",
				"ultraDark": "p(opacity160)",
				"transparent": "p(opacity160)"
			},
			"theme.surface.accentSoftOpacityDark": {
				"light": "p(opacity220)",
				"dark": "p(opacity220)",
				"ultraDark": "p(opacity220)",
				"transparent": "p(opacity220)"
			},
			"theme.surface.windowPaneOpacityLight": {
				"light": "p(opacity-0_88)",
				"dark": "p(opacity-0_88)",
				"ultraDark": "p(opacity-0_88)",
				"transparent": "p(opacity-0_88)"
			},
			"theme.surface.windowPaneOpacityDark": {
				"light": "p(opacity720)",
				"dark": "p(opacity720)",
				"ultraDark": "p(opacity720)",
				"transparent": "p(opacity720)"
			},
			"theme.surface.invalidFillOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.contactBlur": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.surface.contactOffsetY": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.surface.contactShadowOpacity": {
				"light": "p(opacity-0_13333333333333333)",
				"dark": "p(opacity-0_13333333333333333)",
				"ultraDark": "p(opacity-0_13333333333333333)",
				"transparent": "p(opacity-0_13333333333333333)"
			},
			"theme.surface.overlayShadowColor": {
				"light": "p(ink1000)",
				"dark": "p(ink1000)",
				"ultraDark": "p(ink1000)",
				"transparent": "p(ink1000)"
			},
			"theme.components.buttonRadius": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.components.buttonPaddingX": {
				"light": "s(theme.spacing.controlPaddingX)",
				"dark": "s(theme.spacing.controlPaddingX)",
				"ultraDark": "s(theme.spacing.controlPaddingX)",
				"transparent": "s(theme.spacing.controlPaddingX)"
			},
			"theme.components.buttonPaddingY": {
				"light": "s(theme.spacing.controlPaddingY)",
				"dark": "s(theme.spacing.controlPaddingY)",
				"ultraDark": "s(theme.spacing.controlPaddingY)",
				"transparent": "s(theme.spacing.controlPaddingY)"
			},
			"theme.components.buttonHeight": {
				"light": "s(theme.geometry.control.buttonHeight)",
				"dark": "s(theme.geometry.control.buttonHeight)",
				"ultraDark": "s(theme.geometry.control.buttonHeight)",
				"transparent": "s(theme.geometry.control.buttonHeight)"
			},
			"theme.components.buttonBorderWidth": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.components.fieldRadius": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.components.fieldPaddingX": {
				"light": "s(theme.spacing.controlInset)",
				"dark": "s(theme.spacing.controlInset)",
				"ultraDark": "s(theme.spacing.controlInset)",
				"transparent": "s(theme.spacing.controlInset)"
			},
			"theme.components.fieldHeight": {
				"light": "s(theme.geometry.control.fieldHeight)",
				"dark": "s(theme.geometry.control.fieldHeight)",
				"ultraDark": "s(theme.geometry.control.fieldHeight)",
				"transparent": "s(theme.geometry.control.fieldHeight)"
			},
			"theme.components.fieldBorderWidth": {
				"light": "s(theme.shape.none)",
				"dark": "s(theme.shape.none)",
				"ultraDark": "s(theme.shape.none)",
				"transparent": "s(theme.shape.none)"
			},
			"theme.components.menuRadius": {
				"light": "s(theme.shape.card)",
				"dark": "s(theme.shape.card)",
				"ultraDark": "s(theme.shape.card)",
				"transparent": "s(theme.shape.card)"
			},
			"theme.components.menuPadding": {
				"light": "s(theme.spacing.overlayContentInset)",
				"dark": "s(theme.spacing.overlayContentInset)",
				"ultraDark": "s(theme.spacing.overlayContentInset)",
				"transparent": "s(theme.spacing.overlayContentInset)"
			},
			"theme.components.menuItemHeight": {
				"light": "s(theme.geometry.layout.menuItemHeight)",
				"dark": "s(theme.geometry.layout.menuItemHeight)",
				"ultraDark": "s(theme.geometry.layout.menuItemHeight)",
				"transparent": "s(theme.geometry.layout.menuItemHeight)"
			},
			"theme.components.cardRadius": {
				"light": "s(theme.shape.card)",
				"dark": "s(theme.shape.card)",
				"ultraDark": "s(theme.shape.card)",
				"transparent": "s(theme.shape.card)"
			},
			"theme.components.cardPadding": {
				"light": "s(theme.spacing.containerPadding)",
				"dark": "s(theme.spacing.containerPadding)",
				"ultraDark": "s(theme.spacing.containerPadding)",
				"transparent": "s(theme.spacing.containerPadding)"
			},
			"theme.components.badgeRadius": {
				"light": "s(theme.shape.pill)",
				"dark": "s(theme.shape.pill)",
				"ultraDark": "s(theme.shape.pill)",
				"transparent": "s(theme.shape.pill)"
			},
			"theme.components.badgePaddingX": {
				"light": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"dark": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"ultraDark": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"transparent": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))"
			},
			"theme.geometry.control.switchTrackWidth": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.switchTrackHeight": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.geometry.control.switchThumb": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.geometry.control.buttonHeightXSmall": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.geometry.control.buttonHeightSmall": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.control.buttonHeight": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.buttonHeightLarge": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.geometry.control.buttonHeightXLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.geometry.control.pageBackgroundHitRadius": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.presenceMarkerExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.colorPickerCursorRadius": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.swatchExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.segmentedProgressHeight": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.fieldHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.control.selectionControl": {
				"light": "p(length-15)",
				"dark": "p(length-15)",
				"ultraDark": "p(length-15)",
				"transparent": "p(length-15)"
			},
			"theme.geometry.control.selectionIndicatorInset": {
				"light": "p(length-3_5)",
				"dark": "p(length-3_5)",
				"ultraDark": "p(length-3_5)",
				"transparent": "p(length-3_5)"
			},
			"theme.geometry.control.selectionIcon": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.geometry.control.toggleWidth": {
				"light": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"dark": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"ultraDark": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"transparent": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))"
			},
			"theme.geometry.control.toggleHeight": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.geometry.control.toggleThumb": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.geometry.control.toggleInset": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.control.segmentedDenseHeight": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.geometry.control.segmentedDenseInset": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.geometry.control.segmentedDenseContentInset": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.geometry.control.segmentedDenseItemHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.control.slidingSelectionHeight": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.slidingSelectionSegmentWidth": {
				"light": "p(length-41_4)",
				"dark": "p(length-41_4)",
				"ultraDark": "p(length-41_4)",
				"transparent": "p(length-41_4)"
			},
			"theme.geometry.control.slidingSelectionPadding": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.geometry.control.slidingSelectionIndicatorHeight": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.geometry.control.scrollbarThickness": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.geometry.control.sliderTrackHeight": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.geometry.control.colorPlaneExtent": {
				"light": "p(length-168)",
				"dark": "p(length-168)",
				"ultraDark": "p(length-168)",
				"transparent": "p(length-168)"
			},
			"theme.geometry.control.textFieldIndicatorHeightFactor": {
				"light": "p(ratio-0_4)",
				"dark": "p(ratio-0_4)",
				"ultraDark": "p(ratio-0_4)",
				"transparent": "p(ratio-0_4)"
			},
			"theme.geometry.control.textFieldLineHeightFactor": {
				"light": "p(leading300)",
				"dark": "p(leading300)",
				"ultraDark": "p(leading300)",
				"transparent": "p(leading300)"
			},
			"theme.geometry.control.textFieldMinLines": {
				"light": "p(count-4)",
				"dark": "p(count-4)",
				"ultraDark": "p(count-4)",
				"transparent": "p(count-4)"
			},
			"theme.geometry.control.textFieldMaxLines": {
				"light": "p(count-8)",
				"dark": "p(count-8)",
				"ultraDark": "p(count-8)",
				"transparent": "p(count-8)"
			},
			"theme.geometry.control.fileExplorerRowHeightAdjustment": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.geometry.data.codeActionButtonSize": {
				"light": "p(length-26)",
				"dark": "p(length-26)",
				"ultraDark": "p(length-26)",
				"transparent": "p(length-26)"
			},
			"theme.geometry.data.codeHeaderHeight": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.data.codeTerminalDot": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.geometry.data.codeTerminalDotGap": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.geometry.data.codeHeaderPaddingX": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.geometry.data.codeBodyPaddingX": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.geometry.data.codeLineNumberWidth": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.data.codeWrappedLineWidth": {
				"light": "p(length-520)",
				"dark": "p(length-520)",
				"ultraDark": "p(length-520)",
				"transparent": "p(length-520)"
			},
			"theme.geometry.data.codeMaximumHeight": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.data.codeCollapsedHeight": {
				"light": "p(length-120)",
				"dark": "p(length-120)",
				"ultraDark": "p(length-120)",
				"transparent": "p(length-120)"
			},
			"theme.geometry.data.codeDisclosureSize": {
				"light": "p(length-9)",
				"dark": "p(length-9)",
				"ultraDark": "p(length-9)",
				"transparent": "p(length-9)"
			},
			"theme.geometry.data.filePreviewHeight": {
				"light": "p(length-220)",
				"dark": "p(length-220)",
				"ultraDark": "p(length-220)",
				"transparent": "p(length-220)"
			},
			"theme.geometry.data.previewCardCompactHeight": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.geometry.data.previewCardStandardHeight": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.geometry.data.previewCardLargeHeight": {
				"light": "p(length-192)",
				"dark": "p(length-192)",
				"ultraDark": "p(length-192)",
				"transparent": "p(length-192)"
			},
			"theme.geometry.data.dateGridCellHeight": {
				"light": "p(length-128)",
				"dark": "p(length-128)",
				"ultraDark": "p(length-128)",
				"transparent": "p(length-128)"
			},
			"theme.geometry.data.keyValueLabelWidthCompact": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.geometry.data.keyValueLabelWidthStandard": {
				"light": "p(length-112)",
				"dark": "p(length-112)",
				"ultraDark": "p(length-112)",
				"transparent": "p(length-112)"
			},
			"theme.geometry.data.stepperMarkerSize": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.data.stepperLabelWidth": {
				"light": "p(length-60)",
				"dark": "p(length-60)",
				"ultraDark": "p(length-60)",
				"transparent": "p(length-60)"
			},
			"theme.geometry.data.progressIndeterminateFraction": {
				"light": "p(ratio-0_35)",
				"dark": "p(ratio-0_35)",
				"ultraDark": "p(ratio-0_35)",
				"transparent": "p(ratio-0_35)"
			},
			"theme.geometry.data.placeholderMinimumHeight": {
				"light": "p(length-120)",
				"dark": "p(length-120)",
				"ultraDark": "p(length-120)",
				"transparent": "p(length-120)"
			},
			"theme.geometry.data.placeholderContentPaddingY": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.geometry.data.placeholderActionPaddingY": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.geometry.data.placeholderHatchBand": {
				"light": "p(length-10_5)",
				"dark": "p(length-10_5)",
				"ultraDark": "p(length-10_5)",
				"transparent": "p(length-10_5)"
			},
			"theme.geometry.data.placeholderHatchGap": {
				"light": "p(length-10_5)",
				"dark": "p(length-10_5)",
				"ultraDark": "p(length-10_5)",
				"transparent": "p(length-10_5)"
			},
			"theme.geometry.data.placeholderLabelTracking": {
				"light": "p(trackingWider)",
				"dark": "p(trackingWider)",
				"ultraDark": "p(trackingWider)",
				"transparent": "p(trackingWider)"
			},
			"theme.geometry.data.placeholderDetailMaximumWidth": {
				"light": "p(length-336)",
				"dark": "p(length-336)",
				"ultraDark": "p(length-336)",
				"transparent": "p(length-336)"
			},
			"theme.geometry.data.spinnerSquareFactor": {
				"light": "p(ratio-0_32)",
				"dark": "p(ratio-0_32)",
				"ultraDark": "p(ratio-0_32)",
				"transparent": "p(ratio-0_32)"
			},
			"theme.geometry.data.spinnerOrbitFactor": {
				"light": "p(ratio-0_22)",
				"dark": "p(ratio-0_22)",
				"ultraDark": "p(ratio-0_22)",
				"transparent": "p(ratio-0_22)"
			},
			"theme.geometry.data.spinnerCornerFactor": {
				"light": "p(ratio-0_06)",
				"dark": "p(ratio-0_06)",
				"ultraDark": "p(ratio-0_06)",
				"transparent": "p(ratio-0_06)"
			},
			"theme.geometry.layout.drawerWidth": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.layout.drawerHeight": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.layout.resizeHandleExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.overlayViewportInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.railDropTargetExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.disclosureIconSize": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.treeLeadingGap": {
				"light": "p(ratio-8)",
				"dark": "p(ratio-8)",
				"ultraDark": "p(ratio-8)",
				"transparent": "p(ratio-8)"
			},
			"theme.geometry.layout.tooltipOffsetX": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.primaryPaneWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.secondaryPaneWidth": {
				"light": "p(length-350)",
				"dark": "p(length-350)",
				"ultraDark": "p(length-350)",
				"transparent": "p(length-350)"
			},
			"theme.geometry.layout.primaryPaneBreakpoint": {
				"light": "p(length-400)",
				"dark": "p(length-400)",
				"ultraDark": "p(length-400)",
				"transparent": "p(length-400)"
			},
			"theme.geometry.layout.primaryPaneContentBreakpoint": {
				"light": "p(length-800)",
				"dark": "p(length-800)",
				"ultraDark": "p(length-800)",
				"transparent": "p(length-800)"
			},
			"theme.geometry.layout.responsivePaneBreakpoint": {
				"light": "p(length-960)",
				"dark": "p(length-960)",
				"ultraDark": "p(length-960)",
				"transparent": "p(length-960)"
			},
			"theme.geometry.layout.secondaryPaneBreakpoint": {
				"light": "p(length-1120)",
				"dark": "p(length-1120)",
				"ultraDark": "p(length-1120)",
				"transparent": "p(length-1120)"
			},
			"theme.geometry.layout.menuWidth": {
				"light": "p(length-200)",
				"dark": "p(length-200)",
				"ultraDark": "p(length-200)",
				"transparent": "p(length-200)"
			},
			"theme.geometry.layout.commandMenuWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.menuHeaderHeight": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.geometry.layout.menuItemHeight": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.geometry.layout.dialogMaximumWidth": {
				"light": "p(length-520)",
				"dark": "p(length-520)",
				"ultraDark": "p(length-520)",
				"transparent": "p(length-520)"
			},
			"theme.geometry.layout.toastMaximumWidth": {
				"light": "p(length-360)",
				"dark": "p(length-360)",
				"ultraDark": "p(length-360)",
				"transparent": "p(length-360)"
			},
			"theme.geometry.layout.inlineNoticeBreakpoint": {
				"light": "p(length-480)",
				"dark": "p(length-480)",
				"ultraDark": "p(length-480)",
				"transparent": "p(length-480)"
			},
			"theme.geometry.layout.statusBarBreakpoint": {
				"light": "p(length-400)",
				"dark": "p(length-400)",
				"ultraDark": "p(length-400)",
				"transparent": "p(length-400)"
			},
			"theme.geometry.layout.settingsDialogMaximumWidth": {
				"light": "p(length-1380)",
				"dark": "p(length-1380)",
				"ultraDark": "p(length-1380)",
				"transparent": "p(length-1380)"
			},
			"theme.geometry.layout.settingsDialogMaximumHeight": {
				"light": "p(length-880)",
				"dark": "p(length-880)",
				"ultraDark": "p(length-880)",
				"transparent": "p(length-880)"
			},
			"theme.geometry.layout.settingsPaneGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.settingsNavigationWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.settingsNavigationMinimumWidth": {
				"light": "p(length-260)",
				"dark": "p(length-260)",
				"ultraDark": "p(length-260)",
				"transparent": "p(length-260)"
			},
			"theme.geometry.layout.settingsNavigationMaximumWidth": {
				"light": "p(length-360)",
				"dark": "p(length-360)",
				"ultraDark": "p(length-360)",
				"transparent": "p(length-360)"
			},
			"theme.geometry.layout.settingsContentMaximumWidth": {
				"light": "p(length-820)",
				"dark": "p(length-820)",
				"ultraDark": "p(length-820)",
				"transparent": "p(length-820)"
			},
			"theme.geometry.layout.themePreviewTileWidth": {
				"light": "p(length-168)",
				"dark": "p(length-168)",
				"ultraDark": "p(length-168)",
				"transparent": "p(length-168)"
			},
			"theme.geometry.layout.windowHeaderHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.layout.windowHeaderControlSize": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.layout.windowAppIconSize": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.geometry.layout.windowIdentityGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.optical.menuIconOffsetY": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.optical.railBadgeInset": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.geometry.optical.statusIconOffsetY": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.optical.monoBaselineOffsetY": {
				"light": "p(length-minus-1)",
				"dark": "p(length-minus-1)",
				"ultraDark": "p(length-minus-1)",
				"transparent": "p(length-minus-1)"
			},
			"theme.geometry.optical.uiBaselineOffsetY": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.dataVisualization.series": {
				"light": "[p(sand500), p(gold500), p(ochre500), p(terracotta500), p(clay500), p(umber500)]",
				"dark": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]",
				"ultraDark": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]",
				"transparent": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]"
			},
			"theme.dataVisualization.seriesWash": {
				"light": "[p(sand50), p(gold50), p(ochre50), p(terracotta50), p(clay50), p(umber50)]",
				"dark": "[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]",
				"ultraDark": "[p(sand900), p(gold900), p(ochre900), p(terracotta900), p(clay900), p(umber900)]",
				"transparent": "[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]"
			},
			"theme.dataVisualization.axis": {
				"light": "p(warmNeutral100)",
				"dark": "p(warmNeutral700)",
				"ultraDark": "p(warmNeutral750)",
				"transparent": "p(warmNeutral700)"
			},
			"theme.dataVisualization.grid": {
				"light": "p(warmNeutral50)",
				"dark": "p(warmNeutral800)",
				"ultraDark": "p(warmNeutral900)",
				"transparent": "p(warmNeutral800)"
			},
			"theme.dataVisualization.gridStrong": {
				"light": "p(warmNeutral200)",
				"dark": "p(warmNeutral600)",
				"ultraDark": "p(warmNeutral700)",
				"transparent": "p(warmNeutral600)"
			},
			"theme.dataVisualization.label": {
				"light": "p(ink550)",
				"dark": "p(warmNeutral300)",
				"ultraDark": "p(warmNeutral300)",
				"transparent": "p(warmNeutral300)"
			},
			"theme.dataVisualization.value": {
				"light": "p(ink900)",
				"dark": "p(warmNeutral25)",
				"ultraDark": "p(warmNeutral25)",
				"transparent": "p(warmNeutral25)"
			},
			"theme.dataVisualization.plotBackground": {
				"light": "p(transparent)",
				"dark": "p(transparent)",
				"ultraDark": "p(transparent)",
				"transparent": "p(transparent)"
			},
			"theme.dataVisualization.crosshair": {
				"light": "p(warmNeutral450)",
				"dark": "p(warmNeutral400)",
				"ultraDark": "p(warmNeutral500)",
				"transparent": "p(warmNeutral400)"
			},
			"theme.dataVisualization.marketUp": {
				"light": "p(green600)",
				"dark": "p(green400)",
				"ultraDark": "p(green400)",
				"transparent": "p(green400)"
			},
			"theme.dataVisualization.marketUpWash": {
				"light": "p(green100)",
				"dark": "p(green800)",
				"ultraDark": "p(green900)",
				"transparent": "p(green800)"
			},
			"theme.dataVisualization.marketDown": {
				"light": "p(red600)",
				"dark": "p(red400)",
				"ultraDark": "p(red400)",
				"transparent": "p(red400)"
			},
			"theme.dataVisualization.marketDownWash": {
				"light": "p(red100)",
				"dark": "p(red800)",
				"ultraDark": "p(red900)",
				"transparent": "p(red800)"
			},
			"theme.dataVisualization.marketFlat": {
				"light": "p(warmNeutral450)",
				"dark": "p(warmNeutral400)",
				"ultraDark": "p(warmNeutral500)",
				"transparent": "p(warmNeutral400)"
			}
		},
		"recipes": {
			"app-background": {
				"aliases": "app background／應用背景／頁面背景",
				"inherit": "—",
				"parameters": "background=s(theme.colors.app); foreground=s(theme.colors.text); padding=p(space0); border=none; radius=s(theme.shape.none); size=產品決定; shadow=none"
			},
			"workspace-layout": {
				"aliases": "工作區間距／workspace layout",
				"inherit": "—",
				"parameters": "background=繼承 app-background.background; frame-inset=s(theme.spacing.space2); frame-gap=s(theme.spacing.space2); size=產品決定; border=none"
			},
			"surface-base": {
				"aliases": "一般／輔助表面／surface base",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-inset": {
				"aliases": "內嵌表面／surface inset",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-muted": {
				"aliases": "弱化表面／surface muted",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceMuted); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-component": {
				"aliases": "控制表面／surface component",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-overlay": {
				"aliases": "浮層表面／surface overlay",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-raised": {
				"aliases": "較亮表面／surface raised",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceRaised); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-stage": {
				"aliases": "主內容表面／surface stage",
				"inherit": "—",
				"parameters": "background=s(theme.colors.stageSurface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-accent": {
				"aliases": "強調表面／surface accent",
				"inherit": "—",
				"parameters": "background=s(theme.colors.accent); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-accent-soft": {
				"aliases": "柔和強調表面／surface accent-soft",
				"inherit": "—",
				"parameters": "background=s(theme.colors.accentSoft); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-transparent": {
				"aliases": "透明表面／surface transparent",
				"inherit": "—",
				"parameters": "background=s(theme.colors.transparent); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-frosted": {
				"aliases": "毛玻璃表面／frosted",
				"inherit": "surface-base",
				"parameters": "background=alpha(繼承.background,s(theme.surface.frostedOpacity)); blur-sigma=s(theme.surface.backdropBlurSigma); geometry=繼承"
			},
			"text-tone-primary": {
				"aliases": "主文字色／primary text／prominent",
				"inherit": "—",
				"parameters": "color=s(theme.colors.text); typography=繼承父層; padding/border=不適用; size=內容決定"
			},
			"text-tone-muted": {
				"aliases": "次要文字／說明文字／muted",
				"inherit": "text-tone-primary",
				"parameters": "color=s(theme.colors.textMuted)"
			},
			"text-tone-faint": {
				"aliases": "弱化文字／提示文字色／faint",
				"inherit": "text-tone-primary",
				"parameters": "color=s(theme.colors.textFaint)"
			},
			"text-display": {
				"aliases": "展示大字／text display",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.display); line-height=s(theme.typography.displayLeading); font-weight=s(theme.typography.bold); letter-spacing=s(theme.typography.displayTracking); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h1": {
				"aliases": "一級標題／text h1",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h1); line-height=s(theme.typography.h1Leading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h2": {
				"aliases": "二級標題／text h2",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h2); line-height=s(theme.typography.h2Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h3": {
				"aliases": "三級標題／text h3",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h3); line-height=s(theme.typography.h3Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h4": {
				"aliases": "四級標題／text h4",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h4); line-height=s(theme.typography.h4Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-lead": {
				"aliases": "導言／text lead",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.lead); line-height=s(theme.typography.leadLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-body": {
				"aliases": "正文／內文／text body",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-sub": {
				"aliases": "副正文／text sub",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.subLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-caption": {
				"aliases": "註解小字／text caption",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-caption-strong": {
				"aliases": "強調小字／text captionStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-mono-caption-strong": {
				"aliases": "等寬強調小字／text monoCaptionStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-micro": {
				"aliases": "極小字／text micro",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.micro); line-height=s(theme.typography.microLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-title": {
				"aliases": "頁面標題／text title",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.title); line-height=s(theme.typography.h1Leading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-section": {
				"aliases": "區段標題／text section",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.section); line-height=s(theme.typography.h3Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-editor": {
				"aliases": "編輯文字／text editor",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.bodyFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-terminal": {
				"aliases": "終端文字／text terminal",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-body-strong": {
				"aliases": "強調正文／text bodyStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-app-title": {
				"aliases": "應用名稱／text appTitle",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.labelLeading); font-weight=p(weight500); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-header": {
				"aliases": "Header文字／text header",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-status": {
				"aliases": "狀態列文字／text status",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.codeLeading); font-weight=p(weight500); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-label": {
				"aliases": "控制標籤／text label",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.labelLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-code": {
				"aliases": "程式碼／路徑文字／text code",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.codeLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"button-base": {
				"aliases": "按鈕共用幾何",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); padding-x=s(theme.components.buttonPaddingX); padding-y=p(space0); height=s(theme.components.buttonHeight); width=內容決定; radius=s(theme.components.buttonRadius); border-width=s(theme.components.buttonBorderWidth); border-color=s(theme.colors.border); border-style=solid（width=0 時none）; gap=s(theme.spacing.controlContentGap); typography=s(text-body); shadow=none; transition=s(theme.motion.stateTransition); curve=s(theme.motion.standard)"
			},
			"button-primary": {
				"aliases": "主要按鈕／主操作／button primary",
				"inherit": "button-base",
				"parameters": "background=opaque(s(theme.colors.brand)); foreground=primaryForeground(background); typography=s(text-body-strong)"
			},
			"button-secondary": {
				"aliases": "次要按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); typography=s(text-body)"
			},
			"button-ghost": {
				"aliases": "透明按鈕／幽靈按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.text); typography=s(text-body)"
			},
			"button-danger": {
				"aliases": "危險按鈕／刪除按鈕",
				"inherit": "button-base",
				"parameters": "background=alpha(s(theme.colors.danger),s(theme.surface.statusFillOpacity)); foreground=s(theme.colors.danger); typography=s(text-body)"
			},
			"button-dashed": {
				"aliases": "裝飾虛線按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.text); typography=s(text-body); decoration=dashed; dash-color=s(theme.colors.guide); dash-width=s(theme.shape.hairline); dash-length=s(theme.shape.dashedLength); dash-gap=s(theme.shape.dashedGap); dash-opacity=s(theme.shape.dashedOpacity)"
			},
			"button-size-xs": {
				"aliases": "按鈕 xs",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightXSmall); padding-x=s(theme.spacing.controlInset); padding-y=p(space0); typography=s(text-caption); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-sm": {
				"aliases": "按鈕 sm",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightSmall); padding-x=s(theme.spacing.controlPaddingXSmall); padding-y=p(space0); typography=s(text-caption); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-md": {
				"aliases": "按鈕 md",
				"inherit": "button-base",
				"parameters": "height=s(theme.components.buttonHeight); padding-x=s(theme.components.buttonPaddingX); padding-y=p(space0); typography=s(text-body); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-lg": {
				"aliases": "按鈕 lg",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightLarge); padding-x=s(theme.spacing.controlPaddingXLarge); padding-y=p(space0); typography=s(text-lead); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-xl": {
				"aliases": "按鈕 xl",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightXLarge); padding-x=s(theme.spacing.controlPaddingXXLarge); padding-y=p(space0); typography=s(text-lead); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-hover": {
				"aliases": "按鈕 hover／focus",
				"inherit": "繼承目前 button-*",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),繼承.background); primary特例=以primaryForeground(繼承.background)取代疊色text; foreground=primary時依新背景重新算，其他繼承; geometry=繼承"
			},
			"button-selected": {
				"aliases": "按鈕 selected",
				"inherit": "繼承目前 button-*",
				"parameters": "background=over(alpha(s(theme.colors.interaction),s(theme.surface.focusWashOpacity)),繼承.background); primary特例=以primaryForeground(繼承.background)取代疊色interaction; foreground=primary時依新背景重新算，其他繼承; geometry=繼承"
			},
			"button-disabled": {
				"aliases": "停用按鈕",
				"inherit": "繼承目前 button-*",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=s(theme.colors.textFaint); hover/selected=不套用; geometry=繼承"
			},
			"icon-button": {
				"aliases": "獨立圖示按鈕／icon button",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); width=s(theme.spacing.iconButton); height=s(theme.spacing.iconButton); radius=s(theme.shape.control); padding=無額外padding，圖示置中; icon-size=s(theme.spacing.iconBase); border=none; shadow=none"
			},
			"icon-button-inline": {
				"aliases": "行內圖示按鈕",
				"inherit": "icon-button",
				"parameters": "background=s(theme.colors.transparent)"
			},
			"icon-button-window": {
				"aliases": "視窗控制圖示按鈕",
				"inherit": "icon-button",
				"parameters": "width=s(theme.geometry.layout.windowHeaderControlSize); height=s(theme.geometry.layout.windowHeaderControlSize)"
			},
			"icon-button-hover": {
				"aliases": "圖示按鈕 hover／focus",
				"inherit": "繼承目前 icon-button*",
				"parameters": "background=over(alpha(s(theme.colors.text),byBrightness(s(theme.surface.focusWashOpacity),s(theme.surface.selectionWashOpacity))),s(theme.colors.component)); geometry/foreground=繼承"
			},
			"icon-button-selected": {
				"aliases": "圖示按鈕 selected",
				"inherit": "繼承目前 icon-button*",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text); geometry=繼承"
			},
			"icon-button-disabled": {
				"aliases": "停用圖示按鈕",
				"inherit": "繼承目前 icon-button*",
				"parameters": "foreground=s(theme.colors.textFaint); background=selected時s(theme.colors.interactionSoft)，否則繼承rest; hover=不套用; geometry=繼承"
			},
			"field-base": {
				"aliases": "輸入框／文字輸入欄位／text field",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=s(theme.colors.text); placeholder=s(theme.colors.textFaint); icon-color=s(theme.colors.textMuted); cursor-color=s(theme.colors.interaction); height=s(theme.components.fieldHeight); width=產品決定; padding-x=s(theme.components.fieldPaddingX); padding-y=div(sub(height,mul(font-size,s(theme.geometry.control.textFieldLineHeightFactor))),p(ratio-2)); radius=s(theme.components.fieldRadius); border-width=s(theme.components.fieldBorderWidth); border-color=s(theme.colors.border); border-style=solid（width=0時none）; font-size=s(theme.typography.body); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); line-height=s(theme.typography.captionLeading); shadow=none"
			},
			"field-size-xs": {
				"aliases": "輸入框 xs",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightXSmall); font-size=s(theme.typography.caption); padding-x=s(theme.spacing.tight); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-sm": {
				"aliases": "輸入框 sm",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightSmall); font-size=s(theme.typography.sub); padding-x=s(theme.spacing.tight); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-md": {
				"aliases": "輸入框 md",
				"inherit": "field-base",
				"parameters": "height=s(theme.components.fieldHeight); font-size=s(theme.typography.body); padding-x=s(theme.components.fieldPaddingX); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-lg": {
				"aliases": "輸入框 lg",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightLarge); font-size=s(theme.typography.lead); padding-x=s(theme.spacing.base); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-xl": {
				"aliases": "輸入框 xl",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightXLarge); font-size=s(theme.typography.lead); padding-x=s(theme.spacing.comfortable); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-hover": {
				"aliases": "懸停輸入框",
				"inherit": "field-base",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),s(theme.colors.surfaceInset));  geometry=繼承"
			},
			"field-focused": {
				"aliases": "聚焦／選取輸入框",
				"inherit": "field-base",
				"parameters": "background=over(alpha(s(theme.colors.interaction),s(theme.surface.focusWashOpacity)),s(theme.colors.surfaceInset));  focus-indicator=inset(s(theme.shape.stroke),s(theme.colors.interaction)); outer-outline=none; geometry=繼承（含焦點提示不增加外徑）"
			},
			"field-error": {
				"aliases": "錯誤輸入框",
				"inherit": "field-base",
				"parameters": "background=alpha(s(theme.colors.danger),s(theme.surface.invalidFillOpacity));  geometry=繼承"
			},
			"field-disabled": {
				"aliases": "停用輸入框",
				"inherit": "field-base",
				"parameters": "background=s(theme.colors.surfaceMuted); foreground=s(theme.colors.textFaint); icon-color=s(theme.colors.textFaint); geometry=繼承"
			},
			"field-outlined": {
				"aliases": "有邊框輸入框",
				"inherit": "field-base",
				"parameters": "border-width=max(繼承.border-width,s(theme.shape.stroke)); border-color=focused時s(theme.colors.interaction)，否則s(theme.colors.border); geometry=繼承"
			},
			"field-multiline": {
				"aliases": "多行輸入框／textarea",
				"inherit": "field-base",
				"parameters": "height=內容決定; padding-y=s(theme.spacing.controlPaddingY); min-lines=s(theme.geometry.control.textFieldMinLines); max-lines=s(theme.geometry.control.textFieldMaxLines); alignment=top-left"
			},
			"card": {
				"aliases": "卡片／內容卡片",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=繼承文字角色; radius=s(theme.components.cardRadius); header-padding=s(theme.components.cardPadding); content-padding=s(theme.components.cardPadding); footer-padding=s(theme.spacing.contentInset); title=s(text-body-strong); label=s(text-label); gap=s(theme.spacing.contentInlineGap); border=none; shadow=none; size=產品決定"
			},
			"card-surface": {
				"aliases": "卡片 surface",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surface); shadow=none（raised只改底色）"
			},
			"card-muted": {
				"aliases": "卡片 muted",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surfaceMuted); shadow=none（raised只改底色）"
			},
			"card-raised": {
				"aliases": "卡片 raised",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surfaceRaised); shadow=none（raised只改底色）"
			},
			"card-selected": {
				"aliases": "選取卡片",
				"inherit": "繼承目前 card*",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),繼承.background); geometry=繼承"
			},
			"badge-base": {
				"aliases": "狀態標記共用幾何／badge",
				"inherit": "—",
				"parameters": "padding-x=s(theme.components.badgePaddingX); padding-y=s(theme.spacing.space0_5); radius=s(theme.components.badgeRadius); typography=s(text-caption); size=內容決定; text-transform=uppercase; dot-size=s(theme.spacing.indicatorDot); dot-gap=s(theme.spacing.tight); shadow=none; tone-color=neutral時s(theme.colors.textMuted)，其他取status-*"
			},
			"badge-neutral": {
				"aliases": "中性標記／filled neutral",
				"inherit": "badge-base",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); border-width=p(space0); border-style=none"
			},
			"badge-status": {
				"aliases": "語意色標記／filled status",
				"inherit": "badge-base",
				"parameters": "background=over(alpha(tone-color,s(theme.surface.statusFillOpacity)),opaque(s(theme.colors.component))); foreground=s(theme.colors.text); border=none; shadow=s(effect-frame-relief)"
			},
			"badge-outline": {
				"aliases": "描邊標記",
				"inherit": "badge-base",
				"parameters": "background=none; foreground=tone-color; border-width=s(theme.shape.hairline); border-color=tone-color; border-style=solid"
			},
			"badge-solid": {
				"aliases": "實底標記",
				"inherit": "badge-base",
				"parameters": "background=s(theme.colors.text); foreground=s(theme.colors.stageSurface); border=none"
			},
			"status-success": {
				"aliases": "成功／完成",
				"inherit": "—",
				"parameters": "color=s(theme.colors.success); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-warning": {
				"aliases": "警告",
				"inherit": "—",
				"parameters": "color=s(theme.colors.warning); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-danger": {
				"aliases": "危險／錯誤／破壞性操作",
				"inherit": "—",
				"parameters": "color=s(theme.colors.danger); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-info": {
				"aliases": "資訊",
				"inherit": "—",
				"parameters": "color=s(theme.colors.info); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"frame": {
				"aliases": "內容Frame／app frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); padding=p(space0); radius=s(theme.shape.panel); border=none; shadow=none; size=父布局分配; outer-gap=繼承workspace-layout.frame-gap"
			},
			"frame-sidebar": {
				"aliases": "側欄Frame",
				"inherit": "frame",
				"parameters": "background=s(theme.colors.surfaceInset); width=s(theme.geometry.layout.primaryPaneWidth)"
			},
			"frame-auxiliary": {
				"aliases": "輔助Frame",
				"inherit": "frame",
				"parameters": "background=s(theme.colors.surfaceInset)"
			},
			"frame-right-sidebar": {
				"aliases": "右側欄Frame",
				"inherit": "frame",
				"parameters": "background=繼承父層; radius=不適用; shadow=none; width=s(theme.geometry.layout.secondaryPaneWidth); decoration=none（bare）"
			},
			"frame-toolbar-controls": {
				"aliases": "工具控制區Frame",
				"inherit": "frame",
				"parameters": "background=繼承父層; radius=不適用; shadow=none; width=add(mul(s(theme.spacing.space8),p(ratio-3)),mul(s(theme.spacing.space1),p(ratio-6))); decoration=none（bare）"
			},
			"frame-raised": {
				"aliases": "微立體Frame",
				"inherit": "繼承目前 frame*",
				"parameters": "shadow=s(effect-frame-relief); bare角色=不套用; geometry=繼承"
			},
			"panel-frame": {
				"aliases": "面板框架／panel frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); outer-margin=s(theme.spacing.dockMargin); padding=p(space0); radius=s(theme.shape.card); clip-radius=sub(s(theme.shape.card),s(theme.shape.stroke)); header-height=s(theme.spacing.chromeHeader); footer-height=s(theme.spacing.chromeStatusBar); border=none; shadow=none; size=父布局分配"
			},
			"panel-frame-stage": {
				"aliases": "主內容面板框架",
				"inherit": "panel-frame",
				"parameters": "background=s(theme.colors.stageSurface)"
			},
			"panel-frame-dock": {
				"aliases": "Dock面板標題尺度",
				"inherit": "panel-frame",
				"parameters": "header-height=s(theme.spacing.chromeTab)"
			},
			"panel-frame-raised": {
				"aliases": "微立體面板",
				"inherit": "繼承目前 panel-frame*",
				"parameters": "shadow=s(effect-frame-relief)"
			},
			"stage-frame": {
				"aliases": "舞台容器／stage frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.stageSurface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=不適用; shadow=none; header-min-height=s(theme.spacing.chromeHeader); status-height=s(theme.spacing.chromeStatusBar); size=父布局分配"
			},
			"explorer-row": {
				"aliases": "Explorer資料列／檔案列",
				"inherit": "—",
				"parameters": "background=繼承父層; foreground=s(theme.colors.text); height=add(s(theme.spacing.controlHeightXSmall),s(theme.geometry.control.fileExplorerRowHeightAdjustment)); row-padding-end=s(theme.spacing.tight); icon-size=s(theme.spacing.iconSmall); icon-color=s(theme.colors.textMuted); icon-gap=s(theme.spacing.contentInlineGap); typography=s(text-code); leading-width=add(s(theme.spacing.iconSmall),s(theme.geometry.layout.treeLeadingGap)); indent=mul(level,s(theme.spacing.tight)); outer-padding-x=s(theme.spacing.navigationItemInset); outer-padding-y=s(theme.spacing.hairline); border=none; shadow=none; width=父布局分配"
			},
			"explorer-folder-row": {
				"aliases": "Explorer資料夾列",
				"inherit": "explorer-row",
				"parameters": "height=s(theme.spacing.controlHeightXSmall); disclosure=產品選用圖示"
			},
			"explorer-row-hover": {
				"aliases": "Explorer懸停資料列",
				"inherit": "explorer-row",
				"parameters": "overlay=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)); overlay-radius=s(theme.shape.control); geometry=繼承"
			},
			"explorer-row-selected": {
				"aliases": "Explorer選取資料列",
				"inherit": "explorer-row-hover",
				"parameters": "icon-color=s(theme.colors.text); overlay=繼承（hover／selected同色）；不新增虛線框"
			},
			"explorer-spacing-relaxed": {
				"aliases": "較寬樹狀節奏",
				"inherit": "explorer-row",
				"parameters": "indent=mul(level,s(theme.spacing.base))"
			},
			"explorer-spacing-flush": {
				"aliases": "貼齊Explorer／flush",
				"inherit": "explorer-row",
				"parameters": "outer-padding-x=p(space0); outer-padding-y=p(space0); section-margin-x=s(theme.spacing.hairline)"
			},
			"action-region": {
				"aliases": "可操作資料區域",
				"inherit": "—",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.textMuted); radius=s(theme.shape.card); padding/size=繼承所屬元件; border=none; shadow=none"
			},
			"action-region-hover": {
				"aliases": "可操作資料區域hover／focus",
				"inherit": "action-region",
				"parameters": "background=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity))"
			},
			"action-region-selected": {
				"aliases": "可操作資料區域selected",
				"inherit": "action-region",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text)"
			},
			"action-region-destructive": {
				"aliases": "破壞性可操作區域",
				"inherit": "action-region",
				"parameters": "foreground=s(theme.colors.danger); active-background=s(theme.colors.danger); active-foreground=s(theme.colors.onStatus)"
			},
			"menu": {
				"aliases": "彈出選單／menu panel",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=backgroundForeground(background); padding=s(theme.spacing.tight); radius=s(theme.components.menuRadius); width-base=s(theme.geometry.layout.menuWidth); width=依項目量測／scrollable選項，基準width-base; border-width=s(theme.shape.hairline); border-style=dashed; border-color=s(theme.colors.divider); shadow=s(effect-menu-shadow)"
			},
			"menu-item": {
				"aliases": "選單項目",
				"inherit": "action-region",
				"parameters": "radius=s(theme.shape.control); height=s(theme.components.menuItemHeight); padding-x=s(theme.components.menuPadding); padding-y=p(space0); typography=s(text-label); icon-size=s(theme.spacing.iconSmall); gap=s(theme.spacing.overlayItemGap); icon-optical-y=s(theme.geometry.optical.menuIconOffsetY)"
			},
			"menu-item-description": {
				"aliases": "附說明選單項目",
				"inherit": "menu-item",
				"parameters": "height=mul(s(theme.components.menuItemHeight),p(ratio-2)); description=s(text-caption); description-color=s(theme.colors.textMuted)"
			},
			"menu-item-selected": {
				"aliases": "選取選單項目",
				"inherit": "menu-item",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text)"
			},
			"menu-item-hover": {
				"aliases": "選單hover／keyboard focus",
				"inherit": "menu-item",
				"parameters": "background=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity))"
			},
			"menu-item-danger": {
				"aliases": "危險選單項目",
				"inherit": "menu-item",
				"parameters": "foreground=s(theme.colors.danger); active-background=s(theme.colors.danger); active-foreground=s(theme.colors.onStatus)"
			},
			"dialog": {
				"aliases": "對話框",
				"inherit": "surface-base",
				"parameters": "radius=s(theme.shape.panel); max-width=s(theme.geometry.layout.dialogMaximumWidth); heading-padding=s(theme.spacing.loose); content-padding=s(theme.spacing.loose); actions-padding=s(theme.spacing.base); heading-gap=s(theme.spacing.overlayHeadingGap); action-gap=s(theme.spacing.actionGap); title=s(text-title); label=s(text-label); primary-action=s(button-primary); secondary-action=s(button-ghost); border-width=s(theme.shape.hairline); border-style=dashed; border-color=s(theme.colors.divider); shadow=微立體; positioning/scrim=產品彈出宿主決定"
			},
			"scrollbar": {
				"aliases": "捲軸",
				"inherit": "—",
				"parameters": "thumb-color=s(theme.colors.textFaint); track-color=s(theme.colors.transparent); track-border-color=s(theme.colors.transparent); thickness=s(theme.geometry.control.scrollbarThickness); radius=s(theme.shape.pill); track-visible=false; length/padding=宿主決定"
			},
			"tooltip": {
				"aliases": "工具提示",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=s(theme.colors.textMuted); radius=s(theme.shape.control); padding-x=s(theme.spacing.overlayContentInset); padding-y=s(theme.spacing.tight); font-family=s(theme.typography.uiFamily); font-size=s(theme.typography.caption); border=none; delay=s(theme.motion.tooltipDelay); dwell=s(theme.motion.tooltipDwell); prefer-below=false; size=內容決定"
			},
			"effect-paper-shadow": {
				"aliases": "紙片雙層陰影／overlayShadow",
				"inherit": "—",
				"parameters": "contact=color alpha(s(theme.surface.overlayShadowColor),s(theme.surface.contactShadowOpacity)), offset(p(space0),s(theme.surface.contactOffsetY)), blur=s(theme.surface.contactBlur), spread=p(space0); ambient=color alpha(s(theme.surface.overlayShadowColor),s(theme.surface.overlayShadowOpacity)), offset(p(space0),s(theme.surface.overlayOffsetY)), blur=s(theme.surface.overlayBlur), spread=s(theme.surface.overlaySpread); enabled=theme.surface.separation=shadow，其餘none"
			},
			"effect-menu-shadow": {
				"aliases": "選單專用單層陰影",
				"inherit": "—",
				"parameters": "color=alpha(s(theme.colors.modalScrim),s(theme.surface.overlayShadowOpacity)); offset=(p(space0),s(theme.surface.overlayOffsetY)); blur=s(theme.surface.overlayBlur); spread=s(theme.surface.overlaySpread); 不增加接觸層"
			},
			"effect-frame-relief": {
				"aliases": "Frame微立體陰影與亮邊",
				"inherit": "—",
				"parameters": "scale=div(s(theme.spacing.space1),p(space100)); dark=surface.R/G/B全部小於100; shadow-rgb=s(theme.surface.overlayShadowColor); shadow-alpha=dark?p(opacity-0_47843137254901963):p(opacity-0_1803921568627451); shadow-offset=(mul(p(space50),scale),mul(p(length-3),scale)); blur=mul(p(length-5),scale); spread=mul(p(length-minus-1),scale); highlight-rgb=p(ink50); highlight-alpha=dark?p(opacity-0_07058823529411765):p(opacity-0_8509803921568627); highlight-offset=(mul(p(length-minus-1),scale),mul(p(length-minus-1),scale)); highlight-blur=p(space0); 陰影在裁切之外"
			},
			"motion-reduced": {
				"aliases": "減少動態效果",
				"inherit": "—",
				"parameters": "state-transition=p(duration0); overlay-enter=p(duration0); overlay-exit=p(duration0); 其他=繼承theme.motion"
			}
		},
		"primitiveDescriptions": {
			"parchment50": "現有公開primitive",
			"parchment75": "現有公開primitive",
			"parchment100": "現有公開primitive",
			"parchment150": "現有公開primitive",
			"parchment200": "現有公開primitive",
			"parchment250": "現有公開primitive",
			"parchment350": "現有公開primitive",
			"parchment550": "現有公開primitive",
			"parchment700": "現有公開primitive",
			"parchment750": "現有公開primitive",
			"parchment800": "現有公開primitive",
			"parchment825": "現有公開primitive",
			"parchment900": "現有公開primitive",
			"parchment925": "現有公開primitive",
			"parchment950": "現有公開primitive",
			"ink1000": "現有公開primitive",
			"transparent": "現有公開primitive",
			"ink50": "現有公開primitive",
			"ink100": "現有公開primitive",
			"ink150": "現有公開primitive",
			"ink200": "現有公開primitive",
			"ink250": "現有公開primitive",
			"ink300": "現有公開primitive",
			"ink350": "現有公開primitive",
			"ink400": "現有公開primitive",
			"ink450": "現有公開primitive",
			"ink500": "現有公開primitive",
			"ink550": "現有公開primitive",
			"ink600": "現有公開primitive",
			"ink650": "現有公開primitive",
			"ink700": "現有公開primitive",
			"ink750": "現有公開primitive",
			"ink800": "現有公開primitive",
			"ink850": "現有公開primitive",
			"ink900": "現有公開primitive",
			"ink950": "現有公開primitive",
			"warmNeutral25": "現有公開primitive",
			"warmNeutral50": "現有公開primitive",
			"warmNeutral100": "現有公開primitive",
			"warmNeutral200": "現有公開primitive",
			"warmNeutral300": "現有公開primitive",
			"warmNeutral400": "現有公開primitive",
			"warmNeutral450": "現有公開primitive",
			"warmNeutral500": "現有公開primitive",
			"warmNeutral600": "現有公開primitive",
			"warmNeutral700": "現有公開primitive",
			"warmNeutral750": "現有公開primitive",
			"warmNeutral800": "現有公開primitive",
			"warmNeutral900": "現有公開primitive",
			"sand50": "現有公開primitive",
			"sand300": "現有公開primitive",
			"sand500": "現有公開primitive",
			"sand800": "現有公開primitive",
			"sand900": "現有公開primitive",
			"gold50": "現有公開primitive",
			"gold300": "現有公開primitive",
			"gold500": "現有公開primitive",
			"gold800": "現有公開primitive",
			"gold900": "現有公開primitive",
			"ochre50": "現有公開primitive",
			"ochre300": "現有公開primitive",
			"ochre500": "現有公開primitive",
			"ochre800": "現有公開primitive",
			"ochre900": "現有公開primitive",
			"terracotta50": "現有公開primitive",
			"terracotta300": "現有公開primitive",
			"terracotta500": "現有公開primitive",
			"terracotta800": "現有公開primitive",
			"terracotta900": "現有公開primitive",
			"clay50": "現有公開primitive",
			"clay300": "現有公開primitive",
			"clay500": "現有公開primitive",
			"clay800": "現有公開primitive",
			"clay900": "現有公開primitive",
			"umber50": "現有公開primitive",
			"umber300": "現有公開primitive",
			"umber500": "現有公開primitive",
			"umber800": "現有公開primitive",
			"umber900": "現有公開primitive",
			"green100": "現有公開primitive",
			"green400": "現有公開primitive",
			"green500": "現有公開primitive",
			"green600": "現有公開primitive",
			"green800": "現有公開primitive",
			"green900": "現有公開primitive",
			"red100": "現有公開primitive",
			"red300": "現有公開primitive",
			"red400": "現有公開primitive",
			"red600": "現有公開primitive",
			"red800": "現有公開primitive",
			"red900": "現有公開primitive",
			"amber500": "現有公開primitive",
			"blue500": "現有公開primitive",
			"scrim": "現有公開primitive",
			"line": "現有公開primitive",
			"transparentSurface": "現有公開primitive",
			"transparentSurfaceInset": "現有公開primitive",
			"pureWhite": "現有公開primitive",
			"pureBlack": "現有公開primitive",
			"accent-ink-light": "現有accent配對原料",
			"accent-ink-dark": "現有accent配對原料",
			"accent-terracotta-light": "現有accent配對原料",
			"accent-terracotta-dark": "現有accent配對原料",
			"accent-ochre-light": "現有accent配對原料",
			"accent-ochre-dark": "現有accent配對原料",
			"accent-olive-light": "現有accent配對原料",
			"accent-olive-dark": "現有accent配對原料",
			"accent-slate-light": "現有accent配對原料",
			"accent-slate-dark": "現有accent配對原料",
			"accent-crimson-light": "現有accent配對原料",
			"accent-crimson-dark": "現有accent配對原料",
			"color-b8292724": "原實作值的文件名稱；未新增設計",
			"color-b835322d": "原實作值的文件名稱；未新增設計",
			"space0": "現有公開primitive",
			"space50": "現有公開primitive",
			"space100": "現有公開primitive",
			"space200": "現有公開primitive",
			"space250": "現有公開primitive",
			"space300": "現有公開primitive",
			"space400": "現有公開primitive",
			"space600": "現有公開primitive",
			"space800": "現有公開primitive",
			"space1000": "現有公開primitive",
			"space1200": "現有公開primitive",
			"space1600": "現有公開primitive",
			"space2400": "現有公開primitive",
			"radius0": "現有公開primitive",
			"radius50": "現有公開primitive",
			"radius100": "現有公開primitive",
			"radius150": "現有公開primitive",
			"radius200": "現有公開primitive",
			"radius250": "現有公開primitive",
			"radius300": "現有公開primitive",
			"radius400": "現有公開primitive",
			"radiusFull": "現有公開primitive",
			"stroke0": "現有公開primitive",
			"stroke100": "現有公開primitive",
			"stroke200": "現有公開primitive",
			"font100": "現有公開primitive",
			"font200": "現有公開primitive",
			"font300": "現有公開primitive",
			"font400": "現有公開primitive",
			"font500": "現有公開primitive",
			"font600": "現有公開primitive",
			"font700": "現有公開primitive",
			"font800": "現有公開primitive",
			"font900": "現有公開primitive",
			"font1000": "現有公開primitive",
			"tracking0": "現有公開primitive",
			"trackingTight": "現有公開primitive",
			"trackingWide": "現有公開primitive",
			"trackingWider": "現有公開primitive",
			"length-30": "原實作值的文件名稱；未新增設計",
			"length-56": "原實作值的文件名稱；未新增設計",
			"length-20": "原實作值的文件名稱；未新增設計",
			"length-60": "原實作值的文件名稱；未新增設計",
			"length-74": "原實作值的文件名稱；未新增設計",
			"length-170": "原實作值的文件名稱；未新增設計",
			"length-11": "原實作值的文件名稱；未新增設計",
			"length-3": "原實作值的文件名稱；未新增設計",
			"length-5": "原實作值的文件名稱；未新增設計",
			"length-7": "原實作值的文件名稱；未新增設計",
			"length-3_5": "原實作值的文件名稱；未新增設計",
			"length-41_4": "原實作值的文件名稱；未新增設計",
			"length-168": "原實作值的文件名稱；未新增設計",
			"length-26": "原實作值的文件名稱；未新增設計",
			"length-520": "原實作值的文件名稱；未新增設計",
			"length-320": "原實作值的文件名稱；未新增設計",
			"length-120": "原實作值的文件名稱；未新增設計",
			"length-9": "原實作值的文件名稱；未新增設計",
			"length-220": "原實作值的文件名稱；未新增設計",
			"length-192": "原實作值的文件名稱；未新增設計",
			"length-128": "原實作值的文件名稱；未新增設計",
			"length-112": "原實作值的文件名稱；未新增設計",
			"length-10_5": "原實作值的文件名稱；未新增設計",
			"length-336": "原實作值的文件名稱；未新增設計",
			"length-300": "原實作值的文件名稱；未新增設計",
			"length-350": "原實作值的文件名稱；未新增設計",
			"length-400": "原實作值的文件名稱；未新增設計",
			"length-800": "原實作值的文件名稱；未新增設計",
			"length-960": "原實作值的文件名稱；未新增設計",
			"length-1120": "原實作值的文件名稱；未新增設計",
			"length-200": "原實作值的文件名稱；未新增設計",
			"length-360": "原實作值的文件名稱；未新增設計",
			"length-480": "原實作值的文件名稱；未新增設計",
			"length-1380": "原實作值的文件名稱；未新增設計",
			"length-880": "原實作值的文件名稱；未新增設計",
			"length-260": "原實作值的文件名稱；未新增設計",
			"length-820": "原實作值的文件名稱；未新增設計",
			"length-minus-1": "原實作值的文件名稱；未新增設計",
			"leading100": "現有公開primitive",
			"leading116": "現有公開primitive",
			"leading120": "現有公開primitive",
			"leading122": "現有公開primitive",
			"leading127": "現有公開primitive",
			"leading128": "現有公開primitive",
			"leading133": "現有公開primitive",
			"leading142": "現有公開primitive",
			"leading150": "現有公開primitive",
			"leading155": "現有公開primitive",
			"leading150Legacy": "現有公開primitive",
			"leading200": "現有公開primitive",
			"leading300": "現有公開primitive",
			"leading350": "現有公開primitive",
			"leading400": "現有公開primitive",
			"leading450": "現有公開primitive",
			"leading500": "現有公開primitive",
			"leading550": "現有公開primitive",
			"leading650": "現有公開primitive",
			"ratio-0_4": "原實作值的文件名稱；未新增設計",
			"ratio-0_35": "原實作值的文件名稱；未新增設計",
			"ratio-0_32": "原實作值的文件名稱；未新增設計",
			"ratio-0_22": "原實作值的文件名稱；未新增設計",
			"ratio-0_06": "原實作值的文件名稱；未新增設計",
			"ratio-8": "原實作值的文件名稱；未新增設計",
			"ratio-2": "原實作值的文件名稱；未新增設計",
			"ratio-3": "原實作值的文件名稱；未新增設計",
			"ratio-6": "原實作值的文件名稱；未新增設計",
			"weight400": "現有公開primitive",
			"weight500": "現有公開primitive",
			"weight600": "現有公開primitive",
			"weight700": "現有公開primitive",
			"weight800": "現有公開primitive",
			"duration0": "現有公開primitive",
			"duration100": "現有公開primitive",
			"duration150": "現有公開primitive",
			"duration400": "現有公開primitive",
			"duration500": "現有公開primitive",
			"duration-4000": "原實作值的文件名稱；未新增設計",
			"duration-1000": "原實作值的文件名稱；未新增設計",
			"easeStandard": "現有公開primitive",
			"easeEmphasized": "現有公開primitive",
			"opacity100": "現有公開primitive",
			"opacity120": "現有公開primitive",
			"opacity140": "現有公開primitive",
			"opacity160": "現有公開primitive",
			"opacity180": "現有公開primitive",
			"opacity220": "現有公開primitive",
			"opacity280": "現有公開primitive",
			"opacity320": "現有公開primitive",
			"opacity350": "現有公開primitive",
			"opacity440": "現有公開primitive",
			"opacity480": "現有公開primitive",
			"opacity550": "現有公開primitive",
			"opacity620": "現有公開primitive",
			"opacity720": "現有公開primitive",
			"opacity780": "現有公開primitive",
			"opacity820": "現有公開primitive",
			"opacity-0_13333333333333333": "原實作值的文件名稱；未新增設計",
			"opacity-0_6": "原實作值的文件名稱；未新增設計",
			"opacity-0_88": "原實作值的文件名稱；未新增設計",
			"opacity-0_47843137254901963": "原實作值的文件名稱；未新增設計",
			"opacity-0_1803921568627451": "原實作值的文件名稱；未新增設計",
			"opacity-0_07058823529411765": "原實作值的文件名稱；未新增設計",
			"opacity-0_8509803921568627": "原實作值的文件名稱；未新增設計",
			"family-packages-kallopis-noto-sans-tc": "原實作值的文件名稱；未新增設計",
			"family-noto-sans-tc": "原實作值的文件名稱；未新增設計",
			"family-microsoft-jhenghei-ui": "原實作值的文件名稱；未新增設計",
			"family-microsoft-jhenghei": "原實作值的文件名稱；未新增設計",
			"family-pingfang-tc": "原實作值的文件名稱；未新增設計",
			"family-sans-serif": "原實作值的文件名稱；未新增設計",
			"family-packages-kallopis-ibm-plex-mono": "原實作值的文件名稱；未新增設計",
			"family-ibm-plex-mono": "原實作值的文件名稱；未新增設計",
			"family-consolas": "原實作值的文件名稱；未新增設計",
			"family-courier-new": "原實作值的文件名稱；未新增設計",
			"family-monospace": "原實作值的文件名稱；未新增設計",
			"string-shadow": "原實作值的文件名稱；未新增設計",
			"count-4": "原實作值的文件名稱；未新增設計",
			"count-8": "原實作值的文件名稱；未新增設計",
			"length-15": "checkbox 13px 增加 2px 的明確尺寸",
			"meDarkApp": "微立體深色最外層工作台底色",
			"meDarkSurface": "微立體深色側欄與浮動面板底色",
			"meDarkInset": "微立體深色凹陷程式碼與編輯區塊底色",
			"meDarkMuted": "微立體深色次要區域底色",
			"meDarkComponent": "微立體深色控制項與分頁膠囊底色",
			"meDarkStage": "微立體深色主文件卡片底色",
			"meDarkRaised": "微立體深色浮起卡片底色",
			"meDarkBorder": "微立體深色微立體邊框",
			"meDarkBorderStrong": "微立體深色強調邊框",
			"meDarkText": "微立體深色主文字",
			"meDarkMutedText": "微立體深色次要文字",
			"meDarkFaintText": "微立體深色行號與弱化文字",
			"meDarkAmber": "微立體深色琥珀金強調色",
			"meDarkAmberSoft": "微立體深色琥珀金柔化底色",
			"meDarkHover": "微立體深色互動懸停底色",
			"meLightApp": "微立體淺色最外層工作台底色",
			"meLightSurface": "微立體淺色側欄與浮動面板底色",
			"meLightInset": "微立體淺色凹陷區塊底色",
			"meLightMuted": "微立體淺色次要區域底色",
			"meLightComponent": "微立體淺色控制項與分頁膠囊底色",
			"meLightStage": "微立體淺色主文件卡片底色",
			"meLightRaised": "微立體淺色浮起卡片底色",
			"meLightBorder": "微立體淺色邊框",
			"meLightBorderStrong": "微立體淺色強調邊框",
			"meLightText": "微立體淺色主文字",
			"meLightMutedText": "微立體淺色次要文字",
			"meLightFaintText": "微立體淺色行號與弱化文字",
			"meLightAmber": "微立體淺色琥珀金強調色",
			"meLightAmberSoft": "微立體淺色琥珀金柔化底色",
			"meLightHover": "微立體淺色互動懸停底色",
			"meTransSurface": "微立體透明模式側欄半透明底色",
			"meTransStage": "微立體透明模式主舞台半透明底色",
			"meRadiusPanel": "微立體浮動面板圓角"
		},
		"semanticDescriptions": {
			"theme.colors.app": "<br>app background／應用背景色",
			"theme.colors.surface": "<br>base surface／輔助表面色",
			"theme.colors.surfaceInset": "<br>inset surface／內嵌表面色",
			"theme.colors.surfaceMuted": "<br>muted surface／弱化表面色",
			"theme.colors.component": "<br>control surface／控制表面色",
			"theme.colors.stageSurface": "<br>stage background／主內容表面色",
			"theme.colors.overlay": "<br>overlay background／浮層色",
			"theme.colors.surfaceRaised": "<br>raised surface／較亮表面",
			"theme.colors.modalScrim": "<br>遮罩色",
			"theme.colors.guide": "<br>colors / guide",
			"theme.colors.divider": "<br>分隔線色",
			"theme.colors.pagePattern": "<br>colors / page Pattern",
			"theme.colors.text": "<br>primary text／主文字",
			"theme.colors.textMuted": "<br>muted text／次要文字",
			"theme.colors.textFaint": "<br>faint text／弱化文字",
			"theme.colors.border": "<br>邊框色",
			"theme.colors.borderStrong": "<br>colors / border Strong",
			"theme.colors.brand": "<br>brand／品牌色／主動作底色",
			"theme.colors.accent": "<br>colors / accent",
			"theme.colors.accentSoft": "<br>colors / accent Soft",
			"theme.colors.interaction": "<br>interaction／操作色",
			"theme.colors.interactionSoft": "<br>selection background／柔和操作色",
			"theme.colors.success": "<br>colors / success",
			"theme.colors.warning": "<br>colors / warning",
			"theme.colors.danger": "<br>colors / danger",
			"theme.colors.info": "<br>colors / info",
			"theme.colors.onStatus": "<br>colors / on Status",
			"theme.colors.onLightBackground": "<br>colors / on Light Background",
			"theme.colors.onDarkBackground": "<br>colors / on Dark Background",
			"theme.colors.mutedOnLightBackground": "<br>colors / muted On Light Background",
			"theme.colors.mutedOnDarkBackground": "<br>colors / muted On Dark Background",
			"theme.colors.faintOnBackground": "<br>colors / faint On Background",
			"theme.colors.transparent": "<br>透明",
			"theme.typography.sansFamily": "<br>typography / sans Family",
			"theme.typography.sansFallback": "<br>typography / sans Fallback",
			"theme.typography.monoFamily": "<br>typography / mono Family",
			"theme.typography.monoFallback": "<br>typography / mono Fallback",
			"theme.typography.uiFamily": "<br>typography / ui Family",
			"theme.typography.bodyFamily": "<br>typography / body Family",
			"theme.typography.codeFamily": "<br>typography / code Family",
			"theme.typography.micro": "<br>typography / micro",
			"theme.typography.caption": "<br>typography / caption",
			"theme.typography.sub": "<br>typography / sub",
			"theme.typography.body": "<br>typography / body",
			"theme.typography.lead": "<br>typography / lead",
			"theme.typography.h4": "<br>typography / h4",
			"theme.typography.h3": "<br>typography / h3",
			"theme.typography.h2": "<br>typography / h2",
			"theme.typography.h1": "<br>typography / h1",
			"theme.typography.display": "<br>typography / display",
			"theme.typography.label": "<br>typography / label",
			"theme.typography.section": "<br>typography / section",
			"theme.typography.headingSmall": "<br>typography / heading Small",
			"theme.typography.heading": "<br>typography / heading",
			"theme.typography.title": "<br>typography / title",
			"theme.typography.microLeading": "<br>typography / micro Leading",
			"theme.typography.captionLeading": "<br>typography / caption Leading",
			"theme.typography.subLeading": "<br>typography / sub Leading",
			"theme.typography.bodyLeading": "<br>typography / body Leading",
			"theme.typography.leadLeading": "<br>typography / lead Leading",
			"theme.typography.h4Leading": "<br>typography / h4Leading",
			"theme.typography.h3Leading": "<br>typography / h3Leading",
			"theme.typography.h2Leading": "<br>typography / h2Leading",
			"theme.typography.h1Leading": "<br>typography / h1Leading",
			"theme.typography.displayLeading": "<br>typography / display Leading",
			"theme.typography.headingLeading": "<br>typography / heading Leading",
			"theme.typography.codeLeading": "<br>typography / code Leading",
			"theme.typography.readingLeading": "<br>typography / reading Leading",
			"theme.typography.labelLeading": "<br>typography / label Leading",
			"theme.typography.labelTracking": "<br>typography / label Tracking",
			"theme.typography.displayTracking": "<br>typography / display Tracking",
			"theme.typography.regular": "<br>typography / regular",
			"theme.typography.medium": "<br>typography / medium",
			"theme.typography.semiBold": "<br>typography / semi Bold",
			"theme.typography.bold": "<br>typography / bold",
			"theme.typography.extraBold": "<br>typography / extra Bold",
			"theme.typography.strong": "<br>typography / strong",
			"theme.spacing.space0_5": "<br>spacing / space0_5",
			"theme.spacing.space1": "<br>spacing / space1",
			"theme.spacing.space2": "<br>spacing / space2",
			"theme.spacing.space3": "<br>spacing / space3",
			"theme.spacing.space4": "<br>spacing / space4",
			"theme.spacing.space6": "<br>spacing / space6",
			"theme.spacing.space8": "<br>spacing / space8",
			"theme.spacing.space12": "<br>spacing / space12",
			"theme.spacing.space16": "<br>spacing / space16",
			"theme.spacing.space24": "<br>spacing / space24",
			"theme.spacing.hairline": "<br>spacing / hairline",
			"theme.spacing.tight": "<br>spacing / tight",
			"theme.spacing.contentInlineGap": "<br>spacing / content Inline Gap",
			"theme.spacing.contentStackGap": "<br>spacing / content Stack Gap",
			"theme.spacing.contentInset": "<br>spacing / content Inset",
			"theme.spacing.controlContentGap": "<br>spacing / control Content Gap",
			"theme.spacing.controlInset": "<br>spacing / control Inset",
			"theme.spacing.actionGap": "<br>spacing / action Gap",
			"theme.spacing.chromeGap": "<br>spacing / chrome Gap",
			"theme.spacing.chromePanelInset": "<br>spacing / chrome Panel Inset",
			"theme.spacing.chromeToolbarGap": "<br>spacing / chrome Toolbar Gap",
			"theme.spacing.navigationItemInset": "<br>spacing / navigation Item Inset",
			"theme.spacing.navigationRailInset": "<br>spacing / navigation Rail Inset",
			"theme.spacing.navigationRailItemGap": "<br>spacing / navigation Rail Item Gap",
			"theme.spacing.overlayContentInset": "<br>spacing / overlay Content Inset",
			"theme.spacing.overlayHeadingGap": "<br>spacing / overlay Heading Gap",
			"theme.spacing.overlayItemGap": "<br>spacing / overlay Item Gap",
			"theme.spacing.navigationSectionGap": "<br>spacing / navigation Section Gap",
			"theme.spacing.appFrameInset": "<br>spacing / app Frame Inset",
			"theme.spacing.windowHeaderMargin": "<br>spacing / window Header Margin",
			"theme.spacing.dockMargin": "<br>spacing / dock Margin",
			"theme.spacing.base": "<br>spacing / base",
			"theme.spacing.comfortable": "<br>spacing / comfortable",
			"theme.spacing.loose": "<br>spacing / loose",
			"theme.spacing.section": "<br>spacing / section",
			"theme.spacing.sectionLarge": "<br>spacing / section Large",
			"theme.spacing.page": "<br>spacing / page",
			"theme.spacing.pageLarge": "<br>spacing / page Large",
			"theme.spacing.controlPaddingXSmall": "<br>spacing / control Padding XSmall",
			"theme.spacing.controlPaddingX": "<br>spacing / control Padding X",
			"theme.spacing.controlPaddingXLarge": "<br>spacing / control Padding XLarge",
			"theme.spacing.controlPaddingXXLarge": "<br>spacing / control Padding XXLarge",
			"theme.spacing.controlPaddingY": "<br>spacing / control Padding Y",
			"theme.spacing.containerPadding": "<br>spacing / container Padding",
			"theme.spacing.itemGap": "<br>spacing / item Gap",
			"theme.spacing.groupGap": "<br>spacing / group Gap",
			"theme.spacing.controlHeightXSmall": "<br>spacing / control Height XSmall",
			"theme.spacing.controlHeightSmall": "<br>spacing / control Height Small",
			"theme.spacing.controlHeight": "<br>spacing / control Height",
			"theme.spacing.controlHeightLarge": "<br>spacing / control Height Large",
			"theme.spacing.controlHeightXLarge": "<br>spacing / control Height XLarge",
			"theme.spacing.iconSmall": "<br>spacing / icon Small",
			"theme.spacing.iconBase": "<br>spacing / icon Base",
			"theme.spacing.iconGlyph": "<br>spacing / icon Glyph",
			"theme.spacing.icon": "<br>spacing / icon",
			"theme.spacing.iconMedium": "<br>spacing / icon Medium",
			"theme.spacing.iconLarge": "<br>spacing / icon Large",
			"theme.spacing.chromeHeader": "<br>spacing / chrome Header",
			"theme.spacing.chromeStatusBar": "<br>spacing / chrome Status Bar",
			"theme.spacing.chromeRail": "<br>spacing / chrome Rail",
			"theme.spacing.chromeTab": "<br>spacing / chrome Tab",
			"theme.spacing.iconButton": "<br>spacing / icon Button",
			"theme.spacing.iconTiny": "<br>spacing / icon Tiny",
			"theme.spacing.indicatorDot": "<br>spacing / indicator Dot",
			"theme.spacing.indicatorDotLarge": "<br>spacing / indicator Dot Large",
			"theme.spacing.noticeIconSlot": "<br>spacing / notice Icon Slot",
			"theme.spacing.toastIconSlot": "<br>spacing / toast Icon Slot",
			"theme.spacing.gutterNumber": "<br>spacing / gutter Number",
			"theme.spacing.gutterMarker": "<br>spacing / gutter Marker",
			"theme.spacing.micro": "<br>spacing / micro",
			"theme.spacing.calendarContentCell": "<br>spacing / calendar Content Cell",
			"theme.spacing.gridTileWidth": "<br>spacing / grid Tile Width",
			"theme.spacing.iconMicro": "<br>spacing / icon Micro",
			"theme.spacing.avatarSmall": "<br>spacing / avatar Small",
			"theme.spacing.progressTrack": "<br>spacing / progress Track",
			"theme.spacing.skeletonLine": "<br>spacing / skeleton Line",
			"theme.spacing.railItem": "<br>spacing / rail Item",
			"theme.shape.none": "<br>shape / none",
			"theme.shape.sm": "<br>shape / sm",
			"theme.shape.control": "<br>shape / control",
			"theme.shape.controlInner": "<br>shape / control Inner",
			"theme.shape.toggleTrack": "<br>shape / toggle Track",
			"theme.shape.card": "<br>shape / card",
			"theme.shape.panel": "<br>shape / panel",
			"theme.shape.pill": "<br>shape / pill",
			"theme.shape.hairline": "<br>shape / hairline",
			"theme.shape.stroke": "<br>shape / stroke",
			"theme.shape.dashedLength": "<br>shape / dashed Length",
			"theme.shape.dashedGap": "<br>shape / dashed Gap",
			"theme.shape.dashedOpacity": "<br>shape / dashed Opacity",
			"theme.motion.themeTransition": "<br>motion / theme Transition",
			"theme.motion.styleTransition": "<br>motion / style Transition",
			"theme.motion.stateTransition": "<br>motion / state Transition",
			"theme.motion.overlayEnter": "<br>motion / overlay Enter",
			"theme.motion.overlayExit": "<br>motion / overlay Exit",
			"theme.motion.toastDwell": "<br>motion / toast Dwell",
			"theme.motion.tooltipDelay": "<br>motion / tooltip Delay",
			"theme.motion.tooltipDwell": "<br>motion / tooltip Dwell",
			"theme.motion.spinnerCycle": "<br>motion / spinner Cycle",
			"theme.motion.longPressThreshold": "<br>motion / long Press Threshold",
			"theme.motion.standard": "<br>motion / standard",
			"theme.motion.emphasized": "<br>motion / emphasized",
			"theme.surface.separation": "<br>surface / separation",
			"theme.surface.overlayBlur": "<br>surface / overlay Blur",
			"theme.surface.overlaySpread": "<br>surface / overlay Spread",
			"theme.surface.overlayOffsetY": "<br>surface / overlay Offset Y",
			"theme.surface.overlayShadowOpacity": "<br>surface / overlay Shadow Opacity",
			"theme.surface.scrimOpacity": "<br>surface / scrim Opacity",
			"theme.surface.selectionWashOpacity": "<br>surface / selection Wash Opacity",
			"theme.surface.focusWashOpacity": "<br>surface / focus Wash Opacity",
			"theme.surface.statusFillOpacity": "<br>surface / status Fill Opacity",
			"theme.surface.pressProgressOpacity": "<br>surface / press Progress Opacity",
			"theme.surface.diffFillOpacity": "<br>surface / diff Fill Opacity",
			"theme.surface.gridLineOpacity": "<br>surface / grid Line Opacity",
			"theme.surface.veilOpacity": "<br>surface / veil Opacity",
			"theme.surface.statusRowOpacity": "<br>surface / status Row Opacity",
			"theme.surface.statusRowSelectedOpacity": "<br>surface / status Row Selected Opacity",
			"theme.surface.statusRowOpacityDark": "<br>surface / status Row Opacity Dark",
			"theme.surface.statusRowSelectedOpacityDark": "<br>surface / status Row Selected Opacity Dark",
			"theme.surface.frostedOpacity": "<br>surface / frosted Opacity",
			"theme.surface.frostedVeilOpacity": "<br>surface / frosted Veil Opacity",
			"theme.surface.backdropBlurSigma": "<br>surface / backdrop Blur Sigma",
			"theme.surface.dragOpacity": "<br>surface / drag Opacity",
			"theme.surface.dragSourceOpacity": "<br>surface / drag Source Opacity",
			"theme.surface.themePreviewDisabledOpacity": "<br>surface / theme Preview Disabled Opacity",
			"theme.surface.listStatusOpacity": "<br>surface / list Status Opacity",
			"theme.surface.listStatusSelectedOpacity": "<br>surface / list Status Selected Opacity",
			"theme.surface.accentSoftOpacityLight": "<br>surface / accent Soft Opacity Light",
			"theme.surface.accentSoftOpacityDark": "<br>surface / accent Soft Opacity Dark",
			"theme.surface.windowPaneOpacityLight": "<br>surface / window Pane Opacity Light",
			"theme.surface.windowPaneOpacityDark": "<br>surface / window Pane Opacity Dark",
			"theme.surface.invalidFillOpacity": "<br>surface / invalid Fill Opacity",
			"theme.surface.contactBlur": "<br>surface / contact Blur",
			"theme.surface.contactOffsetY": "<br>surface / contact Offset Y",
			"theme.surface.contactShadowOpacity": "<br>surface / contact Shadow Opacity",
			"theme.surface.overlayShadowColor": "<br>surface / overlay Shadow Color",
			"theme.components.buttonRadius": "<br>components / button Radius",
			"theme.components.buttonPaddingX": "<br>components / button Padding X",
			"theme.components.buttonPaddingY": "<br>components / button Padding Y",
			"theme.components.buttonHeight": "<br>components / button Height",
			"theme.components.buttonBorderWidth": "<br>components / button Border Width",
			"theme.components.fieldRadius": "<br>components / field Radius",
			"theme.components.fieldPaddingX": "<br>components / field Padding X",
			"theme.components.fieldHeight": "<br>components / field Height",
			"theme.components.fieldBorderWidth": "<br>components / field Border Width",
			"theme.components.menuRadius": "<br>components / menu Radius",
			"theme.components.menuPadding": "<br>components / menu Padding",
			"theme.components.menuItemHeight": "<br>components / menu Item Height",
			"theme.components.cardRadius": "<br>components / card Radius",
			"theme.components.cardPadding": "<br>components / card Padding",
			"theme.components.badgeRadius": "<br>components / badge Radius",
			"theme.components.badgePaddingX": "<br>components / badge Padding X",
			"theme.geometry.control.switchTrackWidth": "<br>geometry / control / switch Track Width",
			"theme.geometry.control.switchTrackHeight": "<br>geometry / control / switch Track Height",
			"theme.geometry.control.switchThumb": "<br>geometry / control / switch Thumb",
			"theme.geometry.control.buttonHeightXSmall": "<br>geometry / control / button Height XSmall",
			"theme.geometry.control.buttonHeightSmall": "<br>geometry / control / button Height Small",
			"theme.geometry.control.buttonHeight": "<br>geometry / control / button Height",
			"theme.geometry.control.buttonHeightLarge": "<br>geometry / control / button Height Large",
			"theme.geometry.control.buttonHeightXLarge": "<br>geometry / control / button Height XLarge",
			"theme.geometry.control.pageBackgroundHitRadius": "<br>geometry / control / page Background Hit Radius",
			"theme.geometry.control.presenceMarkerExtent": "<br>geometry / control / presence Marker Extent",
			"theme.geometry.control.colorPickerCursorRadius": "<br>geometry / control / color Picker Cursor Radius",
			"theme.geometry.control.swatchExtent": "<br>geometry / control / swatch Extent",
			"theme.geometry.control.segmentedProgressHeight": "<br>geometry / control / segmented Progress Height",
			"theme.geometry.control.fieldHeight": "<br>geometry / control / field Height",
			"theme.geometry.control.selectionControl": "<br>geometry / control / selection Control",
			"theme.geometry.control.selectionIndicatorInset": "<br>geometry / control / selection Indicator Inset",
			"theme.geometry.control.selectionIcon": "<br>geometry / control / selection Icon",
			"theme.geometry.control.toggleWidth": "<br>geometry / control / toggle Width",
			"theme.geometry.control.toggleHeight": "<br>geometry / control / toggle Height",
			"theme.geometry.control.toggleThumb": "<br>geometry / control / toggle Thumb",
			"theme.geometry.control.toggleInset": "<br>geometry / control / toggle Inset",
			"theme.geometry.control.segmentedDenseHeight": "<br>geometry / control / segmented Dense Height",
			"theme.geometry.control.segmentedDenseInset": "<br>geometry / control / segmented Dense Inset",
			"theme.geometry.control.segmentedDenseContentInset": "<br>geometry / control / segmented Dense Content Inset",
			"theme.geometry.control.segmentedDenseItemHeight": "<br>geometry / control / segmented Dense Item Height",
			"theme.geometry.control.slidingSelectionHeight": "<br>geometry / control / sliding Selection Height",
			"theme.geometry.control.slidingSelectionSegmentWidth": "<br>geometry / control / sliding Selection Segment Width",
			"theme.geometry.control.slidingSelectionPadding": "<br>geometry / control / sliding Selection Padding",
			"theme.geometry.control.slidingSelectionIndicatorHeight": "<br>geometry / control / sliding Selection Indicator Height",
			"theme.geometry.control.scrollbarThickness": "<br>geometry / control / scrollbar Thickness",
			"theme.geometry.control.sliderTrackHeight": "<br>geometry / control / slider Track Height",
			"theme.geometry.control.colorPlaneExtent": "<br>geometry / control / color Plane Extent",
			"theme.geometry.control.textFieldIndicatorHeightFactor": "<br>geometry / control / text Field Indicator Height Factor",
			"theme.geometry.control.textFieldLineHeightFactor": "<br>geometry / control / text Field Line Height Factor",
			"theme.geometry.control.textFieldMinLines": "<br>geometry / control / text Field Min Lines",
			"theme.geometry.control.textFieldMaxLines": "<br>geometry / control / text Field Max Lines",
			"theme.geometry.control.fileExplorerRowHeightAdjustment": "<br>geometry / control / file Explorer Row Height Adjustment",
			"theme.geometry.data.codeActionButtonSize": "<br>geometry / data / code Action Button Size",
			"theme.geometry.data.codeHeaderHeight": "<br>geometry / data / code Header Height",
			"theme.geometry.data.codeTerminalDot": "<br>geometry / data / code Terminal Dot",
			"theme.geometry.data.codeTerminalDotGap": "<br>geometry / data / code Terminal Dot Gap",
			"theme.geometry.data.codeHeaderPaddingX": "<br>geometry / data / code Header Padding X",
			"theme.geometry.data.codeBodyPaddingX": "<br>geometry / data / code Body Padding X",
			"theme.geometry.data.codeLineNumberWidth": "<br>geometry / data / code Line Number Width",
			"theme.geometry.data.codeWrappedLineWidth": "<br>geometry / data / code Wrapped Line Width",
			"theme.geometry.data.codeMaximumHeight": "<br>geometry / data / code Maximum Height",
			"theme.geometry.data.codeCollapsedHeight": "<br>geometry / data / code Collapsed Height",
			"theme.geometry.data.codeDisclosureSize": "<br>geometry / data / code Disclosure Size",
			"theme.geometry.data.filePreviewHeight": "<br>geometry / data / file Preview Height",
			"theme.geometry.data.previewCardCompactHeight": "<br>geometry / data / preview Card Compact Height",
			"theme.geometry.data.previewCardStandardHeight": "<br>geometry / data / preview Card Standard Height",
			"theme.geometry.data.previewCardLargeHeight": "<br>geometry / data / preview Card Large Height",
			"theme.geometry.data.dateGridCellHeight": "<br>geometry / data / date Grid Cell Height",
			"theme.geometry.data.keyValueLabelWidthCompact": "<br>geometry / data / key Value Label Width Compact",
			"theme.geometry.data.keyValueLabelWidthStandard": "<br>geometry / data / key Value Label Width Standard",
			"theme.geometry.data.stepperMarkerSize": "<br>geometry / data / stepper Marker Size",
			"theme.geometry.data.stepperLabelWidth": "<br>geometry / data / stepper Label Width",
			"theme.geometry.data.progressIndeterminateFraction": "<br>geometry / data / progress Indeterminate Fraction",
			"theme.geometry.data.placeholderMinimumHeight": "<br>geometry / data / placeholder Minimum Height",
			"theme.geometry.data.placeholderContentPaddingY": "<br>geometry / data / placeholder Content Padding Y",
			"theme.geometry.data.placeholderActionPaddingY": "<br>geometry / data / placeholder Action Padding Y",
			"theme.geometry.data.placeholderHatchBand": "<br>geometry / data / placeholder Hatch Band",
			"theme.geometry.data.placeholderHatchGap": "<br>geometry / data / placeholder Hatch Gap",
			"theme.geometry.data.placeholderLabelTracking": "<br>geometry / data / placeholder Label Tracking",
			"theme.geometry.data.placeholderDetailMaximumWidth": "<br>geometry / data / placeholder Detail Maximum Width",
			"theme.geometry.data.spinnerSquareFactor": "<br>geometry / data / spinner Square Factor",
			"theme.geometry.data.spinnerOrbitFactor": "<br>geometry / data / spinner Orbit Factor",
			"theme.geometry.data.spinnerCornerFactor": "<br>geometry / data / spinner Corner Factor",
			"theme.geometry.layout.drawerWidth": "<br>geometry / layout / drawer Width",
			"theme.geometry.layout.drawerHeight": "<br>geometry / layout / drawer Height",
			"theme.geometry.layout.resizeHandleExtent": "<br>geometry / layout / resize Handle Extent",
			"theme.geometry.layout.overlayViewportInset": "<br>geometry / layout / overlay Viewport Inset",
			"theme.geometry.layout.railDropTargetExtent": "<br>geometry / layout / rail Drop Target Extent",
			"theme.geometry.layout.disclosureIconSize": "<br>geometry / layout / disclosure Icon Size",
			"theme.geometry.layout.treeLeadingGap": "<br>geometry / layout / tree Leading Gap",
			"theme.geometry.layout.tooltipOffsetX": "<br>geometry / layout / tooltip Offset X",
			"theme.geometry.layout.primaryPaneWidth": "<br>geometry / layout / primary Pane Width",
			"theme.geometry.layout.secondaryPaneWidth": "<br>geometry / layout / secondary Pane Width",
			"theme.geometry.layout.primaryPaneBreakpoint": "<br>geometry / layout / primary Pane Breakpoint",
			"theme.geometry.layout.primaryPaneContentBreakpoint": "<br>geometry / layout / primary Pane Content Breakpoint",
			"theme.geometry.layout.responsivePaneBreakpoint": "<br>geometry / layout / responsive Pane Breakpoint",
			"theme.geometry.layout.secondaryPaneBreakpoint": "<br>geometry / layout / secondary Pane Breakpoint",
			"theme.geometry.layout.menuWidth": "<br>geometry / layout / menu Width",
			"theme.geometry.layout.commandMenuWidth": "<br>geometry / layout / command Menu Width",
			"theme.geometry.layout.menuHeaderHeight": "<br>geometry / layout / menu Header Height",
			"theme.geometry.layout.menuItemHeight": "<br>geometry / layout / menu Item Height",
			"theme.geometry.layout.dialogMaximumWidth": "<br>geometry / layout / dialog Maximum Width",
			"theme.geometry.layout.toastMaximumWidth": "<br>geometry / layout / toast Maximum Width",
			"theme.geometry.layout.inlineNoticeBreakpoint": "<br>geometry / layout / inline Notice Breakpoint",
			"theme.geometry.layout.statusBarBreakpoint": "<br>geometry / layout / status Bar Breakpoint",
			"theme.geometry.layout.settingsDialogMaximumWidth": "<br>geometry / layout / settings Dialog Maximum Width",
			"theme.geometry.layout.settingsDialogMaximumHeight": "<br>geometry / layout / settings Dialog Maximum Height",
			"theme.geometry.layout.settingsPaneGap": "<br>geometry / layout / settings Pane Gap",
			"theme.geometry.layout.settingsNavigationWidth": "<br>geometry / layout / settings Navigation Width",
			"theme.geometry.layout.settingsNavigationMinimumWidth": "<br>geometry / layout / settings Navigation Minimum Width",
			"theme.geometry.layout.settingsNavigationMaximumWidth": "<br>geometry / layout / settings Navigation Maximum Width",
			"theme.geometry.layout.settingsContentMaximumWidth": "<br>geometry / layout / settings Content Maximum Width",
			"theme.geometry.layout.themePreviewTileWidth": "<br>geometry / layout / theme Preview Tile Width",
			"theme.geometry.layout.windowHeaderHeight": "<br>geometry / layout / window Header Height",
			"theme.geometry.layout.windowHeaderControlSize": "<br>geometry / layout / window Header Control Size",
			"theme.geometry.layout.windowAppIconSize": "<br>geometry / layout / window App Icon Size",
			"theme.geometry.layout.windowIdentityGap": "<br>geometry / layout / window Identity Gap",
			"theme.geometry.optical.menuIconOffsetY": "<br>geometry / optical / menu Icon Offset Y",
			"theme.geometry.optical.railBadgeInset": "<br>geometry / optical / rail Badge Inset",
			"theme.geometry.optical.statusIconOffsetY": "<br>geometry / optical / status Icon Offset Y",
			"theme.geometry.optical.monoBaselineOffsetY": "<br>geometry / optical / mono Baseline Offset Y",
			"theme.geometry.optical.uiBaselineOffsetY": "<br>geometry / optical / ui Baseline Offset Y",
			"theme.dataVisualization.series": "<br>data Visualization / series",
			"theme.dataVisualization.seriesWash": "<br>data Visualization / series Wash",
			"theme.dataVisualization.axis": "<br>data Visualization / axis",
			"theme.dataVisualization.grid": "<br>data Visualization / grid",
			"theme.dataVisualization.gridStrong": "<br>data Visualization / grid Strong",
			"theme.dataVisualization.label": "<br>data Visualization / label",
			"theme.dataVisualization.value": "<br>data Visualization / value",
			"theme.dataVisualization.plotBackground": "<br>data Visualization / plot Background",
			"theme.dataVisualization.crosshair": "<br>data Visualization / crosshair",
			"theme.dataVisualization.marketUp": "<br>data Visualization / market Up",
			"theme.dataVisualization.marketUpWash": "<br>data Visualization / market Up Wash",
			"theme.dataVisualization.marketDown": "<br>data Visualization / market Down",
			"theme.dataVisualization.marketDownWash": "<br>data Visualization / market Down Wash",
			"theme.dataVisualization.marketFlat": "<br>data Visualization / market Flat"
		}
	},
	"modern-minimal-v1": {
		"schemaVersion": 1,
		"id": "modern-minimal-v1",
		"version": "1.0.0",
		"primitives": {
			"parchment50": "#FFF8F6F1",
			"parchment75": "#FFF0EDE6",
			"parchment100": "#FFEFEDE7",
			"parchment150": "#FFE7E4DD",
			"parchment200": "#FFE1DDD2",
			"parchment250": "#FFD3CFC4",
			"parchment350": "#FFBAB5AA",
			"parchment550": "#FF6A655B",
			"parchment700": "#FF514B40",
			"parchment750": "#FF484339",
			"parchment800": "#FF35322D",
			"parchment825": "#FF33322C",
			"parchment900": "#FF292724",
			"parchment925": "#FF21201B",
			"parchment950": "#FF201F1C",
			"ink1000": "#FF000000",
			"transparent": "#00000000",
			"ink50": "#FFFFFFFF",
			"ink100": "#FFF2F0EB",
			"ink150": "#FFEAE7E1",
			"ink200": "#FFE6E3DC",
			"ink250": "#FFBCB8B0",
			"ink300": "#FFADA89E",
			"ink350": "#FF9E998F",
			"ink400": "#FF8E8982",
			"ink450": "#FF7F7A75",
			"ink500": "#FF6F6C67",
			"ink550": "#FF6B6459",
			"ink600": "#FF4F5151",
			"ink650": "#FF414344",
			"ink700": "#FF343637",
			"ink750": "#FF303030",
			"ink800": "#FF292929",
			"ink850": "#FF232323",
			"ink900": "#FF1D1D1D",
			"ink950": "#FF101010",
			"warmNeutral25": "#FFF5F2EC",
			"warmNeutral50": "#FFE4E1DA",
			"warmNeutral100": "#FFD6D0C6",
			"warmNeutral200": "#FFC8C0B4",
			"warmNeutral300": "#FFB8B2A4",
			"warmNeutral400": "#FF918A7B",
			"warmNeutral450": "#FF8C8477",
			"warmNeutral500": "#FF7A7566",
			"warmNeutral600": "#FF6A6256",
			"warmNeutral700": "#FF585249",
			"warmNeutral750": "#FF45413A",
			"warmNeutral800": "#FF433F3A",
			"warmNeutral900": "#FF34302B",
			"sand50": "#FFF8F1E2",
			"sand300": "#FFF0D79A",
			"sand500": "#FFE0BE73",
			"sand800": "#FF453D2B",
			"sand900": "#FF302B20",
			"gold50": "#FFF6EBD7",
			"gold300": "#FFE8BD70",
			"gold500": "#FFD3A152",
			"gold800": "#FF443725",
			"gold900": "#FF30271B",
			"ochre50": "#FFF3E4CF",
			"ochre300": "#FFDFA04E",
			"ochre500": "#FFC6823D",
			"ochre800": "#FF413222",
			"ochre900": "#FF2E241A",
			"terracotta50": "#FFEEDDD0",
			"terracotta300": "#FFC88745",
			"terracotta500": "#FFA96836",
			"terracotta800": "#FF3D2D22",
			"terracotta900": "#FF2C211B",
			"clay50": "#FFE9D8D1",
			"clay300": "#FFA86D43",
			"clay500": "#FF895137",
			"clay800": "#FF382A23",
			"clay900": "#FF291F1C",
			"umber50": "#FFE4D5D1",
			"umber300": "#FF89573E",
			"umber500": "#FF683E33",
			"umber800": "#FF332724",
			"umber900": "#FF261D1C",
			"green100": "#FFDFF0E5",
			"green400": "#FF67AE86",
			"green500": "#FF51B77B",
			"green600": "#FF2D8057",
			"green800": "#FF243B2D",
			"green900": "#FF1D3025",
			"red100": "#FFFAE3E2",
			"red300": "#FFFA6C73",
			"red400": "#FFD27B74",
			"red600": "#FFA7443F",
			"red800": "#FF472925",
			"red900": "#FF3B2320",
			"amber500": "#FFF6B52E",
			"blue500": "#FF5499DF",
			"scrim": "#99010202",
			"line": "#00000000",
			"transparentSurface": "#9426292D",
			"transparentSurfaceInset": "#A8404449",
			"pureWhite": "#FFFFFFFF",
			"pureBlack": "#FF000000",
			"accent-ink-light": "#FF1D1D1D",
			"accent-ink-dark": "#FFFFFFFF",
			"accent-terracotta-light": "#FF92563C",
			"accent-terracotta-dark": "#FFCB8E72",
			"accent-ochre-light": "#FF7D612F",
			"accent-ochre-dark": "#FFB99860",
			"accent-olive-light": "#FF5E6A39",
			"accent-olive-dark": "#FF94A366",
			"accent-slate-light": "#FF4E678A",
			"accent-slate-dark": "#FF879EBD",
			"accent-crimson-light": "#FF9F4B59",
			"accent-crimson-dark": "#FFCE8A95",
			"color-b8292724": "#B8292724",
			"color-b835322d": "#B835322D",
			"space0": 0,
			"space50": 2,
			"space100": 4,
			"space200": 8,
			"space250": 10,
			"space300": 12,
			"space400": 16,
			"space600": 24,
			"space800": 32,
			"space1000": 40,
			"space1200": 48,
			"space1600": 64,
			"space2400": 96,
			"radius0": 0,
			"radius50": 2,
			"radius100": 4,
			"radius150": 6,
			"radius200": 8,
			"radius250": 10,
			"radius300": 12,
			"radius400": 16,
			"radiusFull": 9999,
			"stroke0": 0,
			"stroke100": 1,
			"stroke200": 2,
			"font100": 10,
			"font200": 12,
			"font300": 14,
			"font400": 16,
			"font500": 18,
			"font600": 22,
			"font700": 28,
			"font800": 36,
			"font900": 48,
			"font1000": 64,
			"tracking0": 0,
			"trackingTight": -0.5,
			"trackingWide": 1.2,
			"trackingWider": 1.32,
			"length-30": 30,
			"length-56": 56,
			"length-20": 20,
			"length-60": 60,
			"length-74": 74,
			"length-170": 170,
			"length-11": 11,
			"length-3": 3,
			"length-5": 5,
			"length-7": 7,
			"length-3_5": 3.5,
			"length-41_4": 41.4,
			"length-168": 168,
			"length-26": 26,
			"length-520": 520,
			"length-320": 320,
			"length-120": 120,
			"length-9": 9,
			"length-220": 220,
			"length-192": 192,
			"length-128": 128,
			"length-112": 112,
			"length-10_5": 10.5,
			"length-336": 336,
			"length-300": 300,
			"length-350": 350,
			"length-400": 400,
			"length-800": 800,
			"length-960": 960,
			"length-1120": 1120,
			"length-200": 200,
			"length-360": 360,
			"length-480": 480,
			"length-1380": 1380,
			"length-880": 880,
			"length-260": 260,
			"length-820": 820,
			"length-minus-1": -1,
			"leading100": 1.125,
			"leading116": 1.166,
			"leading120": 1.2,
			"leading122": 1.222,
			"leading127": 1.272,
			"leading128": 1.285,
			"leading133": 1.333,
			"leading142": 1.428,
			"leading150": 1.5,
			"leading155": 1.555,
			"leading150Legacy": 1.2,
			"leading200": 1.25,
			"leading300": 1.3,
			"leading350": 1.35,
			"leading400": 1.4,
			"leading450": 1.45,
			"leading500": 1.5,
			"leading550": 1.55,
			"leading650": 1.65,
			"ratio-0_4": 0.4,
			"ratio-0_35": 0.35,
			"ratio-0_32": 0.32,
			"ratio-0_22": 0.22,
			"ratio-0_06": 0.06,
			"ratio-8": 8,
			"ratio-2": 2,
			"ratio-3": 3,
			"ratio-6": 6,
			"weight400": 400,
			"weight500": 500,
			"weight600": 600,
			"weight700": 700,
			"weight800": 800,
			"duration0": 0,
			"duration100": 120,
			"duration150": 140,
			"duration400": 450,
			"duration500": 500,
			"duration-4000": 4000,
			"duration-1000": 1000,
			"easeStandard": "[0.215, 0.61, 0.355, 1.0]",
			"easeEmphasized": "[0.645, 0.045, 0.355, 1.0]",
			"opacity100": 0.1,
			"opacity120": 0.12,
			"opacity140": 0.14,
			"opacity160": 0.16,
			"opacity180": 0.18,
			"opacity220": 0.22,
			"opacity280": 0.28,
			"opacity320": 0.32,
			"opacity350": 0.35,
			"opacity440": 0.44,
			"opacity480": 0.48,
			"opacity550": 0.55,
			"opacity620": 0.62,
			"opacity720": 0.72,
			"opacity780": 0.78,
			"opacity820": 0.82,
			"opacity-0_13333333333333333": 0.13333333333333333,
			"opacity-0_6": 0.6,
			"opacity-0_88": 0.88,
			"opacity-0_47843137254901963": 0.47843137254901963,
			"opacity-0_1803921568627451": 0.1803921568627451,
			"opacity-0_07058823529411765": 0.07058823529411765,
			"opacity-0_8509803921568627": 0.8509803921568627,
			"family-packages-kallopis-noto-sans-tc": "packages/kallopis/Noto Sans TC",
			"family-noto-sans-tc": "Noto Sans TC",
			"family-microsoft-jhenghei-ui": "Microsoft JhengHei UI",
			"family-microsoft-jhenghei": "Microsoft JhengHei",
			"family-pingfang-tc": "PingFang TC",
			"family-sans-serif": "sans-serif",
			"family-packages-kallopis-ibm-plex-mono": "packages/kallopis/IBM Plex Mono",
			"family-ibm-plex-mono": "IBM Plex Mono",
			"family-consolas": "Consolas",
			"family-courier-new": "Courier New",
			"family-monospace": "monospace",
			"string-shadow": "shadow",
			"count-4": 4,
			"count-8": 8,
			"length-15": 15,
			"mmLightCanvas": "#FFF5F5F5",
			"mmLightCanvasSoft": "#FFFAFAFA",
			"mmLightSurface": "#FFF0EFED",
			"mmLightCard": "#FFFFFFFF",
			"mmLightInk": "#FF0C0A09",
			"mmLightPrimary": "#FF292524",
			"mmLightBody": "#FF4E4E4E",
			"mmLightMuted": "#FF777169",
			"mmLightFaint": "#FFA8A29E",
			"mmLightHair": "#FFE7E5E4",
			"mmLightHairStrong": "#FFD6D3D1",
			"mmDarkCanvas": "#FF0C0A09",
			"mmDarkSurface": "#FF141210",
			"mmDarkElevated": "#FF1C1917",
			"mmDarkInset": "#FF080706",
			"mmDarkBorder": "#FF292524",
			"mmDarkBorderStrong": "#FF44403C",
			"mmDarkText": "#FFFFFFFF",
			"mmDarkBody": "#FFE7E5E4",
			"mmDarkMuted": "#FFA8A29E",
			"mmDarkFaint": "#FF777169",
			"mmDarkPeach": "#FFF4C5A8",
			"mmDarkPeachSoft": "#FF2B221D",
			"mmSuccess": "#FF16A34A",
			"mmWarning": "#FFB9770E",
			"mmDanger": "#FFDC2626",
			"mmInfo": "#FF7097F1",
			"mmTransSurface": "#E6F0EFED",
			"mmTransCard": "#F2FFFFFF",
			"mmFamilyInter": "Inter",
			"mmFamilyGaramond": "EB Garamond"
		},
		"semantics": {
			"theme.colors.app": {
				"light": "p(mmLightCanvas)",
				"dark": "p(mmDarkCanvas)",
				"ultraDark": "p(mmDarkInset)",
				"transparent": "p(transparent)"
			},
			"theme.colors.surface": {
				"light": "p(mmLightSurface)",
				"dark": "p(mmDarkSurface)",
				"ultraDark": "p(mmDarkCanvas)",
				"transparent": "p(mmTransSurface)"
			},
			"theme.colors.surfaceInset": {
				"light": "p(mmLightCanvasSoft)",
				"dark": "p(mmDarkInset)",
				"ultraDark": "p(mmDarkInset)",
				"transparent": "p(mmLightCanvasSoft)"
			},
			"theme.colors.surfaceMuted": {
				"light": "p(mmLightSurface)",
				"dark": "p(mmDarkElevated)",
				"ultraDark": "p(mmDarkSurface)",
				"transparent": "p(mmLightSurface)"
			},
			"theme.colors.component": {
				"light": "p(mmLightCard)",
				"dark": "p(mmDarkElevated)",
				"ultraDark": "p(mmDarkSurface)",
				"transparent": "p(mmTransCard)"
			},
			"theme.colors.stageSurface": {
				"light": "p(mmLightCard)",
				"dark": "p(mmDarkElevated)",
				"ultraDark": "p(mmDarkSurface)",
				"transparent": "p(mmTransCard)"
			},
			"theme.colors.overlay": {
				"light": "p(mmLightCard)",
				"dark": "p(mmDarkElevated)",
				"ultraDark": "p(mmDarkSurface)",
				"transparent": "p(mmLightCard)"
			},
			"theme.colors.surfaceRaised": {
				"light": "p(mmLightCard)",
				"dark": "p(mmDarkElevated)",
				"ultraDark": "p(mmDarkSurface)",
				"transparent": "p(mmLightCard)"
			},
			"theme.colors.modalScrim": {
				"light": "p(scrim)",
				"dark": "p(scrim)",
				"ultraDark": "p(scrim)",
				"transparent": "p(scrim)"
			},
			"theme.colors.guide": {
				"light": "p(mmLightHair)",
				"dark": "p(mmDarkBorder)",
				"ultraDark": "p(mmDarkBorder)",
				"transparent": "p(mmLightHair)"
			},
			"theme.colors.divider": {
				"light": "p(mmLightHair)",
				"dark": "p(mmDarkBorder)",
				"ultraDark": "p(mmDarkBorder)",
				"transparent": "p(mmLightHair)"
			},
			"theme.colors.pagePattern": {
				"light": "p(mmLightHair)",
				"dark": "p(mmDarkBorder)",
				"ultraDark": "p(mmDarkBorder)",
				"transparent": "p(mmLightHair)"
			},
			"theme.colors.text": {
				"light": "p(mmLightInk)",
				"dark": "p(mmDarkText)",
				"ultraDark": "p(mmDarkText)",
				"transparent": "p(mmLightInk)"
			},
			"theme.colors.textMuted": {
				"light": "p(mmLightMuted)",
				"dark": "p(mmDarkMuted)",
				"ultraDark": "p(mmDarkMuted)",
				"transparent": "p(mmLightMuted)"
			},
			"theme.colors.textFaint": {
				"light": "p(mmLightFaint)",
				"dark": "p(mmDarkFaint)",
				"ultraDark": "p(mmDarkFaint)",
				"transparent": "p(mmLightFaint)"
			},
			"theme.colors.border": {
				"light": "p(mmLightHair)",
				"dark": "p(mmDarkBorder)",
				"ultraDark": "p(mmDarkBorder)",
				"transparent": "p(mmLightHair)"
			},
			"theme.colors.borderStrong": {
				"light": "p(mmLightHairStrong)",
				"dark": "p(mmDarkBorderStrong)",
				"ultraDark": "p(mmDarkBorderStrong)",
				"transparent": "p(mmLightHairStrong)"
			},
			"theme.colors.brand": {
				"light": "p(mmLightPrimary)",
				"dark": "p(mmDarkBody)",
				"ultraDark": "p(mmDarkBody)",
				"transparent": "p(mmLightPrimary)"
			},
			"theme.colors.accent": {
				"light": "p(mmLightPrimary)",
				"dark": "p(mmDarkPeach)",
				"ultraDark": "p(mmDarkPeach)",
				"transparent": "p(mmLightPrimary)"
			},
			"theme.colors.accentSoft": {
				"light": "p(mmLightSurface)",
				"dark": "p(mmDarkPeachSoft)",
				"ultraDark": "p(mmDarkPeachSoft)",
				"transparent": "p(mmLightSurface)"
			},
			"theme.colors.interaction": {
				"light": "p(mmLightInk)",
				"dark": "p(mmDarkPeach)",
				"ultraDark": "p(mmDarkPeach)",
				"transparent": "p(mmLightInk)"
			},
			"theme.colors.interactionSoft": {
				"light": "p(mmLightSurface)",
				"dark": "p(mmDarkElevated)",
				"ultraDark": "p(mmDarkElevated)",
				"transparent": "p(mmLightSurface)"
			},
			"theme.colors.success": {
				"light": "p(mmSuccess)",
				"dark": "p(mmSuccess)",
				"ultraDark": "p(mmSuccess)",
				"transparent": "p(mmSuccess)"
			},
			"theme.colors.warning": {
				"light": "p(mmWarning)",
				"dark": "p(mmWarning)",
				"ultraDark": "p(mmWarning)",
				"transparent": "p(mmWarning)"
			},
			"theme.colors.danger": {
				"light": "p(mmDanger)",
				"dark": "p(mmDanger)",
				"ultraDark": "p(mmDanger)",
				"transparent": "p(mmDanger)"
			},
			"theme.colors.info": {
				"light": "p(mmInfo)",
				"dark": "p(mmInfo)",
				"ultraDark": "p(mmInfo)",
				"transparent": "p(mmInfo)"
			},
			"theme.colors.onStatus": {
				"light": "p(ink50)",
				"dark": "p(ink50)",
				"ultraDark": "p(ink50)",
				"transparent": "p(ink50)"
			},
			"theme.colors.onLightBackground": {
				"light": "p(mmLightInk)",
				"dark": "p(mmLightInk)",
				"ultraDark": "p(mmLightInk)",
				"transparent": "p(mmLightInk)"
			},
			"theme.colors.onDarkBackground": {
				"light": "p(mmDarkText)",
				"dark": "p(mmDarkText)",
				"ultraDark": "p(mmDarkText)",
				"transparent": "p(mmDarkText)"
			},
			"theme.colors.mutedOnLightBackground": {
				"light": "p(parchment550)",
				"dark": "p(parchment550)",
				"ultraDark": "p(ink550)",
				"transparent": "p(parchment550)"
			},
			"theme.colors.mutedOnDarkBackground": {
				"light": "p(parchment350)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink300)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.faintOnBackground": {
				"light": "p(parchment550)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink400)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.transparent": {
				"light": "p(transparent)",
				"dark": "p(transparent)",
				"ultraDark": "p(transparent)",
				"transparent": "p(transparent)"
			},
			"theme.typography.sansFamily": {
				"light": "p(family-packages-kallopis-noto-sans-tc)",
				"dark": "p(family-packages-kallopis-noto-sans-tc)",
				"ultraDark": "p(family-packages-kallopis-noto-sans-tc)",
				"transparent": "p(family-packages-kallopis-noto-sans-tc)"
			},
			"theme.typography.sansFallback": {
				"light": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"dark": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"ultraDark": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"transparent": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]"
			},
			"theme.typography.monoFamily": {
				"light": "p(family-packages-kallopis-ibm-plex-mono)",
				"dark": "p(family-packages-kallopis-ibm-plex-mono)",
				"ultraDark": "p(family-packages-kallopis-ibm-plex-mono)",
				"transparent": "p(family-packages-kallopis-ibm-plex-mono)"
			},
			"theme.typography.monoFallback": {
				"light": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"dark": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"ultraDark": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"transparent": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]"
			},
			"theme.typography.uiFamily": {
				"light": "p(mmFamilyInter)",
				"dark": "p(mmFamilyInter)",
				"ultraDark": "p(mmFamilyInter)",
				"transparent": "p(mmFamilyInter)"
			},
			"theme.typography.bodyFamily": {
				"light": "p(mmFamilyInter)",
				"dark": "p(mmFamilyInter)",
				"ultraDark": "p(mmFamilyInter)",
				"transparent": "p(mmFamilyInter)"
			},
			"theme.typography.codeFamily": {
				"light": "p(family-packages-kallopis-ibm-plex-mono)",
				"dark": "p(family-packages-kallopis-ibm-plex-mono)",
				"ultraDark": "p(family-packages-kallopis-ibm-plex-mono)",
				"transparent": "p(family-packages-kallopis-ibm-plex-mono)"
			},
			"theme.typography.micro": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.typography.caption": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.typography.sub": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.typography.body": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.typography.lead": {
				"light": "p(font500)",
				"dark": "p(font500)",
				"ultraDark": "p(font500)",
				"transparent": "p(font500)"
			},
			"theme.typography.h4": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.typography.h3": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.typography.h2": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.typography.h1": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.typography.display": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.typography.label": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.typography.section": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.typography.headingSmall": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.typography.heading": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.typography.title": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.typography.microLeading": {
				"light": "p(leading120)",
				"dark": "p(leading120)",
				"ultraDark": "p(leading120)",
				"transparent": "p(leading120)"
			},
			"theme.typography.captionLeading": {
				"light": "p(leading133)",
				"dark": "p(leading133)",
				"ultraDark": "p(leading133)",
				"transparent": "p(leading133)"
			},
			"theme.typography.subLeading": {
				"light": "p(leading142)",
				"dark": "p(leading142)",
				"ultraDark": "p(leading142)",
				"transparent": "p(leading142)"
			},
			"theme.typography.bodyLeading": {
				"light": "p(leading150)",
				"dark": "p(leading150)",
				"ultraDark": "p(leading150)",
				"transparent": "p(leading150)"
			},
			"theme.typography.leadLeading": {
				"light": "p(leading155)",
				"dark": "p(leading155)",
				"ultraDark": "p(leading155)",
				"transparent": "p(leading155)"
			},
			"theme.typography.h4Leading": {
				"light": "p(leading127)",
				"dark": "p(leading127)",
				"ultraDark": "p(leading127)",
				"transparent": "p(leading127)"
			},
			"theme.typography.h3Leading": {
				"light": "p(leading128)",
				"dark": "p(leading128)",
				"ultraDark": "p(leading128)",
				"transparent": "p(leading128)"
			},
			"theme.typography.h2Leading": {
				"light": "p(leading122)",
				"dark": "p(leading122)",
				"ultraDark": "p(leading122)",
				"transparent": "p(leading122)"
			},
			"theme.typography.h1Leading": {
				"light": "p(leading116)",
				"dark": "p(leading116)",
				"ultraDark": "p(leading116)",
				"transparent": "p(leading116)"
			},
			"theme.typography.displayLeading": {
				"light": "p(leading100)",
				"dark": "p(leading100)",
				"ultraDark": "p(leading100)",
				"transparent": "p(leading100)"
			},
			"theme.typography.headingLeading": {
				"light": "p(leading122)",
				"dark": "p(leading122)",
				"ultraDark": "p(leading122)",
				"transparent": "p(leading122)"
			},
			"theme.typography.codeLeading": {
				"light": "p(leading142)",
				"dark": "p(leading142)",
				"ultraDark": "p(leading142)",
				"transparent": "p(leading142)"
			},
			"theme.typography.readingLeading": {
				"light": "p(leading155)",
				"dark": "p(leading155)",
				"ultraDark": "p(leading155)",
				"transparent": "p(leading155)"
			},
			"theme.typography.labelLeading": {
				"light": "p(leading133)",
				"dark": "p(leading133)",
				"ultraDark": "p(leading133)",
				"transparent": "p(leading133)"
			},
			"theme.typography.labelTracking": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.typography.displayTracking": {
				"light": "p(trackingTight)",
				"dark": "p(trackingTight)",
				"ultraDark": "p(trackingTight)",
				"transparent": "p(trackingTight)"
			},
			"theme.typography.regular": {
				"light": "p(weight400)",
				"dark": "p(weight400)",
				"ultraDark": "p(weight400)",
				"transparent": "p(weight400)"
			},
			"theme.typography.medium": {
				"light": "p(weight400)",
				"dark": "p(weight400)",
				"ultraDark": "p(weight400)",
				"transparent": "p(weight400)"
			},
			"theme.typography.semiBold": {
				"light": "p(weight600)",
				"dark": "p(weight600)",
				"ultraDark": "p(weight600)",
				"transparent": "p(weight600)"
			},
			"theme.typography.bold": {
				"light": "p(weight700)",
				"dark": "p(weight700)",
				"ultraDark": "p(weight700)",
				"transparent": "p(weight700)"
			},
			"theme.typography.extraBold": {
				"light": "p(weight700)",
				"dark": "p(weight700)",
				"ultraDark": "p(weight700)",
				"transparent": "p(weight700)"
			},
			"theme.typography.strong": {
				"light": "p(weight600)",
				"dark": "p(weight600)",
				"ultraDark": "p(weight600)",
				"transparent": "p(weight600)"
			},
			"theme.spacing.space0_5": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.spacing.space1": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.space2": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.space3": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.space4": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.space6": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.space8": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.space12": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.space16": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.spacing.space24": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.spacing.hairline": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.spacing.tight": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.contentInlineGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.contentStackGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.contentInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.controlContentGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.controlInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.actionGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromeGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromePanelInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromeToolbarGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationItemInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationRailInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationRailItemGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayContentInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayHeadingGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayItemGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationSectionGap": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.spacing.appFrameInset": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.windowHeaderMargin": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.dockMargin": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.base": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.comfortable": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.loose": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.section": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.sectionLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.page": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.spacing.pageLarge": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.spacing.controlPaddingXSmall": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.controlPaddingX": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.controlPaddingXLarge": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.controlPaddingXXLarge": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.controlPaddingY": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.containerPadding": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.itemGap": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.groupGap": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.controlHeightXSmall": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.spacing.controlHeightSmall": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.spacing.controlHeight": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.spacing.controlHeightLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.controlHeightXLarge": {
				"light": "p(length-56)",
				"dark": "p(length-56)",
				"ultraDark": "p(length-56)",
				"transparent": "p(length-56)"
			},
			"theme.spacing.iconSmall": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.spacing.iconBase": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.iconGlyph": {
				"light": "p(font500)",
				"dark": "p(font500)",
				"ultraDark": "p(font500)",
				"transparent": "p(font500)"
			},
			"theme.spacing.icon": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.spacing.iconMedium": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.iconLarge": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.chromeHeader": {
				"light": "p(length-60)",
				"dark": "p(length-60)",
				"ultraDark": "p(length-60)",
				"transparent": "p(length-60)"
			},
			"theme.spacing.chromeStatusBar": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.spacing.chromeRail": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.chromeTab": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.iconButton": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.iconTiny": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.spacing.indicatorDot": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.spacing.indicatorDotLarge": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.noticeIconSlot": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.spacing.toastIconSlot": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.spacing.gutterNumber": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.gutterMarker": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.spacing.micro": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.spacing.calendarContentCell": {
				"light": "p(length-74)",
				"dark": "p(length-74)",
				"ultraDark": "p(length-74)",
				"transparent": "p(length-74)"
			},
			"theme.spacing.gridTileWidth": {
				"light": "p(length-170)",
				"dark": "p(length-170)",
				"ultraDark": "p(length-170)",
				"transparent": "p(length-170)"
			},
			"theme.spacing.iconMicro": {
				"light": "p(length-11)",
				"dark": "p(length-11)",
				"ultraDark": "p(length-11)",
				"transparent": "p(length-11)"
			},
			"theme.spacing.avatarSmall": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.progressTrack": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.spacing.skeletonLine": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.spacing.railItem": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.shape.none": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.shape.sm": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.control": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.shape.controlInner": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.shape.toggleTrack": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.shape.card": {
				"light": "p(radius200)",
				"dark": "p(radius200)",
				"ultraDark": "p(radius200)",
				"transparent": "p(radius200)"
			},
			"theme.shape.panel": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.shape.pill": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.shape.hairline": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.shape.stroke": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.dashedLength": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.shape.dashedGap": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.dashedOpacity": {
				"light": "p(opacity780)",
				"dark": "p(opacity780)",
				"ultraDark": "p(opacity780)",
				"transparent": "p(opacity780)"
			},
			"theme.motion.themeTransition": {
				"light": "p(duration0)",
				"dark": "p(duration0)",
				"ultraDark": "p(duration0)",
				"transparent": "p(duration0)"
			},
			"theme.motion.styleTransition": {
				"light": "p(duration0)",
				"dark": "p(duration0)",
				"ultraDark": "p(duration0)",
				"transparent": "p(duration0)"
			},
			"theme.motion.stateTransition": {
				"light": "p(duration150)",
				"dark": "p(duration150)",
				"ultraDark": "p(duration150)",
				"transparent": "p(duration150)"
			},
			"theme.motion.overlayEnter": {
				"light": "p(duration150)",
				"dark": "p(duration150)",
				"ultraDark": "p(duration150)",
				"transparent": "p(duration150)"
			},
			"theme.motion.overlayExit": {
				"light": "p(duration100)",
				"dark": "p(duration100)",
				"ultraDark": "p(duration100)",
				"transparent": "p(duration100)"
			},
			"theme.motion.toastDwell": {
				"light": "p(duration500)",
				"dark": "p(duration500)",
				"ultraDark": "p(duration500)",
				"transparent": "p(duration500)"
			},
			"theme.motion.tooltipDelay": {
				"light": "p(duration400)",
				"dark": "p(duration400)",
				"ultraDark": "p(duration400)",
				"transparent": "p(duration400)"
			},
			"theme.motion.tooltipDwell": {
				"light": "p(duration-4000)",
				"dark": "p(duration-4000)",
				"ultraDark": "p(duration-4000)",
				"transparent": "p(duration-4000)"
			},
			"theme.motion.spinnerCycle": {
				"light": "p(duration-1000)",
				"dark": "p(duration-1000)",
				"ultraDark": "p(duration-1000)",
				"transparent": "p(duration-1000)"
			},
			"theme.motion.longPressThreshold": {
				"light": "p(duration500)",
				"dark": "p(duration500)",
				"ultraDark": "p(duration500)",
				"transparent": "p(duration500)"
			},
			"theme.motion.standard": {
				"light": "p(easeStandard)",
				"dark": "p(easeStandard)",
				"ultraDark": "p(easeStandard)",
				"transparent": "p(easeStandard)"
			},
			"theme.motion.emphasized": {
				"light": "p(easeEmphasized)",
				"dark": "p(easeEmphasized)",
				"ultraDark": "p(easeEmphasized)",
				"transparent": "p(easeEmphasized)"
			},
			"theme.surface.separation": {
				"light": "p(string-shadow)",
				"dark": "p(string-shadow)",
				"ultraDark": "p(string-shadow)",
				"transparent": "p(string-shadow)"
			},
			"theme.surface.overlayBlur": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.surface.overlaySpread": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.surface.overlayOffsetY": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.surface.overlayShadowOpacity": {
				"light": "p(opacity-0_13333333333333333)",
				"dark": "p(opacity-0_13333333333333333)",
				"ultraDark": "p(opacity-0_13333333333333333)",
				"transparent": "p(opacity-0_13333333333333333)"
			},
			"theme.surface.scrimOpacity": {
				"light": "p(opacity-0_6)",
				"dark": "p(opacity-0_6)",
				"ultraDark": "p(opacity-0_6)",
				"transparent": "p(opacity-0_6)"
			},
			"theme.surface.selectionWashOpacity": {
				"light": "p(opacity100)",
				"dark": "p(opacity100)",
				"ultraDark": "p(opacity100)",
				"transparent": "p(opacity100)"
			},
			"theme.surface.focusWashOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.statusFillOpacity": {
				"light": "p(opacity160)",
				"dark": "p(opacity160)",
				"ultraDark": "p(opacity160)",
				"transparent": "p(opacity160)"
			},
			"theme.surface.pressProgressOpacity": {
				"light": "p(opacity550)",
				"dark": "p(opacity550)",
				"ultraDark": "p(opacity550)",
				"transparent": "p(opacity550)"
			},
			"theme.surface.diffFillOpacity": {
				"light": "p(opacity120)",
				"dark": "p(opacity120)",
				"ultraDark": "p(opacity120)",
				"transparent": "p(opacity120)"
			},
			"theme.surface.gridLineOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.veilOpacity": {
				"light": "p(opacity820)",
				"dark": "p(opacity820)",
				"ultraDark": "p(opacity820)",
				"transparent": "p(opacity820)"
			},
			"theme.surface.statusRowOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.statusRowSelectedOpacity": {
				"light": "p(opacity320)",
				"dark": "p(opacity320)",
				"ultraDark": "p(opacity320)",
				"transparent": "p(opacity320)"
			},
			"theme.surface.statusRowOpacityDark": {
				"light": "p(opacity280)",
				"dark": "p(opacity280)",
				"ultraDark": "p(opacity280)",
				"transparent": "p(opacity280)"
			},
			"theme.surface.statusRowSelectedOpacityDark": {
				"light": "p(opacity480)",
				"dark": "p(opacity480)",
				"ultraDark": "p(opacity480)",
				"transparent": "p(opacity480)"
			},
			"theme.surface.frostedOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.frostedVeilOpacity": {
				"light": "p(opacity120)",
				"dark": "p(opacity120)",
				"ultraDark": "p(opacity120)",
				"transparent": "p(opacity120)"
			},
			"theme.surface.backdropBlurSigma": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.surface.dragOpacity": {
				"light": "p(opacity820)",
				"dark": "p(opacity820)",
				"ultraDark": "p(opacity820)",
				"transparent": "p(opacity820)"
			},
			"theme.surface.dragSourceOpacity": {
				"light": "p(opacity350)",
				"dark": "p(opacity350)",
				"ultraDark": "p(opacity350)",
				"transparent": "p(opacity350)"
			},
			"theme.surface.themePreviewDisabledOpacity": {
				"light": "p(opacity620)",
				"dark": "p(opacity620)",
				"ultraDark": "p(opacity620)",
				"transparent": "p(opacity620)"
			},
			"theme.surface.listStatusOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.listStatusSelectedOpacity": {
				"light": "p(opacity320)",
				"dark": "p(opacity320)",
				"ultraDark": "p(opacity320)",
				"transparent": "p(opacity320)"
			},
			"theme.surface.accentSoftOpacityLight": {
				"light": "p(opacity160)",
				"dark": "p(opacity160)",
				"ultraDark": "p(opacity160)",
				"transparent": "p(opacity160)"
			},
			"theme.surface.accentSoftOpacityDark": {
				"light": "p(opacity220)",
				"dark": "p(opacity220)",
				"ultraDark": "p(opacity220)",
				"transparent": "p(opacity220)"
			},
			"theme.surface.windowPaneOpacityLight": {
				"light": "p(opacity-0_88)",
				"dark": "p(opacity-0_88)",
				"ultraDark": "p(opacity-0_88)",
				"transparent": "p(opacity-0_88)"
			},
			"theme.surface.windowPaneOpacityDark": {
				"light": "p(opacity720)",
				"dark": "p(opacity720)",
				"ultraDark": "p(opacity720)",
				"transparent": "p(opacity720)"
			},
			"theme.surface.invalidFillOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.contactBlur": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.surface.contactOffsetY": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.surface.contactShadowOpacity": {
				"light": "p(opacity-0_13333333333333333)",
				"dark": "p(opacity-0_13333333333333333)",
				"ultraDark": "p(opacity-0_13333333333333333)",
				"transparent": "p(opacity-0_13333333333333333)"
			},
			"theme.surface.overlayShadowColor": {
				"light": "p(ink1000)",
				"dark": "p(ink1000)",
				"ultraDark": "p(ink1000)",
				"transparent": "p(ink1000)"
			},
			"theme.components.buttonRadius": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.components.buttonPaddingX": {
				"light": "s(theme.spacing.controlPaddingX)",
				"dark": "s(theme.spacing.controlPaddingX)",
				"ultraDark": "s(theme.spacing.controlPaddingX)",
				"transparent": "s(theme.spacing.controlPaddingX)"
			},
			"theme.components.buttonPaddingY": {
				"light": "s(theme.spacing.controlPaddingY)",
				"dark": "s(theme.spacing.controlPaddingY)",
				"ultraDark": "s(theme.spacing.controlPaddingY)",
				"transparent": "s(theme.spacing.controlPaddingY)"
			},
			"theme.components.buttonHeight": {
				"light": "s(theme.geometry.control.buttonHeight)",
				"dark": "s(theme.geometry.control.buttonHeight)",
				"ultraDark": "s(theme.geometry.control.buttonHeight)",
				"transparent": "s(theme.geometry.control.buttonHeight)"
			},
			"theme.components.buttonBorderWidth": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.components.fieldRadius": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.components.fieldPaddingX": {
				"light": "s(theme.spacing.controlInset)",
				"dark": "s(theme.spacing.controlInset)",
				"ultraDark": "s(theme.spacing.controlInset)",
				"transparent": "s(theme.spacing.controlInset)"
			},
			"theme.components.fieldHeight": {
				"light": "s(theme.geometry.control.fieldHeight)",
				"dark": "s(theme.geometry.control.fieldHeight)",
				"ultraDark": "s(theme.geometry.control.fieldHeight)",
				"transparent": "s(theme.geometry.control.fieldHeight)"
			},
			"theme.components.fieldBorderWidth": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.components.menuRadius": {
				"light": "s(theme.shape.card)",
				"dark": "s(theme.shape.card)",
				"ultraDark": "s(theme.shape.card)",
				"transparent": "s(theme.shape.card)"
			},
			"theme.components.menuPadding": {
				"light": "s(theme.spacing.overlayContentInset)",
				"dark": "s(theme.spacing.overlayContentInset)",
				"ultraDark": "s(theme.spacing.overlayContentInset)",
				"transparent": "s(theme.spacing.overlayContentInset)"
			},
			"theme.components.menuItemHeight": {
				"light": "s(theme.geometry.layout.menuItemHeight)",
				"dark": "s(theme.geometry.layout.menuItemHeight)",
				"ultraDark": "s(theme.geometry.layout.menuItemHeight)",
				"transparent": "s(theme.geometry.layout.menuItemHeight)"
			},
			"theme.components.cardRadius": {
				"light": "s(theme.shape.card)",
				"dark": "s(theme.shape.card)",
				"ultraDark": "s(theme.shape.card)",
				"transparent": "s(theme.shape.card)"
			},
			"theme.components.cardPadding": {
				"light": "s(theme.spacing.containerPadding)",
				"dark": "s(theme.spacing.containerPadding)",
				"ultraDark": "s(theme.spacing.containerPadding)",
				"transparent": "s(theme.spacing.containerPadding)"
			},
			"theme.components.badgeRadius": {
				"light": "s(theme.shape.pill)",
				"dark": "s(theme.shape.pill)",
				"ultraDark": "s(theme.shape.pill)",
				"transparent": "s(theme.shape.pill)"
			},
			"theme.components.badgePaddingX": {
				"light": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"dark": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"ultraDark": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"transparent": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))"
			},
			"theme.geometry.control.switchTrackWidth": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.switchTrackHeight": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.geometry.control.switchThumb": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.geometry.control.buttonHeightXSmall": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.geometry.control.buttonHeightSmall": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.control.buttonHeight": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.buttonHeightLarge": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.geometry.control.buttonHeightXLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.geometry.control.pageBackgroundHitRadius": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.presenceMarkerExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.colorPickerCursorRadius": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.swatchExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.segmentedProgressHeight": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.fieldHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.control.selectionControl": {
				"light": "p(length-15)",
				"dark": "p(length-15)",
				"ultraDark": "p(length-15)",
				"transparent": "p(length-15)"
			},
			"theme.geometry.control.selectionIndicatorInset": {
				"light": "p(length-3_5)",
				"dark": "p(length-3_5)",
				"ultraDark": "p(length-3_5)",
				"transparent": "p(length-3_5)"
			},
			"theme.geometry.control.selectionIcon": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.geometry.control.toggleWidth": {
				"light": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"dark": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"ultraDark": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"transparent": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))"
			},
			"theme.geometry.control.toggleHeight": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.geometry.control.toggleThumb": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.geometry.control.toggleInset": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.control.segmentedDenseHeight": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.geometry.control.segmentedDenseInset": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.geometry.control.segmentedDenseContentInset": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.geometry.control.segmentedDenseItemHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.control.slidingSelectionHeight": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.slidingSelectionSegmentWidth": {
				"light": "p(length-41_4)",
				"dark": "p(length-41_4)",
				"ultraDark": "p(length-41_4)",
				"transparent": "p(length-41_4)"
			},
			"theme.geometry.control.slidingSelectionPadding": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.geometry.control.slidingSelectionIndicatorHeight": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.geometry.control.scrollbarThickness": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.geometry.control.sliderTrackHeight": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.geometry.control.colorPlaneExtent": {
				"light": "p(length-168)",
				"dark": "p(length-168)",
				"ultraDark": "p(length-168)",
				"transparent": "p(length-168)"
			},
			"theme.geometry.control.textFieldIndicatorHeightFactor": {
				"light": "p(ratio-0_4)",
				"dark": "p(ratio-0_4)",
				"ultraDark": "p(ratio-0_4)",
				"transparent": "p(ratio-0_4)"
			},
			"theme.geometry.control.textFieldLineHeightFactor": {
				"light": "p(leading300)",
				"dark": "p(leading300)",
				"ultraDark": "p(leading300)",
				"transparent": "p(leading300)"
			},
			"theme.geometry.control.textFieldMinLines": {
				"light": "p(count-4)",
				"dark": "p(count-4)",
				"ultraDark": "p(count-4)",
				"transparent": "p(count-4)"
			},
			"theme.geometry.control.textFieldMaxLines": {
				"light": "p(count-8)",
				"dark": "p(count-8)",
				"ultraDark": "p(count-8)",
				"transparent": "p(count-8)"
			},
			"theme.geometry.control.fileExplorerRowHeightAdjustment": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.geometry.data.codeActionButtonSize": {
				"light": "p(length-26)",
				"dark": "p(length-26)",
				"ultraDark": "p(length-26)",
				"transparent": "p(length-26)"
			},
			"theme.geometry.data.codeHeaderHeight": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.data.codeTerminalDot": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.geometry.data.codeTerminalDotGap": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.geometry.data.codeHeaderPaddingX": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.geometry.data.codeBodyPaddingX": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.geometry.data.codeLineNumberWidth": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.data.codeWrappedLineWidth": {
				"light": "p(length-520)",
				"dark": "p(length-520)",
				"ultraDark": "p(length-520)",
				"transparent": "p(length-520)"
			},
			"theme.geometry.data.codeMaximumHeight": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.data.codeCollapsedHeight": {
				"light": "p(length-120)",
				"dark": "p(length-120)",
				"ultraDark": "p(length-120)",
				"transparent": "p(length-120)"
			},
			"theme.geometry.data.codeDisclosureSize": {
				"light": "p(length-9)",
				"dark": "p(length-9)",
				"ultraDark": "p(length-9)",
				"transparent": "p(length-9)"
			},
			"theme.geometry.data.filePreviewHeight": {
				"light": "p(length-220)",
				"dark": "p(length-220)",
				"ultraDark": "p(length-220)",
				"transparent": "p(length-220)"
			},
			"theme.geometry.data.previewCardCompactHeight": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.geometry.data.previewCardStandardHeight": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.geometry.data.previewCardLargeHeight": {
				"light": "p(length-192)",
				"dark": "p(length-192)",
				"ultraDark": "p(length-192)",
				"transparent": "p(length-192)"
			},
			"theme.geometry.data.dateGridCellHeight": {
				"light": "p(length-128)",
				"dark": "p(length-128)",
				"ultraDark": "p(length-128)",
				"transparent": "p(length-128)"
			},
			"theme.geometry.data.keyValueLabelWidthCompact": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.geometry.data.keyValueLabelWidthStandard": {
				"light": "p(length-112)",
				"dark": "p(length-112)",
				"ultraDark": "p(length-112)",
				"transparent": "p(length-112)"
			},
			"theme.geometry.data.stepperMarkerSize": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.data.stepperLabelWidth": {
				"light": "p(length-60)",
				"dark": "p(length-60)",
				"ultraDark": "p(length-60)",
				"transparent": "p(length-60)"
			},
			"theme.geometry.data.progressIndeterminateFraction": {
				"light": "p(ratio-0_35)",
				"dark": "p(ratio-0_35)",
				"ultraDark": "p(ratio-0_35)",
				"transparent": "p(ratio-0_35)"
			},
			"theme.geometry.data.placeholderMinimumHeight": {
				"light": "p(length-120)",
				"dark": "p(length-120)",
				"ultraDark": "p(length-120)",
				"transparent": "p(length-120)"
			},
			"theme.geometry.data.placeholderContentPaddingY": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.geometry.data.placeholderActionPaddingY": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.geometry.data.placeholderHatchBand": {
				"light": "p(length-10_5)",
				"dark": "p(length-10_5)",
				"ultraDark": "p(length-10_5)",
				"transparent": "p(length-10_5)"
			},
			"theme.geometry.data.placeholderHatchGap": {
				"light": "p(length-10_5)",
				"dark": "p(length-10_5)",
				"ultraDark": "p(length-10_5)",
				"transparent": "p(length-10_5)"
			},
			"theme.geometry.data.placeholderLabelTracking": {
				"light": "p(trackingWider)",
				"dark": "p(trackingWider)",
				"ultraDark": "p(trackingWider)",
				"transparent": "p(trackingWider)"
			},
			"theme.geometry.data.placeholderDetailMaximumWidth": {
				"light": "p(length-336)",
				"dark": "p(length-336)",
				"ultraDark": "p(length-336)",
				"transparent": "p(length-336)"
			},
			"theme.geometry.data.spinnerSquareFactor": {
				"light": "p(ratio-0_32)",
				"dark": "p(ratio-0_32)",
				"ultraDark": "p(ratio-0_32)",
				"transparent": "p(ratio-0_32)"
			},
			"theme.geometry.data.spinnerOrbitFactor": {
				"light": "p(ratio-0_22)",
				"dark": "p(ratio-0_22)",
				"ultraDark": "p(ratio-0_22)",
				"transparent": "p(ratio-0_22)"
			},
			"theme.geometry.data.spinnerCornerFactor": {
				"light": "p(ratio-0_06)",
				"dark": "p(ratio-0_06)",
				"ultraDark": "p(ratio-0_06)",
				"transparent": "p(ratio-0_06)"
			},
			"theme.geometry.layout.drawerWidth": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.layout.drawerHeight": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.layout.resizeHandleExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.overlayViewportInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.railDropTargetExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.disclosureIconSize": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.treeLeadingGap": {
				"light": "p(ratio-8)",
				"dark": "p(ratio-8)",
				"ultraDark": "p(ratio-8)",
				"transparent": "p(ratio-8)"
			},
			"theme.geometry.layout.tooltipOffsetX": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.primaryPaneWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.secondaryPaneWidth": {
				"light": "p(length-350)",
				"dark": "p(length-350)",
				"ultraDark": "p(length-350)",
				"transparent": "p(length-350)"
			},
			"theme.geometry.layout.primaryPaneBreakpoint": {
				"light": "p(length-400)",
				"dark": "p(length-400)",
				"ultraDark": "p(length-400)",
				"transparent": "p(length-400)"
			},
			"theme.geometry.layout.primaryPaneContentBreakpoint": {
				"light": "p(length-800)",
				"dark": "p(length-800)",
				"ultraDark": "p(length-800)",
				"transparent": "p(length-800)"
			},
			"theme.geometry.layout.responsivePaneBreakpoint": {
				"light": "p(length-960)",
				"dark": "p(length-960)",
				"ultraDark": "p(length-960)",
				"transparent": "p(length-960)"
			},
			"theme.geometry.layout.secondaryPaneBreakpoint": {
				"light": "p(length-1120)",
				"dark": "p(length-1120)",
				"ultraDark": "p(length-1120)",
				"transparent": "p(length-1120)"
			},
			"theme.geometry.layout.menuWidth": {
				"light": "p(length-200)",
				"dark": "p(length-200)",
				"ultraDark": "p(length-200)",
				"transparent": "p(length-200)"
			},
			"theme.geometry.layout.commandMenuWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.menuHeaderHeight": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.geometry.layout.menuItemHeight": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.geometry.layout.dialogMaximumWidth": {
				"light": "p(length-520)",
				"dark": "p(length-520)",
				"ultraDark": "p(length-520)",
				"transparent": "p(length-520)"
			},
			"theme.geometry.layout.toastMaximumWidth": {
				"light": "p(length-360)",
				"dark": "p(length-360)",
				"ultraDark": "p(length-360)",
				"transparent": "p(length-360)"
			},
			"theme.geometry.layout.inlineNoticeBreakpoint": {
				"light": "p(length-480)",
				"dark": "p(length-480)",
				"ultraDark": "p(length-480)",
				"transparent": "p(length-480)"
			},
			"theme.geometry.layout.statusBarBreakpoint": {
				"light": "p(length-400)",
				"dark": "p(length-400)",
				"ultraDark": "p(length-400)",
				"transparent": "p(length-400)"
			},
			"theme.geometry.layout.settingsDialogMaximumWidth": {
				"light": "p(length-1380)",
				"dark": "p(length-1380)",
				"ultraDark": "p(length-1380)",
				"transparent": "p(length-1380)"
			},
			"theme.geometry.layout.settingsDialogMaximumHeight": {
				"light": "p(length-880)",
				"dark": "p(length-880)",
				"ultraDark": "p(length-880)",
				"transparent": "p(length-880)"
			},
			"theme.geometry.layout.settingsPaneGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.settingsNavigationWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.settingsNavigationMinimumWidth": {
				"light": "p(length-260)",
				"dark": "p(length-260)",
				"ultraDark": "p(length-260)",
				"transparent": "p(length-260)"
			},
			"theme.geometry.layout.settingsNavigationMaximumWidth": {
				"light": "p(length-360)",
				"dark": "p(length-360)",
				"ultraDark": "p(length-360)",
				"transparent": "p(length-360)"
			},
			"theme.geometry.layout.settingsContentMaximumWidth": {
				"light": "p(length-820)",
				"dark": "p(length-820)",
				"ultraDark": "p(length-820)",
				"transparent": "p(length-820)"
			},
			"theme.geometry.layout.themePreviewTileWidth": {
				"light": "p(length-168)",
				"dark": "p(length-168)",
				"ultraDark": "p(length-168)",
				"transparent": "p(length-168)"
			},
			"theme.geometry.layout.windowHeaderHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.layout.windowHeaderControlSize": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.layout.windowAppIconSize": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.geometry.layout.windowIdentityGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.optical.menuIconOffsetY": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.optical.railBadgeInset": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.geometry.optical.statusIconOffsetY": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.optical.monoBaselineOffsetY": {
				"light": "p(length-minus-1)",
				"dark": "p(length-minus-1)",
				"ultraDark": "p(length-minus-1)",
				"transparent": "p(length-minus-1)"
			},
			"theme.geometry.optical.uiBaselineOffsetY": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.dataVisualization.series": {
				"light": "[p(sand500), p(gold500), p(ochre500), p(terracotta500), p(clay500), p(umber500)]",
				"dark": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]",
				"ultraDark": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]",
				"transparent": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]"
			},
			"theme.dataVisualization.seriesWash": {
				"light": "[p(sand50), p(gold50), p(ochre50), p(terracotta50), p(clay50), p(umber50)]",
				"dark": "[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]",
				"ultraDark": "[p(sand900), p(gold900), p(ochre900), p(terracotta900), p(clay900), p(umber900)]",
				"transparent": "[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]"
			},
			"theme.dataVisualization.axis": {
				"light": "p(warmNeutral100)",
				"dark": "p(warmNeutral700)",
				"ultraDark": "p(warmNeutral750)",
				"transparent": "p(warmNeutral700)"
			},
			"theme.dataVisualization.grid": {
				"light": "p(warmNeutral50)",
				"dark": "p(warmNeutral800)",
				"ultraDark": "p(warmNeutral900)",
				"transparent": "p(warmNeutral800)"
			},
			"theme.dataVisualization.gridStrong": {
				"light": "p(warmNeutral200)",
				"dark": "p(warmNeutral600)",
				"ultraDark": "p(warmNeutral700)",
				"transparent": "p(warmNeutral600)"
			},
			"theme.dataVisualization.label": {
				"light": "p(ink550)",
				"dark": "p(warmNeutral300)",
				"ultraDark": "p(warmNeutral300)",
				"transparent": "p(warmNeutral300)"
			},
			"theme.dataVisualization.value": {
				"light": "p(ink900)",
				"dark": "p(warmNeutral25)",
				"ultraDark": "p(warmNeutral25)",
				"transparent": "p(warmNeutral25)"
			},
			"theme.dataVisualization.plotBackground": {
				"light": "p(transparent)",
				"dark": "p(transparent)",
				"ultraDark": "p(transparent)",
				"transparent": "p(transparent)"
			},
			"theme.dataVisualization.crosshair": {
				"light": "p(warmNeutral450)",
				"dark": "p(warmNeutral400)",
				"ultraDark": "p(warmNeutral500)",
				"transparent": "p(warmNeutral400)"
			},
			"theme.dataVisualization.marketUp": {
				"light": "p(green600)",
				"dark": "p(green400)",
				"ultraDark": "p(green400)",
				"transparent": "p(green400)"
			},
			"theme.dataVisualization.marketUpWash": {
				"light": "p(green100)",
				"dark": "p(green800)",
				"ultraDark": "p(green900)",
				"transparent": "p(green800)"
			},
			"theme.dataVisualization.marketDown": {
				"light": "p(red600)",
				"dark": "p(red400)",
				"ultraDark": "p(red400)",
				"transparent": "p(red400)"
			},
			"theme.dataVisualization.marketDownWash": {
				"light": "p(red100)",
				"dark": "p(red800)",
				"ultraDark": "p(red900)",
				"transparent": "p(red800)"
			},
			"theme.dataVisualization.marketFlat": {
				"light": "p(warmNeutral450)",
				"dark": "p(warmNeutral400)",
				"ultraDark": "p(warmNeutral500)",
				"transparent": "p(warmNeutral400)"
			}
		},
		"recipes": {
			"app-background": {
				"aliases": "app background／應用背景／頁面背景",
				"inherit": "—",
				"parameters": "background=s(theme.colors.app); foreground=s(theme.colors.text); padding=p(space0); border=none; radius=s(theme.shape.none); size=產品決定; shadow=none"
			},
			"workspace-layout": {
				"aliases": "工作區間距／workspace layout",
				"inherit": "—",
				"parameters": "background=繼承 app-background.background; frame-inset=s(theme.spacing.space2); frame-gap=s(theme.spacing.space2); size=產品決定; border=none"
			},
			"surface-base": {
				"aliases": "一般／輔助表面／surface base",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-inset": {
				"aliases": "內嵌表面／surface inset",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-muted": {
				"aliases": "弱化表面／surface muted",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceMuted); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-component": {
				"aliases": "控制表面／surface component",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-overlay": {
				"aliases": "浮層表面／surface overlay",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-raised": {
				"aliases": "較亮表面／surface raised",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceRaised); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-stage": {
				"aliases": "主內容表面／surface stage",
				"inherit": "—",
				"parameters": "background=s(theme.colors.stageSurface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-accent": {
				"aliases": "強調表面／surface accent",
				"inherit": "—",
				"parameters": "background=s(theme.colors.accent); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-accent-soft": {
				"aliases": "柔和強調表面／surface accent-soft",
				"inherit": "—",
				"parameters": "background=s(theme.colors.accentSoft); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-transparent": {
				"aliases": "透明表面／surface transparent",
				"inherit": "—",
				"parameters": "background=s(theme.colors.transparent); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-frosted": {
				"aliases": "毛玻璃表面／frosted",
				"inherit": "surface-base",
				"parameters": "background=alpha(繼承.background,s(theme.surface.frostedOpacity)); blur-sigma=s(theme.surface.backdropBlurSigma); geometry=繼承"
			},
			"text-tone-primary": {
				"aliases": "主文字色／primary text／prominent",
				"inherit": "—",
				"parameters": "color=s(theme.colors.text); typography=繼承父層; padding/border=不適用; size=內容決定"
			},
			"text-tone-muted": {
				"aliases": "次要文字／說明文字／muted",
				"inherit": "text-tone-primary",
				"parameters": "color=s(theme.colors.textMuted)"
			},
			"text-tone-faint": {
				"aliases": "弱化文字／提示文字色／faint",
				"inherit": "text-tone-primary",
				"parameters": "color=s(theme.colors.textFaint)"
			},
			"text-display": {
				"aliases": "展示大字／text display",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.display); line-height=s(theme.typography.displayLeading); font-weight=s(theme.typography.bold); letter-spacing=s(theme.typography.displayTracking); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h1": {
				"aliases": "一級標題／text h1",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h1); line-height=s(theme.typography.h1Leading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h2": {
				"aliases": "二級標題／text h2",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h2); line-height=s(theme.typography.h2Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h3": {
				"aliases": "三級標題／text h3",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h3); line-height=s(theme.typography.h3Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h4": {
				"aliases": "四級標題／text h4",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h4); line-height=s(theme.typography.h4Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-lead": {
				"aliases": "導言／text lead",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.lead); line-height=s(theme.typography.leadLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-body": {
				"aliases": "正文／內文／text body",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-sub": {
				"aliases": "副正文／text sub",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.subLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-caption": {
				"aliases": "註解小字／text caption",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-caption-strong": {
				"aliases": "強調小字／text captionStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-mono-caption-strong": {
				"aliases": "等寬強調小字／text monoCaptionStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-micro": {
				"aliases": "極小字／text micro",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.micro); line-height=s(theme.typography.microLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-title": {
				"aliases": "頁面標題／text title",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.title); line-height=s(theme.typography.h1Leading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-section": {
				"aliases": "區段標題／text section",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.section); line-height=s(theme.typography.h3Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-editor": {
				"aliases": "編輯文字／text editor",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.bodyFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-terminal": {
				"aliases": "終端文字／text terminal",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-body-strong": {
				"aliases": "強調正文／text bodyStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-app-title": {
				"aliases": "應用名稱／text appTitle",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.labelLeading); font-weight=p(weight500); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-header": {
				"aliases": "Header文字／text header",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-status": {
				"aliases": "狀態列文字／text status",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.codeLeading); font-weight=p(weight500); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-label": {
				"aliases": "控制標籤／text label",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.labelLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-code": {
				"aliases": "程式碼／路徑文字／text code",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.codeLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"button-base": {
				"aliases": "按鈕共用幾何",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); padding-x=s(theme.components.buttonPaddingX); padding-y=p(space0); height=s(theme.components.buttonHeight); width=內容決定; radius=s(theme.components.buttonRadius); border-width=s(theme.components.buttonBorderWidth); border-color=s(theme.colors.border); border-style=solid（width=0 時none）; gap=s(theme.spacing.controlContentGap); typography=s(text-body); shadow=none; transition=s(theme.motion.stateTransition); curve=s(theme.motion.standard)"
			},
			"button-primary": {
				"aliases": "主要按鈕／主操作／button primary",
				"inherit": "button-base",
				"parameters": "background=opaque(s(theme.colors.brand)); foreground=primaryForeground(background); typography=s(text-body-strong)"
			},
			"button-secondary": {
				"aliases": "次要按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); typography=s(text-body)"
			},
			"button-ghost": {
				"aliases": "透明按鈕／幽靈按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.text); typography=s(text-body)"
			},
			"button-danger": {
				"aliases": "危險按鈕／刪除按鈕",
				"inherit": "button-base",
				"parameters": "background=alpha(s(theme.colors.danger),s(theme.surface.statusFillOpacity)); foreground=s(theme.colors.danger); typography=s(text-body)"
			},
			"button-dashed": {
				"aliases": "裝飾虛線按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.text); typography=s(text-body); decoration=dashed; dash-color=s(theme.colors.guide); dash-width=s(theme.shape.hairline); dash-length=s(theme.shape.dashedLength); dash-gap=s(theme.shape.dashedGap); dash-opacity=s(theme.shape.dashedOpacity)"
			},
			"button-size-xs": {
				"aliases": "按鈕 xs",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightXSmall); padding-x=s(theme.spacing.controlInset); padding-y=p(space0); typography=s(text-caption); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-sm": {
				"aliases": "按鈕 sm",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightSmall); padding-x=s(theme.spacing.controlPaddingXSmall); padding-y=p(space0); typography=s(text-caption); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-md": {
				"aliases": "按鈕 md",
				"inherit": "button-base",
				"parameters": "height=s(theme.components.buttonHeight); padding-x=s(theme.components.buttonPaddingX); padding-y=p(space0); typography=s(text-body); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-lg": {
				"aliases": "按鈕 lg",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightLarge); padding-x=s(theme.spacing.controlPaddingXLarge); padding-y=p(space0); typography=s(text-lead); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-xl": {
				"aliases": "按鈕 xl",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightXLarge); padding-x=s(theme.spacing.controlPaddingXXLarge); padding-y=p(space0); typography=s(text-lead); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-hover": {
				"aliases": "按鈕 hover／focus",
				"inherit": "繼承目前 button-*",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),繼承.background); primary特例=以primaryForeground(繼承.background)取代疊色text; foreground=primary時依新背景重新算，其他繼承; geometry=繼承"
			},
			"button-selected": {
				"aliases": "按鈕 selected",
				"inherit": "繼承目前 button-*",
				"parameters": "background=over(alpha(s(theme.colors.interaction),s(theme.surface.focusWashOpacity)),繼承.background); primary特例=以primaryForeground(繼承.background)取代疊色interaction; foreground=primary時依新背景重新算，其他繼承; geometry=繼承"
			},
			"button-disabled": {
				"aliases": "停用按鈕",
				"inherit": "繼承目前 button-*",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=s(theme.colors.textFaint); hover/selected=不套用; geometry=繼承"
			},
			"icon-button": {
				"aliases": "獨立圖示按鈕／icon button",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); width=s(theme.spacing.iconButton); height=s(theme.spacing.iconButton); radius=s(theme.shape.control); padding=無額外padding，圖示置中; icon-size=s(theme.spacing.iconBase); border=none; shadow=none"
			},
			"icon-button-inline": {
				"aliases": "行內圖示按鈕",
				"inherit": "icon-button",
				"parameters": "background=s(theme.colors.transparent)"
			},
			"icon-button-window": {
				"aliases": "視窗控制圖示按鈕",
				"inherit": "icon-button",
				"parameters": "width=s(theme.geometry.layout.windowHeaderControlSize); height=s(theme.geometry.layout.windowHeaderControlSize)"
			},
			"icon-button-hover": {
				"aliases": "圖示按鈕 hover／focus",
				"inherit": "繼承目前 icon-button*",
				"parameters": "background=over(alpha(s(theme.colors.text),byBrightness(s(theme.surface.focusWashOpacity),s(theme.surface.selectionWashOpacity))),s(theme.colors.component)); geometry/foreground=繼承"
			},
			"icon-button-selected": {
				"aliases": "圖示按鈕 selected",
				"inherit": "繼承目前 icon-button*",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text); geometry=繼承"
			},
			"icon-button-disabled": {
				"aliases": "停用圖示按鈕",
				"inherit": "繼承目前 icon-button*",
				"parameters": "foreground=s(theme.colors.textFaint); background=selected時s(theme.colors.interactionSoft)，否則繼承rest; hover=不套用; geometry=繼承"
			},
			"field-base": {
				"aliases": "輸入框／文字輸入欄位／text field",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=s(theme.colors.text); placeholder=s(theme.colors.textFaint); icon-color=s(theme.colors.textMuted); cursor-color=s(theme.colors.interaction); height=s(theme.components.fieldHeight); width=產品決定; padding-x=s(theme.components.fieldPaddingX); padding-y=div(sub(height,mul(font-size,s(theme.geometry.control.textFieldLineHeightFactor))),p(ratio-2)); radius=s(theme.components.fieldRadius); border-width=s(theme.components.fieldBorderWidth); border-color=s(theme.colors.border); border-style=solid（width=0時none）; font-size=s(theme.typography.body); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); line-height=s(theme.typography.captionLeading); shadow=none"
			},
			"field-size-xs": {
				"aliases": "輸入框 xs",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightXSmall); font-size=s(theme.typography.caption); padding-x=s(theme.spacing.tight); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-sm": {
				"aliases": "輸入框 sm",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightSmall); font-size=s(theme.typography.sub); padding-x=s(theme.spacing.tight); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-md": {
				"aliases": "輸入框 md",
				"inherit": "field-base",
				"parameters": "height=s(theme.components.fieldHeight); font-size=s(theme.typography.body); padding-x=s(theme.components.fieldPaddingX); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-lg": {
				"aliases": "輸入框 lg",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightLarge); font-size=s(theme.typography.lead); padding-x=s(theme.spacing.base); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-xl": {
				"aliases": "輸入框 xl",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightXLarge); font-size=s(theme.typography.lead); padding-x=s(theme.spacing.comfortable); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-hover": {
				"aliases": "懸停輸入框",
				"inherit": "field-base",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),s(theme.colors.surfaceInset));  geometry=繼承"
			},
			"field-focused": {
				"aliases": "聚焦／選取輸入框",
				"inherit": "field-base",
				"parameters": "background=over(alpha(s(theme.colors.interaction),s(theme.surface.focusWashOpacity)),s(theme.colors.surfaceInset));  focus-indicator=inset(s(theme.shape.stroke),s(theme.colors.interaction)); outer-outline=none; geometry=繼承（含焦點提示不增加外徑）"
			},
			"field-error": {
				"aliases": "錯誤輸入框",
				"inherit": "field-base",
				"parameters": "background=alpha(s(theme.colors.danger),s(theme.surface.invalidFillOpacity));  geometry=繼承"
			},
			"field-disabled": {
				"aliases": "停用輸入框",
				"inherit": "field-base",
				"parameters": "background=s(theme.colors.surfaceMuted); foreground=s(theme.colors.textFaint); icon-color=s(theme.colors.textFaint); geometry=繼承"
			},
			"field-outlined": {
				"aliases": "有邊框輸入框",
				"inherit": "field-base",
				"parameters": "border-width=max(繼承.border-width,s(theme.shape.stroke)); border-color=focused時s(theme.colors.interaction)，否則s(theme.colors.border); geometry=繼承"
			},
			"field-multiline": {
				"aliases": "多行輸入框／textarea",
				"inherit": "field-base",
				"parameters": "height=內容決定; padding-y=s(theme.spacing.controlPaddingY); min-lines=s(theme.geometry.control.textFieldMinLines); max-lines=s(theme.geometry.control.textFieldMaxLines); alignment=top-left"
			},
			"card": {
				"aliases": "卡片／內容卡片",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=繼承文字角色; radius=s(theme.components.cardRadius); header-padding=s(theme.components.cardPadding); content-padding=s(theme.components.cardPadding); footer-padding=s(theme.spacing.contentInset); title=s(text-body-strong); label=s(text-label); gap=s(theme.spacing.contentInlineGap); border=none; shadow=none; size=產品決定"
			},
			"card-surface": {
				"aliases": "卡片 surface",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surface); shadow=none（raised只改底色）"
			},
			"card-muted": {
				"aliases": "卡片 muted",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surfaceMuted); shadow=none（raised只改底色）"
			},
			"card-raised": {
				"aliases": "卡片 raised",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surfaceRaised); shadow=none（raised只改底色）"
			},
			"card-selected": {
				"aliases": "選取卡片",
				"inherit": "繼承目前 card*",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),繼承.background); geometry=繼承"
			},
			"badge-base": {
				"aliases": "狀態標記共用幾何／badge",
				"inherit": "—",
				"parameters": "padding-x=s(theme.components.badgePaddingX); padding-y=s(theme.spacing.space0_5); radius=s(theme.components.badgeRadius); typography=s(text-caption); size=內容決定; text-transform=uppercase; dot-size=s(theme.spacing.indicatorDot); dot-gap=s(theme.spacing.tight); shadow=none; tone-color=neutral時s(theme.colors.textMuted)，其他取status-*"
			},
			"badge-neutral": {
				"aliases": "中性標記／filled neutral",
				"inherit": "badge-base",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); border-width=p(space0); border-style=none"
			},
			"badge-status": {
				"aliases": "語意色標記／filled status",
				"inherit": "badge-base",
				"parameters": "background=over(alpha(tone-color,s(theme.surface.statusFillOpacity)),opaque(s(theme.colors.component))); foreground=s(theme.colors.text); border=none; shadow=s(effect-frame-relief)"
			},
			"badge-outline": {
				"aliases": "描邊標記",
				"inherit": "badge-base",
				"parameters": "background=none; foreground=tone-color; border-width=s(theme.shape.hairline); border-color=tone-color; border-style=solid"
			},
			"badge-solid": {
				"aliases": "實底標記",
				"inherit": "badge-base",
				"parameters": "background=s(theme.colors.text); foreground=s(theme.colors.stageSurface); border=none"
			},
			"status-success": {
				"aliases": "成功／完成",
				"inherit": "—",
				"parameters": "color=s(theme.colors.success); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-warning": {
				"aliases": "警告",
				"inherit": "—",
				"parameters": "color=s(theme.colors.warning); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-danger": {
				"aliases": "危險／錯誤／破壞性操作",
				"inherit": "—",
				"parameters": "color=s(theme.colors.danger); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-info": {
				"aliases": "資訊",
				"inherit": "—",
				"parameters": "color=s(theme.colors.info); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"frame": {
				"aliases": "內容Frame／app frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); padding=p(space0); radius=s(theme.shape.panel); border=none; shadow=none; size=父布局分配; outer-gap=繼承workspace-layout.frame-gap"
			},
			"frame-sidebar": {
				"aliases": "側欄Frame",
				"inherit": "frame",
				"parameters": "background=s(theme.colors.surfaceInset); width=s(theme.geometry.layout.primaryPaneWidth)"
			},
			"frame-auxiliary": {
				"aliases": "輔助Frame",
				"inherit": "frame",
				"parameters": "background=s(theme.colors.surfaceInset)"
			},
			"frame-right-sidebar": {
				"aliases": "右側欄Frame",
				"inherit": "frame",
				"parameters": "background=繼承父層; radius=不適用; shadow=none; width=s(theme.geometry.layout.secondaryPaneWidth); decoration=none（bare）"
			},
			"frame-toolbar-controls": {
				"aliases": "工具控制區Frame",
				"inherit": "frame",
				"parameters": "background=繼承父層; radius=不適用; shadow=none; width=add(mul(s(theme.spacing.space8),p(ratio-3)),mul(s(theme.spacing.space1),p(ratio-6))); decoration=none（bare）"
			},
			"frame-raised": {
				"aliases": "微立體Frame",
				"inherit": "繼承目前 frame*",
				"parameters": "shadow=s(effect-frame-relief); bare角色=不套用; geometry=繼承"
			},
			"panel-frame": {
				"aliases": "面板框架／panel frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); outer-margin=s(theme.spacing.dockMargin); padding=p(space0); radius=s(theme.shape.card); clip-radius=sub(s(theme.shape.card),s(theme.shape.stroke)); header-height=s(theme.spacing.chromeHeader); footer-height=s(theme.spacing.chromeStatusBar); border=none; shadow=none; size=父布局分配"
			},
			"panel-frame-stage": {
				"aliases": "主內容面板框架",
				"inherit": "panel-frame",
				"parameters": "background=s(theme.colors.stageSurface)"
			},
			"panel-frame-dock": {
				"aliases": "Dock面板標題尺度",
				"inherit": "panel-frame",
				"parameters": "header-height=s(theme.spacing.chromeTab)"
			},
			"panel-frame-raised": {
				"aliases": "微立體面板",
				"inherit": "繼承目前 panel-frame*",
				"parameters": "shadow=s(effect-frame-relief)"
			},
			"stage-frame": {
				"aliases": "舞台容器／stage frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.stageSurface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=不適用; shadow=none; header-min-height=s(theme.spacing.chromeHeader); status-height=s(theme.spacing.chromeStatusBar); size=父布局分配"
			},
			"explorer-row": {
				"aliases": "Explorer資料列／檔案列",
				"inherit": "—",
				"parameters": "background=繼承父層; foreground=s(theme.colors.text); height=add(s(theme.spacing.controlHeightXSmall),s(theme.geometry.control.fileExplorerRowHeightAdjustment)); row-padding-end=s(theme.spacing.tight); icon-size=s(theme.spacing.iconSmall); icon-color=s(theme.colors.textMuted); icon-gap=s(theme.spacing.contentInlineGap); typography=s(text-code); leading-width=add(s(theme.spacing.iconSmall),s(theme.geometry.layout.treeLeadingGap)); indent=mul(level,s(theme.spacing.tight)); outer-padding-x=s(theme.spacing.navigationItemInset); outer-padding-y=s(theme.spacing.hairline); border=none; shadow=none; width=父布局分配"
			},
			"explorer-folder-row": {
				"aliases": "Explorer資料夾列",
				"inherit": "explorer-row",
				"parameters": "height=s(theme.spacing.controlHeightXSmall); disclosure=產品選用圖示"
			},
			"explorer-row-hover": {
				"aliases": "Explorer懸停資料列",
				"inherit": "explorer-row",
				"parameters": "overlay=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)); overlay-radius=s(theme.shape.control); geometry=繼承"
			},
			"explorer-row-selected": {
				"aliases": "Explorer選取資料列",
				"inherit": "explorer-row-hover",
				"parameters": "icon-color=s(theme.colors.text); overlay=繼承（hover／selected同色）；不新增虛線框"
			},
			"explorer-spacing-relaxed": {
				"aliases": "較寬樹狀節奏",
				"inherit": "explorer-row",
				"parameters": "indent=mul(level,s(theme.spacing.base))"
			},
			"explorer-spacing-flush": {
				"aliases": "貼齊Explorer／flush",
				"inherit": "explorer-row",
				"parameters": "outer-padding-x=p(space0); outer-padding-y=p(space0); section-margin-x=s(theme.spacing.hairline)"
			},
			"action-region": {
				"aliases": "可操作資料區域",
				"inherit": "—",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.textMuted); radius=s(theme.shape.card); padding/size=繼承所屬元件; border=none; shadow=none"
			},
			"action-region-hover": {
				"aliases": "可操作資料區域hover／focus",
				"inherit": "action-region",
				"parameters": "background=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity))"
			},
			"action-region-selected": {
				"aliases": "可操作資料區域selected",
				"inherit": "action-region",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text)"
			},
			"action-region-destructive": {
				"aliases": "破壞性可操作區域",
				"inherit": "action-region",
				"parameters": "foreground=s(theme.colors.danger); active-background=s(theme.colors.danger); active-foreground=s(theme.colors.onStatus)"
			},
			"menu": {
				"aliases": "彈出選單／menu panel",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=backgroundForeground(background); padding=s(theme.spacing.tight); radius=s(theme.components.menuRadius); width-base=s(theme.geometry.layout.menuWidth); width=依項目量測／scrollable選項，基準width-base; border-width=s(theme.shape.hairline); border-style=dashed; border-color=s(theme.colors.divider); shadow=s(effect-menu-shadow)"
			},
			"menu-item": {
				"aliases": "選單項目",
				"inherit": "action-region",
				"parameters": "radius=s(theme.shape.control); height=s(theme.components.menuItemHeight); padding-x=s(theme.components.menuPadding); padding-y=p(space0); typography=s(text-label); icon-size=s(theme.spacing.iconSmall); gap=s(theme.spacing.overlayItemGap); icon-optical-y=s(theme.geometry.optical.menuIconOffsetY)"
			},
			"menu-item-description": {
				"aliases": "附說明選單項目",
				"inherit": "menu-item",
				"parameters": "height=mul(s(theme.components.menuItemHeight),p(ratio-2)); description=s(text-caption); description-color=s(theme.colors.textMuted)"
			},
			"menu-item-selected": {
				"aliases": "選取選單項目",
				"inherit": "menu-item",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text)"
			},
			"menu-item-hover": {
				"aliases": "選單hover／keyboard focus",
				"inherit": "menu-item",
				"parameters": "background=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity))"
			},
			"menu-item-danger": {
				"aliases": "危險選單項目",
				"inherit": "menu-item",
				"parameters": "foreground=s(theme.colors.danger); active-background=s(theme.colors.danger); active-foreground=s(theme.colors.onStatus)"
			},
			"dialog": {
				"aliases": "對話框",
				"inherit": "surface-base",
				"parameters": "radius=s(theme.shape.panel); max-width=s(theme.geometry.layout.dialogMaximumWidth); heading-padding=s(theme.spacing.loose); content-padding=s(theme.spacing.loose); actions-padding=s(theme.spacing.base); heading-gap=s(theme.spacing.overlayHeadingGap); action-gap=s(theme.spacing.actionGap); title=s(text-title); label=s(text-label); primary-action=s(button-primary); secondary-action=s(button-ghost); border-width=s(theme.shape.hairline); border-style=dashed; border-color=s(theme.colors.divider); shadow=微立體; positioning/scrim=產品彈出宿主決定"
			},
			"scrollbar": {
				"aliases": "捲軸",
				"inherit": "—",
				"parameters": "thumb-color=s(theme.colors.textFaint); track-color=s(theme.colors.transparent); track-border-color=s(theme.colors.transparent); thickness=s(theme.geometry.control.scrollbarThickness); radius=s(theme.shape.pill); track-visible=false; length/padding=宿主決定"
			},
			"tooltip": {
				"aliases": "工具提示",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=s(theme.colors.textMuted); radius=s(theme.shape.control); padding-x=s(theme.spacing.overlayContentInset); padding-y=s(theme.spacing.tight); font-family=s(theme.typography.uiFamily); font-size=s(theme.typography.caption); border=none; delay=s(theme.motion.tooltipDelay); dwell=s(theme.motion.tooltipDwell); prefer-below=false; size=內容決定"
			},
			"effect-paper-shadow": {
				"aliases": "紙片雙層陰影／overlayShadow",
				"inherit": "—",
				"parameters": "contact=color alpha(s(theme.surface.overlayShadowColor),s(theme.surface.contactShadowOpacity)), offset(p(space0),s(theme.surface.contactOffsetY)), blur=s(theme.surface.contactBlur), spread=p(space0); ambient=color alpha(s(theme.surface.overlayShadowColor),s(theme.surface.overlayShadowOpacity)), offset(p(space0),s(theme.surface.overlayOffsetY)), blur=s(theme.surface.overlayBlur), spread=s(theme.surface.overlaySpread); enabled=theme.surface.separation=shadow，其餘none"
			},
			"effect-menu-shadow": {
				"aliases": "選單專用單層陰影",
				"inherit": "—",
				"parameters": "color=alpha(s(theme.colors.modalScrim),s(theme.surface.overlayShadowOpacity)); offset=(p(space0),s(theme.surface.overlayOffsetY)); blur=s(theme.surface.overlayBlur); spread=s(theme.surface.overlaySpread); 不增加接觸層"
			},
			"effect-frame-relief": {
				"aliases": "Frame微立體陰影與亮邊",
				"inherit": "—",
				"parameters": "scale=div(s(theme.spacing.space1),p(space100)); dark=surface.R/G/B全部小於100; shadow-rgb=s(theme.surface.overlayShadowColor); shadow-alpha=dark?p(opacity-0_47843137254901963):p(opacity-0_1803921568627451); shadow-offset=(mul(p(space50),scale),mul(p(length-3),scale)); blur=mul(p(length-5),scale); spread=mul(p(length-minus-1),scale); highlight-rgb=p(ink50); highlight-alpha=dark?p(opacity-0_07058823529411765):p(opacity-0_8509803921568627); highlight-offset=(mul(p(length-minus-1),scale),mul(p(length-minus-1),scale)); highlight-blur=p(space0); 陰影在裁切之外"
			},
			"motion-reduced": {
				"aliases": "減少動態效果",
				"inherit": "—",
				"parameters": "state-transition=p(duration0); overlay-enter=p(duration0); overlay-exit=p(duration0); 其他=繼承theme.motion"
			}
		},
		"primitiveDescriptions": {
			"parchment50": "現有公開primitive",
			"parchment75": "現有公開primitive",
			"parchment100": "現有公開primitive",
			"parchment150": "現有公開primitive",
			"parchment200": "現有公開primitive",
			"parchment250": "現有公開primitive",
			"parchment350": "現有公開primitive",
			"parchment550": "現有公開primitive",
			"parchment700": "現有公開primitive",
			"parchment750": "現有公開primitive",
			"parchment800": "現有公開primitive",
			"parchment825": "現有公開primitive",
			"parchment900": "現有公開primitive",
			"parchment925": "現有公開primitive",
			"parchment950": "現有公開primitive",
			"ink1000": "現有公開primitive",
			"transparent": "現有公開primitive",
			"ink50": "現有公開primitive",
			"ink100": "現有公開primitive",
			"ink150": "現有公開primitive",
			"ink200": "現有公開primitive",
			"ink250": "現有公開primitive",
			"ink300": "現有公開primitive",
			"ink350": "現有公開primitive",
			"ink400": "現有公開primitive",
			"ink450": "現有公開primitive",
			"ink500": "現有公開primitive",
			"ink550": "現有公開primitive",
			"ink600": "現有公開primitive",
			"ink650": "現有公開primitive",
			"ink700": "現有公開primitive",
			"ink750": "現有公開primitive",
			"ink800": "現有公開primitive",
			"ink850": "現有公開primitive",
			"ink900": "現有公開primitive",
			"ink950": "現有公開primitive",
			"warmNeutral25": "現有公開primitive",
			"warmNeutral50": "現有公開primitive",
			"warmNeutral100": "現有公開primitive",
			"warmNeutral200": "現有公開primitive",
			"warmNeutral300": "現有公開primitive",
			"warmNeutral400": "現有公開primitive",
			"warmNeutral450": "現有公開primitive",
			"warmNeutral500": "現有公開primitive",
			"warmNeutral600": "現有公開primitive",
			"warmNeutral700": "現有公開primitive",
			"warmNeutral750": "現有公開primitive",
			"warmNeutral800": "現有公開primitive",
			"warmNeutral900": "現有公開primitive",
			"sand50": "現有公開primitive",
			"sand300": "現有公開primitive",
			"sand500": "現有公開primitive",
			"sand800": "現有公開primitive",
			"sand900": "現有公開primitive",
			"gold50": "現有公開primitive",
			"gold300": "現有公開primitive",
			"gold500": "現有公開primitive",
			"gold800": "現有公開primitive",
			"gold900": "現有公開primitive",
			"ochre50": "現有公開primitive",
			"ochre300": "現有公開primitive",
			"ochre500": "現有公開primitive",
			"ochre800": "現有公開primitive",
			"ochre900": "現有公開primitive",
			"terracotta50": "現有公開primitive",
			"terracotta300": "現有公開primitive",
			"terracotta500": "現有公開primitive",
			"terracotta800": "現有公開primitive",
			"terracotta900": "現有公開primitive",
			"clay50": "現有公開primitive",
			"clay300": "現有公開primitive",
			"clay500": "現有公開primitive",
			"clay800": "現有公開primitive",
			"clay900": "現有公開primitive",
			"umber50": "現有公開primitive",
			"umber300": "現有公開primitive",
			"umber500": "現有公開primitive",
			"umber800": "現有公開primitive",
			"umber900": "現有公開primitive",
			"green100": "現有公開primitive",
			"green400": "現有公開primitive",
			"green500": "現有公開primitive",
			"green600": "現有公開primitive",
			"green800": "現有公開primitive",
			"green900": "現有公開primitive",
			"red100": "現有公開primitive",
			"red300": "現有公開primitive",
			"red400": "現有公開primitive",
			"red600": "現有公開primitive",
			"red800": "現有公開primitive",
			"red900": "現有公開primitive",
			"amber500": "現有公開primitive",
			"blue500": "現有公開primitive",
			"scrim": "現有公開primitive",
			"line": "現有公開primitive",
			"transparentSurface": "現有公開primitive",
			"transparentSurfaceInset": "現有公開primitive",
			"pureWhite": "現有公開primitive",
			"pureBlack": "現有公開primitive",
			"accent-ink-light": "現有accent配對原料",
			"accent-ink-dark": "現有accent配對原料",
			"accent-terracotta-light": "現有accent配對原料",
			"accent-terracotta-dark": "現有accent配對原料",
			"accent-ochre-light": "現有accent配對原料",
			"accent-ochre-dark": "現有accent配對原料",
			"accent-olive-light": "現有accent配對原料",
			"accent-olive-dark": "現有accent配對原料",
			"accent-slate-light": "現有accent配對原料",
			"accent-slate-dark": "現有accent配對原料",
			"accent-crimson-light": "現有accent配對原料",
			"accent-crimson-dark": "現有accent配對原料",
			"color-b8292724": "原實作值的文件名稱；未新增設計",
			"color-b835322d": "原實作值的文件名稱；未新增設計",
			"space0": "現有公開primitive",
			"space50": "現有公開primitive",
			"space100": "現有公開primitive",
			"space200": "現有公開primitive",
			"space250": "現有公開primitive",
			"space300": "現有公開primitive",
			"space400": "現有公開primitive",
			"space600": "現有公開primitive",
			"space800": "現有公開primitive",
			"space1000": "現有公開primitive",
			"space1200": "現有公開primitive",
			"space1600": "現有公開primitive",
			"space2400": "現有公開primitive",
			"radius0": "現有公開primitive",
			"radius50": "現有公開primitive",
			"radius100": "現有公開primitive",
			"radius150": "現有公開primitive",
			"radius200": "現有公開primitive",
			"radius250": "現有公開primitive",
			"radius300": "現有公開primitive",
			"radius400": "現有公開primitive",
			"radiusFull": "現有公開primitive",
			"stroke0": "現有公開primitive",
			"stroke100": "現有公開primitive",
			"stroke200": "現有公開primitive",
			"font100": "現有公開primitive",
			"font200": "現有公開primitive",
			"font300": "現有公開primitive",
			"font400": "現有公開primitive",
			"font500": "現有公開primitive",
			"font600": "現有公開primitive",
			"font700": "現有公開primitive",
			"font800": "現有公開primitive",
			"font900": "現有公開primitive",
			"font1000": "現有公開primitive",
			"tracking0": "現有公開primitive",
			"trackingTight": "現有公開primitive",
			"trackingWide": "現有公開primitive",
			"trackingWider": "現有公開primitive",
			"length-30": "原實作值的文件名稱；未新增設計",
			"length-56": "原實作值的文件名稱；未新增設計",
			"length-20": "原實作值的文件名稱；未新增設計",
			"length-60": "原實作值的文件名稱；未新增設計",
			"length-74": "原實作值的文件名稱；未新增設計",
			"length-170": "原實作值的文件名稱；未新增設計",
			"length-11": "原實作值的文件名稱；未新增設計",
			"length-3": "原實作值的文件名稱；未新增設計",
			"length-5": "原實作值的文件名稱；未新增設計",
			"length-7": "原實作值的文件名稱；未新增設計",
			"length-3_5": "原實作值的文件名稱；未新增設計",
			"length-41_4": "原實作值的文件名稱；未新增設計",
			"length-168": "原實作值的文件名稱；未新增設計",
			"length-26": "原實作值的文件名稱；未新增設計",
			"length-520": "原實作值的文件名稱；未新增設計",
			"length-320": "原實作值的文件名稱；未新增設計",
			"length-120": "原實作值的文件名稱；未新增設計",
			"length-9": "原實作值的文件名稱；未新增設計",
			"length-220": "原實作值的文件名稱；未新增設計",
			"length-192": "原實作值的文件名稱；未新增設計",
			"length-128": "原實作值的文件名稱；未新增設計",
			"length-112": "原實作值的文件名稱；未新增設計",
			"length-10_5": "原實作值的文件名稱；未新增設計",
			"length-336": "原實作值的文件名稱；未新增設計",
			"length-300": "原實作值的文件名稱；未新增設計",
			"length-350": "原實作值的文件名稱；未新增設計",
			"length-400": "原實作值的文件名稱；未新增設計",
			"length-800": "原實作值的文件名稱；未新增設計",
			"length-960": "原實作值的文件名稱；未新增設計",
			"length-1120": "原實作值的文件名稱；未新增設計",
			"length-200": "原實作值的文件名稱；未新增設計",
			"length-360": "原實作值的文件名稱；未新增設計",
			"length-480": "原實作值的文件名稱；未新增設計",
			"length-1380": "原實作值的文件名稱；未新增設計",
			"length-880": "原實作值的文件名稱；未新增設計",
			"length-260": "原實作值的文件名稱；未新增設計",
			"length-820": "原實作值的文件名稱；未新增設計",
			"length-minus-1": "原實作值的文件名稱；未新增設計",
			"leading100": "現有公開primitive",
			"leading116": "現有公開primitive",
			"leading120": "現有公開primitive",
			"leading122": "現有公開primitive",
			"leading127": "現有公開primitive",
			"leading128": "現有公開primitive",
			"leading133": "現有公開primitive",
			"leading142": "現有公開primitive",
			"leading150": "現有公開primitive",
			"leading155": "現有公開primitive",
			"leading150Legacy": "現有公開primitive",
			"leading200": "現有公開primitive",
			"leading300": "現有公開primitive",
			"leading350": "現有公開primitive",
			"leading400": "現有公開primitive",
			"leading450": "現有公開primitive",
			"leading500": "現有公開primitive",
			"leading550": "現有公開primitive",
			"leading650": "現有公開primitive",
			"ratio-0_4": "原實作值的文件名稱；未新增設計",
			"ratio-0_35": "原實作值的文件名稱；未新增設計",
			"ratio-0_32": "原實作值的文件名稱；未新增設計",
			"ratio-0_22": "原實作值的文件名稱；未新增設計",
			"ratio-0_06": "原實作值的文件名稱；未新增設計",
			"ratio-8": "原實作值的文件名稱；未新增設計",
			"ratio-2": "原實作值的文件名稱；未新增設計",
			"ratio-3": "原實作值的文件名稱；未新增設計",
			"ratio-6": "原實作值的文件名稱；未新增設計",
			"weight400": "現有公開primitive",
			"weight500": "現有公開primitive",
			"weight600": "現有公開primitive",
			"weight700": "現有公開primitive",
			"weight800": "現有公開primitive",
			"duration0": "現有公開primitive",
			"duration100": "現有公開primitive",
			"duration150": "現有公開primitive",
			"duration400": "現有公開primitive",
			"duration500": "現有公開primitive",
			"duration-4000": "原實作值的文件名稱；未新增設計",
			"duration-1000": "原實作值的文件名稱；未新增設計",
			"easeStandard": "現有公開primitive",
			"easeEmphasized": "現有公開primitive",
			"opacity100": "現有公開primitive",
			"opacity120": "現有公開primitive",
			"opacity140": "現有公開primitive",
			"opacity160": "現有公開primitive",
			"opacity180": "現有公開primitive",
			"opacity220": "現有公開primitive",
			"opacity280": "現有公開primitive",
			"opacity320": "現有公開primitive",
			"opacity350": "現有公開primitive",
			"opacity440": "現有公開primitive",
			"opacity480": "現有公開primitive",
			"opacity550": "現有公開primitive",
			"opacity620": "現有公開primitive",
			"opacity720": "現有公開primitive",
			"opacity780": "現有公開primitive",
			"opacity820": "現有公開primitive",
			"opacity-0_13333333333333333": "原實作值的文件名稱；未新增設計",
			"opacity-0_6": "原實作值的文件名稱；未新增設計",
			"opacity-0_88": "原實作值的文件名稱；未新增設計",
			"opacity-0_47843137254901963": "原實作值的文件名稱；未新增設計",
			"opacity-0_1803921568627451": "原實作值的文件名稱；未新增設計",
			"opacity-0_07058823529411765": "原實作值的文件名稱；未新增設計",
			"opacity-0_8509803921568627": "原實作值的文件名稱；未新增設計",
			"family-packages-kallopis-noto-sans-tc": "原實作值的文件名稱；未新增設計",
			"family-noto-sans-tc": "原實作值的文件名稱；未新增設計",
			"family-microsoft-jhenghei-ui": "原實作值的文件名稱；未新增設計",
			"family-microsoft-jhenghei": "原實作值的文件名稱；未新增設計",
			"family-pingfang-tc": "原實作值的文件名稱；未新增設計",
			"family-sans-serif": "原實作值的文件名稱；未新增設計",
			"family-packages-kallopis-ibm-plex-mono": "原實作值的文件名稱；未新增設計",
			"family-ibm-plex-mono": "原實作值的文件名稱；未新增設計",
			"family-consolas": "原實作值的文件名稱；未新增設計",
			"family-courier-new": "原實作值的文件名稱；未新增設計",
			"family-monospace": "原實作值的文件名稱；未新增設計",
			"string-shadow": "原實作值的文件名稱；未新增設計",
			"count-4": "原實作值的文件名稱；未新增設計",
			"count-8": "原實作值的文件名稱；未新增設計",
			"length-15": "checkbox 13px 增加 2px 的明確尺寸",
			"mmLightCanvas": "open-tag off-white 畫布底色 (#F5F5F5)",
			"mmLightCanvasSoft": "open-tag 次柔白底色 (#FAFAFA)",
			"mmLightSurface": "open-tag 暖石表面 (#F0EFED)",
			"mmLightCard": "open-tag 純白卡片與控制底色 (#FFFFFF)",
			"mmLightInk": "open-tag 暖墨黑主色 (#0C0A09)",
			"mmLightPrimary": "open-tag 主按鈕墨黑 (#292524)",
			"mmLightBody": "open-tag 正文深灰 (#4E4E4E)",
			"mmLightMuted": "open-tag 次要灰 (#777169)",
			"mmLightFaint": "open-tag 弱化灰 (#A8A29E)",
			"mmLightHair": "open-tag 細線分隔 (#E7E5E4)",
			"mmLightHairStrong": "open-tag 強調細線 (#D6D3D1)",
			"mmDarkCanvas": "open-tag dark-band 深邃底色 (#0C0A09)",
			"mmDarkSurface": "open-tag dark 側欄底色 (#141210)",
			"mmDarkElevated": "open-tag dark 卡片浮起底色 (#1C1917)",
			"mmDarkInset": "open-tag dark 內凹區塊底色 (#080706)",
			"mmDarkBorder": "open-tag dark 細線 (#292524)",
			"mmDarkBorderStrong": "open-tag dark 強調細線 (#44403C)",
			"mmDarkText": "open-tag dark 主白文字 (#FFFFFF)",
			"mmDarkBody": "open-tag dark 次白文字 (#E7E5E4)",
			"mmDarkMuted": "open-tag dark 弱化文字 (#A8A29E)",
			"mmDarkFaint": "open-tag dark 更弱文字 (#777169)",
			"mmDarkPeach": "open-tag dark trace 暖杏強調色 (#F4C5A8)",
			"mmDarkPeachSoft": "open-tag dark 暖杏柔化底色",
			"mmSuccess": "open-tag 成功語意色 (#16A34A)",
			"mmWarning": "open-tag 警告語意色 (#B9770E)",
			"mmDanger": "open-tag 錯誤語意色 (#DC2626)",
			"mmInfo": "open-tag 資訊連結藍 (#7097F1)",
			"mmTransSurface": "open-tag 透明模式表面底色",
			"mmTransCard": "open-tag 透明模式卡片底色",
			"mmFamilyInter": "open-tag Inter UI 字型",
			"mmFamilyGaramond": "open-tag EB Garamond 編輯襯線字型"
		},
		"semanticDescriptions": {
			"theme.colors.app": "<br>app background／應用背景色",
			"theme.colors.surface": "<br>base surface／輔助表面色",
			"theme.colors.surfaceInset": "<br>inset surface／內嵌表面色",
			"theme.colors.surfaceMuted": "<br>muted surface／弱化表面色",
			"theme.colors.component": "<br>control surface／控制表面色",
			"theme.colors.stageSurface": "<br>stage background／主內容表面色",
			"theme.colors.overlay": "<br>overlay background／浮層色",
			"theme.colors.surfaceRaised": "<br>raised surface／較亮表面",
			"theme.colors.modalScrim": "<br>遮罩色",
			"theme.colors.guide": "<br>colors / guide",
			"theme.colors.divider": "<br>分隔線色",
			"theme.colors.pagePattern": "<br>colors / page Pattern",
			"theme.colors.text": "<br>primary text／主文字",
			"theme.colors.textMuted": "<br>muted text／次要文字",
			"theme.colors.textFaint": "<br>faint text／弱化文字",
			"theme.colors.border": "<br>邊框色",
			"theme.colors.borderStrong": "<br>colors / border Strong",
			"theme.colors.brand": "<br>brand／品牌色／主動作底色",
			"theme.colors.accent": "<br>colors / accent",
			"theme.colors.accentSoft": "<br>colors / accent Soft",
			"theme.colors.interaction": "<br>interaction／操作色",
			"theme.colors.interactionSoft": "<br>selection background／柔和操作色",
			"theme.colors.success": "<br>colors / success",
			"theme.colors.warning": "<br>colors / warning",
			"theme.colors.danger": "<br>colors / danger",
			"theme.colors.info": "<br>colors / info",
			"theme.colors.onStatus": "<br>colors / on Status",
			"theme.colors.onLightBackground": "<br>colors / on Light Background",
			"theme.colors.onDarkBackground": "<br>colors / on Dark Background",
			"theme.colors.mutedOnLightBackground": "<br>colors / muted On Light Background",
			"theme.colors.mutedOnDarkBackground": "<br>colors / muted On Dark Background",
			"theme.colors.faintOnBackground": "<br>colors / faint On Background",
			"theme.colors.transparent": "<br>透明",
			"theme.typography.sansFamily": "<br>typography / sans Family",
			"theme.typography.sansFallback": "<br>typography / sans Fallback",
			"theme.typography.monoFamily": "<br>typography / mono Family",
			"theme.typography.monoFallback": "<br>typography / mono Fallback",
			"theme.typography.uiFamily": "<br>typography / ui Family",
			"theme.typography.bodyFamily": "<br>typography / body Family",
			"theme.typography.codeFamily": "<br>typography / code Family",
			"theme.typography.micro": "<br>typography / micro",
			"theme.typography.caption": "<br>typography / caption",
			"theme.typography.sub": "<br>typography / sub",
			"theme.typography.body": "<br>typography / body",
			"theme.typography.lead": "<br>typography / lead",
			"theme.typography.h4": "<br>typography / h4",
			"theme.typography.h3": "<br>typography / h3",
			"theme.typography.h2": "<br>typography / h2",
			"theme.typography.h1": "<br>typography / h1",
			"theme.typography.display": "<br>typography / display",
			"theme.typography.label": "<br>typography / label",
			"theme.typography.section": "<br>typography / section",
			"theme.typography.headingSmall": "<br>typography / heading Small",
			"theme.typography.heading": "<br>typography / heading",
			"theme.typography.title": "<br>typography / title",
			"theme.typography.microLeading": "<br>typography / micro Leading",
			"theme.typography.captionLeading": "<br>typography / caption Leading",
			"theme.typography.subLeading": "<br>typography / sub Leading",
			"theme.typography.bodyLeading": "<br>typography / body Leading",
			"theme.typography.leadLeading": "<br>typography / lead Leading",
			"theme.typography.h4Leading": "<br>typography / h4Leading",
			"theme.typography.h3Leading": "<br>typography / h3Leading",
			"theme.typography.h2Leading": "<br>typography / h2Leading",
			"theme.typography.h1Leading": "<br>typography / h1Leading",
			"theme.typography.displayLeading": "<br>typography / display Leading",
			"theme.typography.headingLeading": "<br>typography / heading Leading",
			"theme.typography.codeLeading": "<br>typography / code Leading",
			"theme.typography.readingLeading": "<br>typography / reading Leading",
			"theme.typography.labelLeading": "<br>typography / label Leading",
			"theme.typography.labelTracking": "<br>typography / label Tracking",
			"theme.typography.displayTracking": "<br>typography / display Tracking",
			"theme.typography.regular": "<br>typography / regular",
			"theme.typography.medium": "<br>typography / medium",
			"theme.typography.semiBold": "<br>typography / semi Bold",
			"theme.typography.bold": "<br>typography / bold",
			"theme.typography.extraBold": "<br>typography / extra Bold",
			"theme.typography.strong": "<br>typography / strong",
			"theme.spacing.space0_5": "<br>spacing / space0_5",
			"theme.spacing.space1": "<br>spacing / space1",
			"theme.spacing.space2": "<br>spacing / space2",
			"theme.spacing.space3": "<br>spacing / space3",
			"theme.spacing.space4": "<br>spacing / space4",
			"theme.spacing.space6": "<br>spacing / space6",
			"theme.spacing.space8": "<br>spacing / space8",
			"theme.spacing.space12": "<br>spacing / space12",
			"theme.spacing.space16": "<br>spacing / space16",
			"theme.spacing.space24": "<br>spacing / space24",
			"theme.spacing.hairline": "<br>spacing / hairline",
			"theme.spacing.tight": "<br>spacing / tight",
			"theme.spacing.contentInlineGap": "<br>spacing / content Inline Gap",
			"theme.spacing.contentStackGap": "<br>spacing / content Stack Gap",
			"theme.spacing.contentInset": "<br>spacing / content Inset",
			"theme.spacing.controlContentGap": "<br>spacing / control Content Gap",
			"theme.spacing.controlInset": "<br>spacing / control Inset",
			"theme.spacing.actionGap": "<br>spacing / action Gap",
			"theme.spacing.chromeGap": "<br>spacing / chrome Gap",
			"theme.spacing.chromePanelInset": "<br>spacing / chrome Panel Inset",
			"theme.spacing.chromeToolbarGap": "<br>spacing / chrome Toolbar Gap",
			"theme.spacing.navigationItemInset": "<br>spacing / navigation Item Inset",
			"theme.spacing.navigationRailInset": "<br>spacing / navigation Rail Inset",
			"theme.spacing.navigationRailItemGap": "<br>spacing / navigation Rail Item Gap",
			"theme.spacing.overlayContentInset": "<br>spacing / overlay Content Inset",
			"theme.spacing.overlayHeadingGap": "<br>spacing / overlay Heading Gap",
			"theme.spacing.overlayItemGap": "<br>spacing / overlay Item Gap",
			"theme.spacing.navigationSectionGap": "<br>spacing / navigation Section Gap",
			"theme.spacing.appFrameInset": "<br>spacing / app Frame Inset",
			"theme.spacing.windowHeaderMargin": "<br>spacing / window Header Margin",
			"theme.spacing.dockMargin": "<br>spacing / dock Margin",
			"theme.spacing.base": "<br>spacing / base",
			"theme.spacing.comfortable": "<br>spacing / comfortable",
			"theme.spacing.loose": "<br>spacing / loose",
			"theme.spacing.section": "<br>spacing / section",
			"theme.spacing.sectionLarge": "<br>spacing / section Large",
			"theme.spacing.page": "<br>spacing / page",
			"theme.spacing.pageLarge": "<br>spacing / page Large",
			"theme.spacing.controlPaddingXSmall": "<br>spacing / control Padding XSmall",
			"theme.spacing.controlPaddingX": "<br>spacing / control Padding X",
			"theme.spacing.controlPaddingXLarge": "<br>spacing / control Padding XLarge",
			"theme.spacing.controlPaddingXXLarge": "<br>spacing / control Padding XXLarge",
			"theme.spacing.controlPaddingY": "<br>spacing / control Padding Y",
			"theme.spacing.containerPadding": "<br>spacing / container Padding",
			"theme.spacing.itemGap": "<br>spacing / item Gap",
			"theme.spacing.groupGap": "<br>spacing / group Gap",
			"theme.spacing.controlHeightXSmall": "<br>spacing / control Height XSmall",
			"theme.spacing.controlHeightSmall": "<br>spacing / control Height Small",
			"theme.spacing.controlHeight": "<br>spacing / control Height",
			"theme.spacing.controlHeightLarge": "<br>spacing / control Height Large",
			"theme.spacing.controlHeightXLarge": "<br>spacing / control Height XLarge",
			"theme.spacing.iconSmall": "<br>spacing / icon Small",
			"theme.spacing.iconBase": "<br>spacing / icon Base",
			"theme.spacing.iconGlyph": "<br>spacing / icon Glyph",
			"theme.spacing.icon": "<br>spacing / icon",
			"theme.spacing.iconMedium": "<br>spacing / icon Medium",
			"theme.spacing.iconLarge": "<br>spacing / icon Large",
			"theme.spacing.chromeHeader": "<br>spacing / chrome Header",
			"theme.spacing.chromeStatusBar": "<br>spacing / chrome Status Bar",
			"theme.spacing.chromeRail": "<br>spacing / chrome Rail",
			"theme.spacing.chromeTab": "<br>spacing / chrome Tab",
			"theme.spacing.iconButton": "<br>spacing / icon Button",
			"theme.spacing.iconTiny": "<br>spacing / icon Tiny",
			"theme.spacing.indicatorDot": "<br>spacing / indicator Dot",
			"theme.spacing.indicatorDotLarge": "<br>spacing / indicator Dot Large",
			"theme.spacing.noticeIconSlot": "<br>spacing / notice Icon Slot",
			"theme.spacing.toastIconSlot": "<br>spacing / toast Icon Slot",
			"theme.spacing.gutterNumber": "<br>spacing / gutter Number",
			"theme.spacing.gutterMarker": "<br>spacing / gutter Marker",
			"theme.spacing.micro": "<br>spacing / micro",
			"theme.spacing.calendarContentCell": "<br>spacing / calendar Content Cell",
			"theme.spacing.gridTileWidth": "<br>spacing / grid Tile Width",
			"theme.spacing.iconMicro": "<br>spacing / icon Micro",
			"theme.spacing.avatarSmall": "<br>spacing / avatar Small",
			"theme.spacing.progressTrack": "<br>spacing / progress Track",
			"theme.spacing.skeletonLine": "<br>spacing / skeleton Line",
			"theme.spacing.railItem": "<br>spacing / rail Item",
			"theme.shape.none": "<br>shape / none",
			"theme.shape.sm": "<br>shape / sm",
			"theme.shape.control": "<br>shape / control",
			"theme.shape.controlInner": "<br>shape / control Inner",
			"theme.shape.toggleTrack": "<br>shape / toggle Track",
			"theme.shape.card": "<br>shape / card",
			"theme.shape.panel": "<br>shape / panel",
			"theme.shape.pill": "<br>shape / pill",
			"theme.shape.hairline": "<br>shape / hairline",
			"theme.shape.stroke": "<br>shape / stroke",
			"theme.shape.dashedLength": "<br>shape / dashed Length",
			"theme.shape.dashedGap": "<br>shape / dashed Gap",
			"theme.shape.dashedOpacity": "<br>shape / dashed Opacity",
			"theme.motion.themeTransition": "<br>motion / theme Transition",
			"theme.motion.styleTransition": "<br>motion / style Transition",
			"theme.motion.stateTransition": "<br>motion / state Transition",
			"theme.motion.overlayEnter": "<br>motion / overlay Enter",
			"theme.motion.overlayExit": "<br>motion / overlay Exit",
			"theme.motion.toastDwell": "<br>motion / toast Dwell",
			"theme.motion.tooltipDelay": "<br>motion / tooltip Delay",
			"theme.motion.tooltipDwell": "<br>motion / tooltip Dwell",
			"theme.motion.spinnerCycle": "<br>motion / spinner Cycle",
			"theme.motion.longPressThreshold": "<br>motion / long Press Threshold",
			"theme.motion.standard": "<br>motion / standard",
			"theme.motion.emphasized": "<br>motion / emphasized",
			"theme.surface.separation": "<br>surface / separation",
			"theme.surface.overlayBlur": "<br>surface / overlay Blur",
			"theme.surface.overlaySpread": "<br>surface / overlay Spread",
			"theme.surface.overlayOffsetY": "<br>surface / overlay Offset Y",
			"theme.surface.overlayShadowOpacity": "<br>surface / overlay Shadow Opacity",
			"theme.surface.scrimOpacity": "<br>surface / scrim Opacity",
			"theme.surface.selectionWashOpacity": "<br>surface / selection Wash Opacity",
			"theme.surface.focusWashOpacity": "<br>surface / focus Wash Opacity",
			"theme.surface.statusFillOpacity": "<br>surface / status Fill Opacity",
			"theme.surface.pressProgressOpacity": "<br>surface / press Progress Opacity",
			"theme.surface.diffFillOpacity": "<br>surface / diff Fill Opacity",
			"theme.surface.gridLineOpacity": "<br>surface / grid Line Opacity",
			"theme.surface.veilOpacity": "<br>surface / veil Opacity",
			"theme.surface.statusRowOpacity": "<br>surface / status Row Opacity",
			"theme.surface.statusRowSelectedOpacity": "<br>surface / status Row Selected Opacity",
			"theme.surface.statusRowOpacityDark": "<br>surface / status Row Opacity Dark",
			"theme.surface.statusRowSelectedOpacityDark": "<br>surface / status Row Selected Opacity Dark",
			"theme.surface.frostedOpacity": "<br>surface / frosted Opacity",
			"theme.surface.frostedVeilOpacity": "<br>surface / frosted Veil Opacity",
			"theme.surface.backdropBlurSigma": "<br>surface / backdrop Blur Sigma",
			"theme.surface.dragOpacity": "<br>surface / drag Opacity",
			"theme.surface.dragSourceOpacity": "<br>surface / drag Source Opacity",
			"theme.surface.themePreviewDisabledOpacity": "<br>surface / theme Preview Disabled Opacity",
			"theme.surface.listStatusOpacity": "<br>surface / list Status Opacity",
			"theme.surface.listStatusSelectedOpacity": "<br>surface / list Status Selected Opacity",
			"theme.surface.accentSoftOpacityLight": "<br>surface / accent Soft Opacity Light",
			"theme.surface.accentSoftOpacityDark": "<br>surface / accent Soft Opacity Dark",
			"theme.surface.windowPaneOpacityLight": "<br>surface / window Pane Opacity Light",
			"theme.surface.windowPaneOpacityDark": "<br>surface / window Pane Opacity Dark",
			"theme.surface.invalidFillOpacity": "<br>surface / invalid Fill Opacity",
			"theme.surface.contactBlur": "<br>surface / contact Blur",
			"theme.surface.contactOffsetY": "<br>surface / contact Offset Y",
			"theme.surface.contactShadowOpacity": "<br>surface / contact Shadow Opacity",
			"theme.surface.overlayShadowColor": "<br>surface / overlay Shadow Color",
			"theme.components.buttonRadius": "<br>components / button Radius",
			"theme.components.buttonPaddingX": "<br>components / button Padding X",
			"theme.components.buttonPaddingY": "<br>components / button Padding Y",
			"theme.components.buttonHeight": "<br>components / button Height",
			"theme.components.buttonBorderWidth": "<br>components / button Border Width",
			"theme.components.fieldRadius": "<br>components / field Radius",
			"theme.components.fieldPaddingX": "<br>components / field Padding X",
			"theme.components.fieldHeight": "<br>components / field Height",
			"theme.components.fieldBorderWidth": "<br>components / field Border Width",
			"theme.components.menuRadius": "<br>components / menu Radius",
			"theme.components.menuPadding": "<br>components / menu Padding",
			"theme.components.menuItemHeight": "<br>components / menu Item Height",
			"theme.components.cardRadius": "<br>components / card Radius",
			"theme.components.cardPadding": "<br>components / card Padding",
			"theme.components.badgeRadius": "<br>components / badge Radius",
			"theme.components.badgePaddingX": "<br>components / badge Padding X",
			"theme.geometry.control.switchTrackWidth": "<br>geometry / control / switch Track Width",
			"theme.geometry.control.switchTrackHeight": "<br>geometry / control / switch Track Height",
			"theme.geometry.control.switchThumb": "<br>geometry / control / switch Thumb",
			"theme.geometry.control.buttonHeightXSmall": "<br>geometry / control / button Height XSmall",
			"theme.geometry.control.buttonHeightSmall": "<br>geometry / control / button Height Small",
			"theme.geometry.control.buttonHeight": "<br>geometry / control / button Height",
			"theme.geometry.control.buttonHeightLarge": "<br>geometry / control / button Height Large",
			"theme.geometry.control.buttonHeightXLarge": "<br>geometry / control / button Height XLarge",
			"theme.geometry.control.pageBackgroundHitRadius": "<br>geometry / control / page Background Hit Radius",
			"theme.geometry.control.presenceMarkerExtent": "<br>geometry / control / presence Marker Extent",
			"theme.geometry.control.colorPickerCursorRadius": "<br>geometry / control / color Picker Cursor Radius",
			"theme.geometry.control.swatchExtent": "<br>geometry / control / swatch Extent",
			"theme.geometry.control.segmentedProgressHeight": "<br>geometry / control / segmented Progress Height",
			"theme.geometry.control.fieldHeight": "<br>geometry / control / field Height",
			"theme.geometry.control.selectionControl": "<br>geometry / control / selection Control",
			"theme.geometry.control.selectionIndicatorInset": "<br>geometry / control / selection Indicator Inset",
			"theme.geometry.control.selectionIcon": "<br>geometry / control / selection Icon",
			"theme.geometry.control.toggleWidth": "<br>geometry / control / toggle Width",
			"theme.geometry.control.toggleHeight": "<br>geometry / control / toggle Height",
			"theme.geometry.control.toggleThumb": "<br>geometry / control / toggle Thumb",
			"theme.geometry.control.toggleInset": "<br>geometry / control / toggle Inset",
			"theme.geometry.control.segmentedDenseHeight": "<br>geometry / control / segmented Dense Height",
			"theme.geometry.control.segmentedDenseInset": "<br>geometry / control / segmented Dense Inset",
			"theme.geometry.control.segmentedDenseContentInset": "<br>geometry / control / segmented Dense Content Inset",
			"theme.geometry.control.segmentedDenseItemHeight": "<br>geometry / control / segmented Dense Item Height",
			"theme.geometry.control.slidingSelectionHeight": "<br>geometry / control / sliding Selection Height",
			"theme.geometry.control.slidingSelectionSegmentWidth": "<br>geometry / control / sliding Selection Segment Width",
			"theme.geometry.control.slidingSelectionPadding": "<br>geometry / control / sliding Selection Padding",
			"theme.geometry.control.slidingSelectionIndicatorHeight": "<br>geometry / control / sliding Selection Indicator Height",
			"theme.geometry.control.scrollbarThickness": "<br>geometry / control / scrollbar Thickness",
			"theme.geometry.control.sliderTrackHeight": "<br>geometry / control / slider Track Height",
			"theme.geometry.control.colorPlaneExtent": "<br>geometry / control / color Plane Extent",
			"theme.geometry.control.textFieldIndicatorHeightFactor": "<br>geometry / control / text Field Indicator Height Factor",
			"theme.geometry.control.textFieldLineHeightFactor": "<br>geometry / control / text Field Line Height Factor",
			"theme.geometry.control.textFieldMinLines": "<br>geometry / control / text Field Min Lines",
			"theme.geometry.control.textFieldMaxLines": "<br>geometry / control / text Field Max Lines",
			"theme.geometry.control.fileExplorerRowHeightAdjustment": "<br>geometry / control / file Explorer Row Height Adjustment",
			"theme.geometry.data.codeActionButtonSize": "<br>geometry / data / code Action Button Size",
			"theme.geometry.data.codeHeaderHeight": "<br>geometry / data / code Header Height",
			"theme.geometry.data.codeTerminalDot": "<br>geometry / data / code Terminal Dot",
			"theme.geometry.data.codeTerminalDotGap": "<br>geometry / data / code Terminal Dot Gap",
			"theme.geometry.data.codeHeaderPaddingX": "<br>geometry / data / code Header Padding X",
			"theme.geometry.data.codeBodyPaddingX": "<br>geometry / data / code Body Padding X",
			"theme.geometry.data.codeLineNumberWidth": "<br>geometry / data / code Line Number Width",
			"theme.geometry.data.codeWrappedLineWidth": "<br>geometry / data / code Wrapped Line Width",
			"theme.geometry.data.codeMaximumHeight": "<br>geometry / data / code Maximum Height",
			"theme.geometry.data.codeCollapsedHeight": "<br>geometry / data / code Collapsed Height",
			"theme.geometry.data.codeDisclosureSize": "<br>geometry / data / code Disclosure Size",
			"theme.geometry.data.filePreviewHeight": "<br>geometry / data / file Preview Height",
			"theme.geometry.data.previewCardCompactHeight": "<br>geometry / data / preview Card Compact Height",
			"theme.geometry.data.previewCardStandardHeight": "<br>geometry / data / preview Card Standard Height",
			"theme.geometry.data.previewCardLargeHeight": "<br>geometry / data / preview Card Large Height",
			"theme.geometry.data.dateGridCellHeight": "<br>geometry / data / date Grid Cell Height",
			"theme.geometry.data.keyValueLabelWidthCompact": "<br>geometry / data / key Value Label Width Compact",
			"theme.geometry.data.keyValueLabelWidthStandard": "<br>geometry / data / key Value Label Width Standard",
			"theme.geometry.data.stepperMarkerSize": "<br>geometry / data / stepper Marker Size",
			"theme.geometry.data.stepperLabelWidth": "<br>geometry / data / stepper Label Width",
			"theme.geometry.data.progressIndeterminateFraction": "<br>geometry / data / progress Indeterminate Fraction",
			"theme.geometry.data.placeholderMinimumHeight": "<br>geometry / data / placeholder Minimum Height",
			"theme.geometry.data.placeholderContentPaddingY": "<br>geometry / data / placeholder Content Padding Y",
			"theme.geometry.data.placeholderActionPaddingY": "<br>geometry / data / placeholder Action Padding Y",
			"theme.geometry.data.placeholderHatchBand": "<br>geometry / data / placeholder Hatch Band",
			"theme.geometry.data.placeholderHatchGap": "<br>geometry / data / placeholder Hatch Gap",
			"theme.geometry.data.placeholderLabelTracking": "<br>geometry / data / placeholder Label Tracking",
			"theme.geometry.data.placeholderDetailMaximumWidth": "<br>geometry / data / placeholder Detail Maximum Width",
			"theme.geometry.data.spinnerSquareFactor": "<br>geometry / data / spinner Square Factor",
			"theme.geometry.data.spinnerOrbitFactor": "<br>geometry / data / spinner Orbit Factor",
			"theme.geometry.data.spinnerCornerFactor": "<br>geometry / data / spinner Corner Factor",
			"theme.geometry.layout.drawerWidth": "<br>geometry / layout / drawer Width",
			"theme.geometry.layout.drawerHeight": "<br>geometry / layout / drawer Height",
			"theme.geometry.layout.resizeHandleExtent": "<br>geometry / layout / resize Handle Extent",
			"theme.geometry.layout.overlayViewportInset": "<br>geometry / layout / overlay Viewport Inset",
			"theme.geometry.layout.railDropTargetExtent": "<br>geometry / layout / rail Drop Target Extent",
			"theme.geometry.layout.disclosureIconSize": "<br>geometry / layout / disclosure Icon Size",
			"theme.geometry.layout.treeLeadingGap": "<br>geometry / layout / tree Leading Gap",
			"theme.geometry.layout.tooltipOffsetX": "<br>geometry / layout / tooltip Offset X",
			"theme.geometry.layout.primaryPaneWidth": "<br>geometry / layout / primary Pane Width",
			"theme.geometry.layout.secondaryPaneWidth": "<br>geometry / layout / secondary Pane Width",
			"theme.geometry.layout.primaryPaneBreakpoint": "<br>geometry / layout / primary Pane Breakpoint",
			"theme.geometry.layout.primaryPaneContentBreakpoint": "<br>geometry / layout / primary Pane Content Breakpoint",
			"theme.geometry.layout.responsivePaneBreakpoint": "<br>geometry / layout / responsive Pane Breakpoint",
			"theme.geometry.layout.secondaryPaneBreakpoint": "<br>geometry / layout / secondary Pane Breakpoint",
			"theme.geometry.layout.menuWidth": "<br>geometry / layout / menu Width",
			"theme.geometry.layout.commandMenuWidth": "<br>geometry / layout / command Menu Width",
			"theme.geometry.layout.menuHeaderHeight": "<br>geometry / layout / menu Header Height",
			"theme.geometry.layout.menuItemHeight": "<br>geometry / layout / menu Item Height",
			"theme.geometry.layout.dialogMaximumWidth": "<br>geometry / layout / dialog Maximum Width",
			"theme.geometry.layout.toastMaximumWidth": "<br>geometry / layout / toast Maximum Width",
			"theme.geometry.layout.inlineNoticeBreakpoint": "<br>geometry / layout / inline Notice Breakpoint",
			"theme.geometry.layout.statusBarBreakpoint": "<br>geometry / layout / status Bar Breakpoint",
			"theme.geometry.layout.settingsDialogMaximumWidth": "<br>geometry / layout / settings Dialog Maximum Width",
			"theme.geometry.layout.settingsDialogMaximumHeight": "<br>geometry / layout / settings Dialog Maximum Height",
			"theme.geometry.layout.settingsPaneGap": "<br>geometry / layout / settings Pane Gap",
			"theme.geometry.layout.settingsNavigationWidth": "<br>geometry / layout / settings Navigation Width",
			"theme.geometry.layout.settingsNavigationMinimumWidth": "<br>geometry / layout / settings Navigation Minimum Width",
			"theme.geometry.layout.settingsNavigationMaximumWidth": "<br>geometry / layout / settings Navigation Maximum Width",
			"theme.geometry.layout.settingsContentMaximumWidth": "<br>geometry / layout / settings Content Maximum Width",
			"theme.geometry.layout.themePreviewTileWidth": "<br>geometry / layout / theme Preview Tile Width",
			"theme.geometry.layout.windowHeaderHeight": "<br>geometry / layout / window Header Height",
			"theme.geometry.layout.windowHeaderControlSize": "<br>geometry / layout / window Header Control Size",
			"theme.geometry.layout.windowAppIconSize": "<br>geometry / layout / window App Icon Size",
			"theme.geometry.layout.windowIdentityGap": "<br>geometry / layout / window Identity Gap",
			"theme.geometry.optical.menuIconOffsetY": "<br>geometry / optical / menu Icon Offset Y",
			"theme.geometry.optical.railBadgeInset": "<br>geometry / optical / rail Badge Inset",
			"theme.geometry.optical.statusIconOffsetY": "<br>geometry / optical / status Icon Offset Y",
			"theme.geometry.optical.monoBaselineOffsetY": "<br>geometry / optical / mono Baseline Offset Y",
			"theme.geometry.optical.uiBaselineOffsetY": "<br>geometry / optical / ui Baseline Offset Y",
			"theme.dataVisualization.series": "<br>data Visualization / series",
			"theme.dataVisualization.seriesWash": "<br>data Visualization / series Wash",
			"theme.dataVisualization.axis": "<br>data Visualization / axis",
			"theme.dataVisualization.grid": "<br>data Visualization / grid",
			"theme.dataVisualization.gridStrong": "<br>data Visualization / grid Strong",
			"theme.dataVisualization.label": "<br>data Visualization / label",
			"theme.dataVisualization.value": "<br>data Visualization / value",
			"theme.dataVisualization.plotBackground": "<br>data Visualization / plot Background",
			"theme.dataVisualization.crosshair": "<br>data Visualization / crosshair",
			"theme.dataVisualization.marketUp": "<br>data Visualization / market Up",
			"theme.dataVisualization.marketUpWash": "<br>data Visualization / market Up Wash",
			"theme.dataVisualization.marketDown": "<br>data Visualization / market Down",
			"theme.dataVisualization.marketDownWash": "<br>data Visualization / market Down Wash",
			"theme.dataVisualization.marketFlat": "<br>data Visualization / market Flat"
		}
	},
	"kallopis-v1": {
		"schemaVersion": 1,
		"id": "kallopis-v1",
		"version": "1.0.0",
		"primitives": {
			"parchment50": "#FFF8F6F1",
			"parchment75": "#FFF0EDE6",
			"parchment100": "#FFEFEDE7",
			"parchment150": "#FFE7E4DD",
			"parchment200": "#FFE1DDD2",
			"parchment250": "#FFD3CFC4",
			"parchment350": "#FFBAB5AA",
			"parchment550": "#FF6A655B",
			"parchment700": "#FF514B40",
			"parchment750": "#FF484339",
			"parchment800": "#FF35322D",
			"parchment825": "#FF33322C",
			"parchment900": "#FF292724",
			"parchment925": "#FF21201B",
			"parchment950": "#FF201F1C",
			"ink1000": "#FF000000",
			"transparent": "#00000000",
			"ink50": "#FFFFFFFF",
			"ink100": "#FFF2F0EB",
			"ink150": "#FFEAE7E1",
			"ink200": "#FFE6E3DC",
			"ink250": "#FFBCB8B0",
			"ink300": "#FFADA89E",
			"ink350": "#FF9E998F",
			"ink400": "#FF8E8982",
			"ink450": "#FF7F7A75",
			"ink500": "#FF6F6C67",
			"ink550": "#FF6B6459",
			"ink600": "#FF4F5151",
			"ink650": "#FF414344",
			"ink700": "#FF343637",
			"ink750": "#FF303030",
			"ink800": "#FF292929",
			"ink850": "#FF232323",
			"ink900": "#FF1D1D1D",
			"ink950": "#FF101010",
			"warmNeutral25": "#FFF5F2EC",
			"warmNeutral50": "#FFE4E1DA",
			"warmNeutral100": "#FFD6D0C6",
			"warmNeutral200": "#FFC8C0B4",
			"warmNeutral300": "#FFB8B2A4",
			"warmNeutral400": "#FF918A7B",
			"warmNeutral450": "#FF8C8477",
			"warmNeutral500": "#FF7A7566",
			"warmNeutral600": "#FF6A6256",
			"warmNeutral700": "#FF585249",
			"warmNeutral750": "#FF45413A",
			"warmNeutral800": "#FF433F3A",
			"warmNeutral900": "#FF34302B",
			"sand50": "#FFF8F1E2",
			"sand300": "#FFF0D79A",
			"sand500": "#FFE0BE73",
			"sand800": "#FF453D2B",
			"sand900": "#FF302B20",
			"gold50": "#FFF6EBD7",
			"gold300": "#FFE8BD70",
			"gold500": "#FFD3A152",
			"gold800": "#FF443725",
			"gold900": "#FF30271B",
			"ochre50": "#FFF3E4CF",
			"ochre300": "#FFDFA04E",
			"ochre500": "#FFC6823D",
			"ochre800": "#FF413222",
			"ochre900": "#FF2E241A",
			"terracotta50": "#FFEEDDD0",
			"terracotta300": "#FFC88745",
			"terracotta500": "#FFA96836",
			"terracotta800": "#FF3D2D22",
			"terracotta900": "#FF2C211B",
			"clay50": "#FFE9D8D1",
			"clay300": "#FFA86D43",
			"clay500": "#FF895137",
			"clay800": "#FF382A23",
			"clay900": "#FF291F1C",
			"umber50": "#FFE4D5D1",
			"umber300": "#FF89573E",
			"umber500": "#FF683E33",
			"umber800": "#FF332724",
			"umber900": "#FF261D1C",
			"green100": "#FFDFF0E5",
			"green400": "#FF67AE86",
			"green500": "#FF51B77B",
			"green600": "#FF2D8057",
			"green800": "#FF243B2D",
			"green900": "#FF1D3025",
			"red100": "#FFFAE3E2",
			"red300": "#FFFA6C73",
			"red400": "#FFD27B74",
			"red600": "#FFA7443F",
			"red800": "#FF472925",
			"red900": "#FF3B2320",
			"amber500": "#FFF6B52E",
			"blue500": "#FF5499DF",
			"scrim": "#99010202",
			"line": "#00000000",
			"transparentSurface": "#9426292D",
			"transparentSurfaceInset": "#A8404449",
			"pureWhite": "#FFFFFFFF",
			"pureBlack": "#FF000000",
			"accent-ink-light": "#FF1D1D1D",
			"accent-ink-dark": "#FFFFFFFF",
			"accent-terracotta-light": "#FF92563C",
			"accent-terracotta-dark": "#FFCB8E72",
			"accent-ochre-light": "#FF7D612F",
			"accent-ochre-dark": "#FFB99860",
			"accent-olive-light": "#FF5E6A39",
			"accent-olive-dark": "#FF94A366",
			"accent-slate-light": "#FF4E678A",
			"accent-slate-dark": "#FF879EBD",
			"accent-crimson-light": "#FF9F4B59",
			"accent-crimson-dark": "#FFCE8A95",
			"color-b8292724": "#B8292724",
			"color-b835322d": "#B835322D",
			"space0": 0,
			"space50": 2,
			"space100": 4,
			"space200": 8,
			"space250": 10,
			"space300": 12,
			"space400": 16,
			"space600": 24,
			"space800": 32,
			"space1000": 40,
			"space1200": 48,
			"space1600": 64,
			"space2400": 96,
			"radius0": 0,
			"radius50": 2,
			"radius100": 4,
			"radius150": 6,
			"radius200": 8,
			"radius250": 10,
			"radius300": 12,
			"radius400": 16,
			"radiusFull": 9999,
			"stroke0": 0,
			"stroke100": 1,
			"stroke200": 2,
			"font100": 10,
			"font200": 12,
			"font300": 14,
			"font400": 16,
			"font500": 18,
			"font600": 22,
			"font700": 28,
			"font800": 36,
			"font900": 48,
			"font1000": 64,
			"tracking0": 0,
			"trackingTight": -0.5,
			"trackingWide": 1.2,
			"trackingWider": 1.32,
			"length-30": 30,
			"length-56": 56,
			"length-20": 20,
			"length-60": 60,
			"length-74": 74,
			"length-170": 170,
			"length-11": 11,
			"length-3": 3,
			"length-5": 5,
			"length-7": 7,
			"length-3_5": 3.5,
			"length-41_4": 41.4,
			"length-168": 168,
			"length-26": 26,
			"length-520": 520,
			"length-320": 320,
			"length-120": 120,
			"length-9": 9,
			"length-220": 220,
			"length-192": 192,
			"length-128": 128,
			"length-112": 112,
			"length-10_5": 10.5,
			"length-336": 336,
			"length-300": 300,
			"length-350": 350,
			"length-400": 400,
			"length-800": 800,
			"length-960": 960,
			"length-1120": 1120,
			"length-200": 200,
			"length-360": 360,
			"length-480": 480,
			"length-1380": 1380,
			"length-880": 880,
			"length-260": 260,
			"length-820": 820,
			"length-minus-1": -1,
			"leading100": 1.125,
			"leading116": 1.166,
			"leading120": 1.2,
			"leading122": 1.222,
			"leading127": 1.272,
			"leading128": 1.285,
			"leading133": 1.333,
			"leading142": 1.428,
			"leading150": 1.5,
			"leading155": 1.555,
			"leading150Legacy": 1.2,
			"leading200": 1.25,
			"leading300": 1.3,
			"leading350": 1.35,
			"leading400": 1.4,
			"leading450": 1.45,
			"leading500": 1.5,
			"leading550": 1.55,
			"leading650": 1.65,
			"ratio-0_4": 0.4,
			"ratio-0_35": 0.35,
			"ratio-0_32": 0.32,
			"ratio-0_22": 0.22,
			"ratio-0_06": 0.06,
			"ratio-8": 8,
			"ratio-2": 2,
			"ratio-3": 3,
			"ratio-6": 6,
			"weight400": 400,
			"weight500": 500,
			"weight600": 600,
			"weight700": 700,
			"weight800": 800,
			"duration0": 0,
			"duration100": 120,
			"duration150": 140,
			"duration400": 450,
			"duration500": 500,
			"duration-4000": 4000,
			"duration-1000": 1000,
			"easeStandard": "[0.215, 0.61, 0.355, 1.0]",
			"easeEmphasized": "[0.645, 0.045, 0.355, 1.0]",
			"opacity100": 0.1,
			"opacity120": 0.12,
			"opacity140": 0.14,
			"opacity160": 0.16,
			"opacity180": 0.18,
			"opacity220": 0.22,
			"opacity280": 0.28,
			"opacity320": 0.32,
			"opacity350": 0.35,
			"opacity440": 0.44,
			"opacity480": 0.48,
			"opacity550": 0.55,
			"opacity620": 0.62,
			"opacity720": 0.72,
			"opacity780": 0.78,
			"opacity820": 0.82,
			"opacity-0_13333333333333333": 0.13333333333333333,
			"opacity-0_6": 0.6,
			"opacity-0_88": 0.88,
			"opacity-0_47843137254901963": 0.47843137254901963,
			"opacity-0_1803921568627451": 0.1803921568627451,
			"opacity-0_07058823529411765": 0.07058823529411765,
			"opacity-0_8509803921568627": 0.8509803921568627,
			"family-packages-kallopis-noto-sans-tc": "packages/kallopis/Noto Sans TC",
			"family-noto-sans-tc": "Noto Sans TC",
			"family-microsoft-jhenghei-ui": "Microsoft JhengHei UI",
			"family-microsoft-jhenghei": "Microsoft JhengHei",
			"family-pingfang-tc": "PingFang TC",
			"family-sans-serif": "sans-serif",
			"family-packages-kallopis-ibm-plex-mono": "packages/kallopis/IBM Plex Mono",
			"family-ibm-plex-mono": "IBM Plex Mono",
			"family-consolas": "Consolas",
			"family-courier-new": "Courier New",
			"family-monospace": "monospace",
			"string-shadow": "shadow",
			"count-4": 4,
			"count-8": 8,
			"length-15": 15
		},
		"semantics": {
			"theme.colors.app": {
				"light": "p(parchment150)",
				"dark": "p(parchment950)",
				"ultraDark": "p(ink950)",
				"transparent": "p(transparent)"
			},
			"theme.colors.surface": {
				"light": "p(parchment100)",
				"dark": "p(parchment900)",
				"ultraDark": "p(ink850)",
				"transparent": "p(color-b8292724)"
			},
			"theme.colors.surfaceInset": {
				"light": "p(parchment100)",
				"dark": "p(parchment900)",
				"ultraDark": "p(ink850)",
				"transparent": "p(parchment900)"
			},
			"theme.colors.surfaceMuted": {
				"light": "p(parchment200)",
				"dark": "p(parchment750)",
				"ultraDark": "p(ink850)",
				"transparent": "p(parchment750)"
			},
			"theme.colors.component": {
				"light": "p(parchment50)",
				"dark": "p(parchment800)",
				"ultraDark": "p(ink900)",
				"transparent": "p(parchment800)"
			},
			"theme.colors.stageSurface": {
				"light": "p(parchment50)",
				"dark": "p(parchment800)",
				"ultraDark": "p(ink900)",
				"transparent": "p(color-b835322d)"
			},
			"theme.colors.overlay": {
				"light": "p(parchment50)",
				"dark": "p(parchment800)",
				"ultraDark": "p(ink850)",
				"transparent": "p(parchment800)"
			},
			"theme.colors.surfaceRaised": {
				"light": "p(parchment50)",
				"dark": "p(parchment800)",
				"ultraDark": "p(ink850)",
				"transparent": "p(parchment800)"
			},
			"theme.colors.modalScrim": {
				"light": "p(scrim)",
				"dark": "p(scrim)",
				"ultraDark": "p(scrim)",
				"transparent": "p(scrim)"
			},
			"theme.colors.guide": {
				"light": "p(parchment250)",
				"dark": "p(parchment700)",
				"ultraDark": "p(ink450)",
				"transparent": "p(parchment700)"
			},
			"theme.colors.divider": {
				"light": "p(parchment250)",
				"dark": "p(parchment700)",
				"ultraDark": "p(ink800)",
				"transparent": "p(parchment700)"
			},
			"theme.colors.pagePattern": {
				"light": "p(parchment250)",
				"dark": "p(parchment700)",
				"ultraDark": "p(ink650)",
				"transparent": "p(parchment700)"
			},
			"theme.colors.text": {
				"light": "p(parchment925)",
				"dark": "p(parchment75)",
				"ultraDark": "p(ink100)",
				"transparent": "p(parchment75)"
			},
			"theme.colors.textMuted": {
				"light": "p(parchment550)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink350)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.textFaint": {
				"light": "p(parchment550)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink400)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.border": {
				"light": "p(parchment250)",
				"dark": "p(parchment700)",
				"ultraDark": "p(transparent)",
				"transparent": "p(parchment700)"
			},
			"theme.colors.borderStrong": {
				"light": "p(parchment250)",
				"dark": "p(parchment700)",
				"ultraDark": "p(transparent)",
				"transparent": "p(parchment700)"
			},
			"theme.colors.brand": {
				"light": "p(ink900)",
				"dark": "p(ink50)",
				"ultraDark": "p(ink100)",
				"transparent": "p(ink50)"
			},
			"theme.colors.accent": {
				"light": "p(ink900)",
				"dark": "p(ink50)",
				"ultraDark": "p(ink100)",
				"transparent": "p(ink50)"
			},
			"theme.colors.accentSoft": {
				"light": "p(ink200)",
				"dark": "p(ink750)",
				"ultraDark": "p(ink850)",
				"transparent": "p(ink750)"
			},
			"theme.colors.interaction": {
				"light": "p(ink900)",
				"dark": "p(ink50)",
				"ultraDark": "p(ink100)",
				"transparent": "p(ink50)"
			},
			"theme.colors.interactionSoft": {
				"light": "p(ink200)",
				"dark": "p(ink750)",
				"ultraDark": "p(ink850)",
				"transparent": "p(ink750)"
			},
			"theme.colors.success": {
				"light": "p(green500)",
				"dark": "p(green500)",
				"ultraDark": "p(green500)",
				"transparent": "p(green500)"
			},
			"theme.colors.warning": {
				"light": "p(amber500)",
				"dark": "p(amber500)",
				"ultraDark": "p(amber500)",
				"transparent": "p(amber500)"
			},
			"theme.colors.danger": {
				"light": "p(red300)",
				"dark": "p(red300)",
				"ultraDark": "p(red300)",
				"transparent": "p(red300)"
			},
			"theme.colors.info": {
				"light": "p(blue500)",
				"dark": "p(blue500)",
				"ultraDark": "p(blue500)",
				"transparent": "p(blue500)"
			},
			"theme.colors.onStatus": {
				"light": "p(ink50)",
				"dark": "p(ink50)",
				"ultraDark": "p(ink50)",
				"transparent": "p(ink50)"
			},
			"theme.colors.onLightBackground": {
				"light": "p(parchment925)",
				"dark": "p(parchment925)",
				"ultraDark": "p(ink900)",
				"transparent": "p(parchment925)"
			},
			"theme.colors.onDarkBackground": {
				"light": "p(parchment75)",
				"dark": "p(parchment75)",
				"ultraDark": "p(ink50)",
				"transparent": "p(parchment75)"
			},
			"theme.colors.mutedOnLightBackground": {
				"light": "p(parchment550)",
				"dark": "p(parchment550)",
				"ultraDark": "p(ink550)",
				"transparent": "p(parchment550)"
			},
			"theme.colors.mutedOnDarkBackground": {
				"light": "p(parchment350)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink300)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.faintOnBackground": {
				"light": "p(parchment550)",
				"dark": "p(parchment350)",
				"ultraDark": "p(ink400)",
				"transparent": "p(parchment350)"
			},
			"theme.colors.transparent": {
				"light": "p(transparent)",
				"dark": "p(transparent)",
				"ultraDark": "p(transparent)",
				"transparent": "p(transparent)"
			},
			"theme.typography.sansFamily": {
				"light": "p(family-packages-kallopis-noto-sans-tc)",
				"dark": "p(family-packages-kallopis-noto-sans-tc)",
				"ultraDark": "p(family-packages-kallopis-noto-sans-tc)",
				"transparent": "p(family-packages-kallopis-noto-sans-tc)"
			},
			"theme.typography.sansFallback": {
				"light": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"dark": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"ultraDark": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]",
				"transparent": "[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]"
			},
			"theme.typography.monoFamily": {
				"light": "p(family-packages-kallopis-ibm-plex-mono)",
				"dark": "p(family-packages-kallopis-ibm-plex-mono)",
				"ultraDark": "p(family-packages-kallopis-ibm-plex-mono)",
				"transparent": "p(family-packages-kallopis-ibm-plex-mono)"
			},
			"theme.typography.monoFallback": {
				"light": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"dark": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"ultraDark": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]",
				"transparent": "[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]"
			},
			"theme.typography.uiFamily": {
				"light": "p(family-packages-kallopis-noto-sans-tc)",
				"dark": "p(family-packages-kallopis-noto-sans-tc)",
				"ultraDark": "p(family-packages-kallopis-noto-sans-tc)",
				"transparent": "p(family-packages-kallopis-noto-sans-tc)"
			},
			"theme.typography.bodyFamily": {
				"light": "p(family-packages-kallopis-noto-sans-tc)",
				"dark": "p(family-packages-kallopis-noto-sans-tc)",
				"ultraDark": "p(family-packages-kallopis-noto-sans-tc)",
				"transparent": "p(family-packages-kallopis-noto-sans-tc)"
			},
			"theme.typography.codeFamily": {
				"light": "p(family-packages-kallopis-ibm-plex-mono)",
				"dark": "p(family-packages-kallopis-ibm-plex-mono)",
				"ultraDark": "p(family-packages-kallopis-ibm-plex-mono)",
				"transparent": "p(family-packages-kallopis-ibm-plex-mono)"
			},
			"theme.typography.micro": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.typography.caption": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.typography.sub": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.typography.body": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.typography.lead": {
				"light": "p(font500)",
				"dark": "p(font500)",
				"ultraDark": "p(font500)",
				"transparent": "p(font500)"
			},
			"theme.typography.h4": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.typography.h3": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.typography.h2": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.typography.h1": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.typography.display": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.typography.label": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.typography.section": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.typography.headingSmall": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.typography.heading": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.typography.title": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.typography.microLeading": {
				"light": "p(leading120)",
				"dark": "p(leading120)",
				"ultraDark": "p(leading120)",
				"transparent": "p(leading120)"
			},
			"theme.typography.captionLeading": {
				"light": "p(leading133)",
				"dark": "p(leading133)",
				"ultraDark": "p(leading133)",
				"transparent": "p(leading133)"
			},
			"theme.typography.subLeading": {
				"light": "p(leading142)",
				"dark": "p(leading142)",
				"ultraDark": "p(leading142)",
				"transparent": "p(leading142)"
			},
			"theme.typography.bodyLeading": {
				"light": "p(leading150)",
				"dark": "p(leading150)",
				"ultraDark": "p(leading150)",
				"transparent": "p(leading150)"
			},
			"theme.typography.leadLeading": {
				"light": "p(leading155)",
				"dark": "p(leading155)",
				"ultraDark": "p(leading155)",
				"transparent": "p(leading155)"
			},
			"theme.typography.h4Leading": {
				"light": "p(leading127)",
				"dark": "p(leading127)",
				"ultraDark": "p(leading127)",
				"transparent": "p(leading127)"
			},
			"theme.typography.h3Leading": {
				"light": "p(leading128)",
				"dark": "p(leading128)",
				"ultraDark": "p(leading128)",
				"transparent": "p(leading128)"
			},
			"theme.typography.h2Leading": {
				"light": "p(leading122)",
				"dark": "p(leading122)",
				"ultraDark": "p(leading122)",
				"transparent": "p(leading122)"
			},
			"theme.typography.h1Leading": {
				"light": "p(leading116)",
				"dark": "p(leading116)",
				"ultraDark": "p(leading116)",
				"transparent": "p(leading116)"
			},
			"theme.typography.displayLeading": {
				"light": "p(leading100)",
				"dark": "p(leading100)",
				"ultraDark": "p(leading100)",
				"transparent": "p(leading100)"
			},
			"theme.typography.headingLeading": {
				"light": "p(leading122)",
				"dark": "p(leading122)",
				"ultraDark": "p(leading122)",
				"transparent": "p(leading122)"
			},
			"theme.typography.codeLeading": {
				"light": "p(leading142)",
				"dark": "p(leading142)",
				"ultraDark": "p(leading142)",
				"transparent": "p(leading142)"
			},
			"theme.typography.readingLeading": {
				"light": "p(leading155)",
				"dark": "p(leading155)",
				"ultraDark": "p(leading155)",
				"transparent": "p(leading155)"
			},
			"theme.typography.labelLeading": {
				"light": "p(leading133)",
				"dark": "p(leading133)",
				"ultraDark": "p(leading133)",
				"transparent": "p(leading133)"
			},
			"theme.typography.labelTracking": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.typography.displayTracking": {
				"light": "p(trackingTight)",
				"dark": "p(trackingTight)",
				"ultraDark": "p(trackingTight)",
				"transparent": "p(trackingTight)"
			},
			"theme.typography.regular": {
				"light": "p(weight400)",
				"dark": "p(weight400)",
				"ultraDark": "p(weight400)",
				"transparent": "p(weight400)"
			},
			"theme.typography.medium": {
				"light": "p(weight400)",
				"dark": "p(weight400)",
				"ultraDark": "p(weight400)",
				"transparent": "p(weight400)"
			},
			"theme.typography.semiBold": {
				"light": "p(weight600)",
				"dark": "p(weight600)",
				"ultraDark": "p(weight600)",
				"transparent": "p(weight600)"
			},
			"theme.typography.bold": {
				"light": "p(weight700)",
				"dark": "p(weight700)",
				"ultraDark": "p(weight700)",
				"transparent": "p(weight700)"
			},
			"theme.typography.extraBold": {
				"light": "p(weight700)",
				"dark": "p(weight700)",
				"ultraDark": "p(weight700)",
				"transparent": "p(weight700)"
			},
			"theme.typography.strong": {
				"light": "p(weight600)",
				"dark": "p(weight600)",
				"ultraDark": "p(weight600)",
				"transparent": "p(weight600)"
			},
			"theme.spacing.space0_5": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.spacing.space1": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.space2": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.space3": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.space4": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.space6": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.space8": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.space12": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.space16": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.spacing.space24": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.spacing.hairline": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.spacing.tight": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.contentInlineGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.contentStackGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.contentInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.controlContentGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.controlInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.actionGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromeGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromePanelInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.chromeToolbarGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationItemInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationRailInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationRailItemGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayContentInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayHeadingGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.overlayItemGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.navigationSectionGap": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.spacing.appFrameInset": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.windowHeaderMargin": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.dockMargin": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.spacing.base": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.comfortable": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.loose": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.section": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.sectionLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.page": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.spacing.pageLarge": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.spacing.controlPaddingXSmall": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.controlPaddingX": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.controlPaddingXLarge": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.controlPaddingXXLarge": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.controlPaddingY": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.containerPadding": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.itemGap": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.spacing.groupGap": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.controlHeightXSmall": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.spacing.controlHeightSmall": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.spacing.controlHeight": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.spacing.controlHeightLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.controlHeightXLarge": {
				"light": "p(length-56)",
				"dark": "p(length-56)",
				"ultraDark": "p(length-56)",
				"transparent": "p(length-56)"
			},
			"theme.spacing.iconSmall": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.spacing.iconBase": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.spacing.iconGlyph": {
				"light": "p(font500)",
				"dark": "p(font500)",
				"ultraDark": "p(font500)",
				"transparent": "p(font500)"
			},
			"theme.spacing.icon": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.spacing.iconMedium": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.iconLarge": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.chromeHeader": {
				"light": "p(length-60)",
				"dark": "p(length-60)",
				"ultraDark": "p(length-60)",
				"transparent": "p(length-60)"
			},
			"theme.spacing.chromeStatusBar": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.spacing.chromeRail": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.spacing.chromeTab": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.iconButton": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.spacing.iconTiny": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.spacing.indicatorDot": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.spacing.indicatorDotLarge": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.spacing.noticeIconSlot": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.spacing.toastIconSlot": {
				"light": "p(font600)",
				"dark": "p(font600)",
				"ultraDark": "p(font600)",
				"transparent": "p(font600)"
			},
			"theme.spacing.gutterNumber": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.gutterMarker": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.spacing.micro": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.spacing.calendarContentCell": {
				"light": "p(length-74)",
				"dark": "p(length-74)",
				"ultraDark": "p(length-74)",
				"transparent": "p(length-74)"
			},
			"theme.spacing.gridTileWidth": {
				"light": "p(length-170)",
				"dark": "p(length-170)",
				"ultraDark": "p(length-170)",
				"transparent": "p(length-170)"
			},
			"theme.spacing.iconMicro": {
				"light": "p(length-11)",
				"dark": "p(length-11)",
				"ultraDark": "p(length-11)",
				"transparent": "p(length-11)"
			},
			"theme.spacing.avatarSmall": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.spacing.progressTrack": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.spacing.skeletonLine": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.spacing.railItem": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.shape.none": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.shape.sm": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.control": {
				"light": "p(radius150)",
				"dark": "p(radius150)",
				"ultraDark": "p(radius150)",
				"transparent": "p(radius150)"
			},
			"theme.shape.controlInner": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.shape.toggleTrack": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.shape.card": {
				"light": "p(length-7)",
				"dark": "p(length-7)",
				"ultraDark": "p(length-7)",
				"transparent": "p(length-7)"
			},
			"theme.shape.panel": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.shape.pill": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.shape.hairline": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.shape.stroke": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.dashedLength": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.shape.dashedGap": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.shape.dashedOpacity": {
				"light": "p(opacity780)",
				"dark": "p(opacity780)",
				"ultraDark": "p(opacity780)",
				"transparent": "p(opacity780)"
			},
			"theme.motion.themeTransition": {
				"light": "p(duration0)",
				"dark": "p(duration0)",
				"ultraDark": "p(duration0)",
				"transparent": "p(duration0)"
			},
			"theme.motion.styleTransition": {
				"light": "p(duration0)",
				"dark": "p(duration0)",
				"ultraDark": "p(duration0)",
				"transparent": "p(duration0)"
			},
			"theme.motion.stateTransition": {
				"light": "p(duration150)",
				"dark": "p(duration150)",
				"ultraDark": "p(duration150)",
				"transparent": "p(duration150)"
			},
			"theme.motion.overlayEnter": {
				"light": "p(duration150)",
				"dark": "p(duration150)",
				"ultraDark": "p(duration150)",
				"transparent": "p(duration150)"
			},
			"theme.motion.overlayExit": {
				"light": "p(duration100)",
				"dark": "p(duration100)",
				"ultraDark": "p(duration100)",
				"transparent": "p(duration100)"
			},
			"theme.motion.toastDwell": {
				"light": "p(duration500)",
				"dark": "p(duration500)",
				"ultraDark": "p(duration500)",
				"transparent": "p(duration500)"
			},
			"theme.motion.tooltipDelay": {
				"light": "p(duration400)",
				"dark": "p(duration400)",
				"ultraDark": "p(duration400)",
				"transparent": "p(duration400)"
			},
			"theme.motion.tooltipDwell": {
				"light": "p(duration-4000)",
				"dark": "p(duration-4000)",
				"ultraDark": "p(duration-4000)",
				"transparent": "p(duration-4000)"
			},
			"theme.motion.spinnerCycle": {
				"light": "p(duration-1000)",
				"dark": "p(duration-1000)",
				"ultraDark": "p(duration-1000)",
				"transparent": "p(duration-1000)"
			},
			"theme.motion.longPressThreshold": {
				"light": "p(duration500)",
				"dark": "p(duration500)",
				"ultraDark": "p(duration500)",
				"transparent": "p(duration500)"
			},
			"theme.motion.standard": {
				"light": "p(easeStandard)",
				"dark": "p(easeStandard)",
				"ultraDark": "p(easeStandard)",
				"transparent": "p(easeStandard)"
			},
			"theme.motion.emphasized": {
				"light": "p(easeEmphasized)",
				"dark": "p(easeEmphasized)",
				"ultraDark": "p(easeEmphasized)",
				"transparent": "p(easeEmphasized)"
			},
			"theme.surface.separation": {
				"light": "p(string-shadow)",
				"dark": "p(string-shadow)",
				"ultraDark": "p(string-shadow)",
				"transparent": "p(string-shadow)"
			},
			"theme.surface.overlayBlur": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.surface.overlaySpread": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.surface.overlayOffsetY": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.surface.overlayShadowOpacity": {
				"light": "p(opacity-0_13333333333333333)",
				"dark": "p(opacity-0_13333333333333333)",
				"ultraDark": "p(opacity-0_13333333333333333)",
				"transparent": "p(opacity-0_13333333333333333)"
			},
			"theme.surface.scrimOpacity": {
				"light": "p(opacity-0_6)",
				"dark": "p(opacity-0_6)",
				"ultraDark": "p(opacity-0_6)",
				"transparent": "p(opacity-0_6)"
			},
			"theme.surface.selectionWashOpacity": {
				"light": "p(opacity100)",
				"dark": "p(opacity100)",
				"ultraDark": "p(opacity100)",
				"transparent": "p(opacity100)"
			},
			"theme.surface.focusWashOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.statusFillOpacity": {
				"light": "p(opacity160)",
				"dark": "p(opacity160)",
				"ultraDark": "p(opacity160)",
				"transparent": "p(opacity160)"
			},
			"theme.surface.pressProgressOpacity": {
				"light": "p(opacity550)",
				"dark": "p(opacity550)",
				"ultraDark": "p(opacity550)",
				"transparent": "p(opacity550)"
			},
			"theme.surface.diffFillOpacity": {
				"light": "p(opacity120)",
				"dark": "p(opacity120)",
				"ultraDark": "p(opacity120)",
				"transparent": "p(opacity120)"
			},
			"theme.surface.gridLineOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.veilOpacity": {
				"light": "p(opacity820)",
				"dark": "p(opacity820)",
				"ultraDark": "p(opacity820)",
				"transparent": "p(opacity820)"
			},
			"theme.surface.statusRowOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.statusRowSelectedOpacity": {
				"light": "p(opacity320)",
				"dark": "p(opacity320)",
				"ultraDark": "p(opacity320)",
				"transparent": "p(opacity320)"
			},
			"theme.surface.statusRowOpacityDark": {
				"light": "p(opacity280)",
				"dark": "p(opacity280)",
				"ultraDark": "p(opacity280)",
				"transparent": "p(opacity280)"
			},
			"theme.surface.statusRowSelectedOpacityDark": {
				"light": "p(opacity480)",
				"dark": "p(opacity480)",
				"ultraDark": "p(opacity480)",
				"transparent": "p(opacity480)"
			},
			"theme.surface.frostedOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.frostedVeilOpacity": {
				"light": "p(opacity120)",
				"dark": "p(opacity120)",
				"ultraDark": "p(opacity120)",
				"transparent": "p(opacity120)"
			},
			"theme.surface.backdropBlurSigma": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.surface.dragOpacity": {
				"light": "p(opacity820)",
				"dark": "p(opacity820)",
				"ultraDark": "p(opacity820)",
				"transparent": "p(opacity820)"
			},
			"theme.surface.dragSourceOpacity": {
				"light": "p(opacity350)",
				"dark": "p(opacity350)",
				"ultraDark": "p(opacity350)",
				"transparent": "p(opacity350)"
			},
			"theme.surface.themePreviewDisabledOpacity": {
				"light": "p(opacity620)",
				"dark": "p(opacity620)",
				"ultraDark": "p(opacity620)",
				"transparent": "p(opacity620)"
			},
			"theme.surface.listStatusOpacity": {
				"light": "p(opacity140)",
				"dark": "p(opacity140)",
				"ultraDark": "p(opacity140)",
				"transparent": "p(opacity140)"
			},
			"theme.surface.listStatusSelectedOpacity": {
				"light": "p(opacity320)",
				"dark": "p(opacity320)",
				"ultraDark": "p(opacity320)",
				"transparent": "p(opacity320)"
			},
			"theme.surface.accentSoftOpacityLight": {
				"light": "p(opacity160)",
				"dark": "p(opacity160)",
				"ultraDark": "p(opacity160)",
				"transparent": "p(opacity160)"
			},
			"theme.surface.accentSoftOpacityDark": {
				"light": "p(opacity220)",
				"dark": "p(opacity220)",
				"ultraDark": "p(opacity220)",
				"transparent": "p(opacity220)"
			},
			"theme.surface.windowPaneOpacityLight": {
				"light": "p(opacity-0_88)",
				"dark": "p(opacity-0_88)",
				"ultraDark": "p(opacity-0_88)",
				"transparent": "p(opacity-0_88)"
			},
			"theme.surface.windowPaneOpacityDark": {
				"light": "p(opacity720)",
				"dark": "p(opacity720)",
				"ultraDark": "p(opacity720)",
				"transparent": "p(opacity720)"
			},
			"theme.surface.invalidFillOpacity": {
				"light": "p(opacity180)",
				"dark": "p(opacity180)",
				"ultraDark": "p(opacity180)",
				"transparent": "p(opacity180)"
			},
			"theme.surface.contactBlur": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.surface.contactOffsetY": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.surface.contactShadowOpacity": {
				"light": "p(opacity-0_13333333333333333)",
				"dark": "p(opacity-0_13333333333333333)",
				"ultraDark": "p(opacity-0_13333333333333333)",
				"transparent": "p(opacity-0_13333333333333333)"
			},
			"theme.surface.overlayShadowColor": {
				"light": "p(ink1000)",
				"dark": "p(ink1000)",
				"ultraDark": "p(ink1000)",
				"transparent": "p(ink1000)"
			},
			"theme.components.buttonRadius": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.components.buttonPaddingX": {
				"light": "s(theme.spacing.controlPaddingX)",
				"dark": "s(theme.spacing.controlPaddingX)",
				"ultraDark": "s(theme.spacing.controlPaddingX)",
				"transparent": "s(theme.spacing.controlPaddingX)"
			},
			"theme.components.buttonPaddingY": {
				"light": "s(theme.spacing.controlPaddingY)",
				"dark": "s(theme.spacing.controlPaddingY)",
				"ultraDark": "s(theme.spacing.controlPaddingY)",
				"transparent": "s(theme.spacing.controlPaddingY)"
			},
			"theme.components.buttonHeight": {
				"light": "s(theme.geometry.control.buttonHeight)",
				"dark": "s(theme.geometry.control.buttonHeight)",
				"ultraDark": "s(theme.geometry.control.buttonHeight)",
				"transparent": "s(theme.geometry.control.buttonHeight)"
			},
			"theme.components.buttonBorderWidth": {
				"light": "s(theme.shape.none)",
				"dark": "s(theme.shape.none)",
				"ultraDark": "s(theme.shape.none)",
				"transparent": "s(theme.shape.none)"
			},
			"theme.components.fieldRadius": {
				"light": "s(theme.shape.control)",
				"dark": "s(theme.shape.control)",
				"ultraDark": "s(theme.shape.control)",
				"transparent": "s(theme.shape.control)"
			},
			"theme.components.fieldPaddingX": {
				"light": "s(theme.spacing.controlInset)",
				"dark": "s(theme.spacing.controlInset)",
				"ultraDark": "s(theme.spacing.controlInset)",
				"transparent": "s(theme.spacing.controlInset)"
			},
			"theme.components.fieldHeight": {
				"light": "s(theme.geometry.control.fieldHeight)",
				"dark": "s(theme.geometry.control.fieldHeight)",
				"ultraDark": "s(theme.geometry.control.fieldHeight)",
				"transparent": "s(theme.geometry.control.fieldHeight)"
			},
			"theme.components.fieldBorderWidth": {
				"light": "s(theme.shape.none)",
				"dark": "s(theme.shape.none)",
				"ultraDark": "s(theme.shape.none)",
				"transparent": "s(theme.shape.none)"
			},
			"theme.components.menuRadius": {
				"light": "s(theme.shape.card)",
				"dark": "s(theme.shape.card)",
				"ultraDark": "s(theme.shape.card)",
				"transparent": "s(theme.shape.card)"
			},
			"theme.components.menuPadding": {
				"light": "s(theme.spacing.overlayContentInset)",
				"dark": "s(theme.spacing.overlayContentInset)",
				"ultraDark": "s(theme.spacing.overlayContentInset)",
				"transparent": "s(theme.spacing.overlayContentInset)"
			},
			"theme.components.menuItemHeight": {
				"light": "s(theme.geometry.layout.menuItemHeight)",
				"dark": "s(theme.geometry.layout.menuItemHeight)",
				"ultraDark": "s(theme.geometry.layout.menuItemHeight)",
				"transparent": "s(theme.geometry.layout.menuItemHeight)"
			},
			"theme.components.cardRadius": {
				"light": "s(theme.shape.card)",
				"dark": "s(theme.shape.card)",
				"ultraDark": "s(theme.shape.card)",
				"transparent": "s(theme.shape.card)"
			},
			"theme.components.cardPadding": {
				"light": "s(theme.spacing.containerPadding)",
				"dark": "s(theme.spacing.containerPadding)",
				"ultraDark": "s(theme.spacing.containerPadding)",
				"transparent": "s(theme.spacing.containerPadding)"
			},
			"theme.components.badgeRadius": {
				"light": "s(theme.shape.pill)",
				"dark": "s(theme.shape.pill)",
				"ultraDark": "s(theme.shape.pill)",
				"transparent": "s(theme.shape.pill)"
			},
			"theme.components.badgePaddingX": {
				"light": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"dark": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"ultraDark": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))",
				"transparent": "add(s(theme.spacing.tight), s(theme.spacing.space0_5))"
			},
			"theme.geometry.control.switchTrackWidth": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.switchTrackHeight": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.geometry.control.switchThumb": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.geometry.control.buttonHeightXSmall": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.geometry.control.buttonHeightSmall": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.control.buttonHeight": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.buttonHeightLarge": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.geometry.control.buttonHeightXLarge": {
				"light": "p(space1200)",
				"dark": "p(space1200)",
				"ultraDark": "p(space1200)",
				"transparent": "p(space1200)"
			},
			"theme.geometry.control.pageBackgroundHitRadius": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.presenceMarkerExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.colorPickerCursorRadius": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.swatchExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.segmentedProgressHeight": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.control.fieldHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.control.selectionControl": {
				"light": "p(length-15)",
				"dark": "p(length-15)",
				"ultraDark": "p(length-15)",
				"transparent": "p(length-15)"
			},
			"theme.geometry.control.selectionIndicatorInset": {
				"light": "p(length-3_5)",
				"dark": "p(length-3_5)",
				"ultraDark": "p(length-3_5)",
				"transparent": "p(length-3_5)"
			},
			"theme.geometry.control.selectionIcon": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.geometry.control.toggleWidth": {
				"light": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"dark": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"ultraDark": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))",
				"transparent": "add(s(theme.spacing.iconButton),s(theme.spacing.space0_5))"
			},
			"theme.geometry.control.toggleHeight": {
				"light": "p(space400)",
				"dark": "p(space400)",
				"ultraDark": "p(space400)",
				"transparent": "p(space400)"
			},
			"theme.geometry.control.toggleThumb": {
				"light": "p(font300)",
				"dark": "p(font300)",
				"ultraDark": "p(font300)",
				"transparent": "p(font300)"
			},
			"theme.geometry.control.toggleInset": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.control.segmentedDenseHeight": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.geometry.control.segmentedDenseInset": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.geometry.control.segmentedDenseContentInset": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.geometry.control.segmentedDenseItemHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.control.slidingSelectionHeight": {
				"light": "p(font800)",
				"dark": "p(font800)",
				"ultraDark": "p(font800)",
				"transparent": "p(font800)"
			},
			"theme.geometry.control.slidingSelectionSegmentWidth": {
				"light": "p(length-41_4)",
				"dark": "p(length-41_4)",
				"ultraDark": "p(length-41_4)",
				"transparent": "p(length-41_4)"
			},
			"theme.geometry.control.slidingSelectionPadding": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.geometry.control.slidingSelectionIndicatorHeight": {
				"light": "p(length-30)",
				"dark": "p(length-30)",
				"ultraDark": "p(length-30)",
				"transparent": "p(length-30)"
			},
			"theme.geometry.control.scrollbarThickness": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.geometry.control.sliderTrackHeight": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.geometry.control.colorPlaneExtent": {
				"light": "p(length-168)",
				"dark": "p(length-168)",
				"ultraDark": "p(length-168)",
				"transparent": "p(length-168)"
			},
			"theme.geometry.control.textFieldIndicatorHeightFactor": {
				"light": "p(ratio-0_4)",
				"dark": "p(ratio-0_4)",
				"ultraDark": "p(ratio-0_4)",
				"transparent": "p(ratio-0_4)"
			},
			"theme.geometry.control.textFieldLineHeightFactor": {
				"light": "p(leading300)",
				"dark": "p(leading300)",
				"ultraDark": "p(leading300)",
				"transparent": "p(leading300)"
			},
			"theme.geometry.control.textFieldMinLines": {
				"light": "p(count-4)",
				"dark": "p(count-4)",
				"ultraDark": "p(count-4)",
				"transparent": "p(count-4)"
			},
			"theme.geometry.control.textFieldMaxLines": {
				"light": "p(count-8)",
				"dark": "p(count-8)",
				"ultraDark": "p(count-8)",
				"transparent": "p(count-8)"
			},
			"theme.geometry.control.fileExplorerRowHeightAdjustment": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.geometry.data.codeActionButtonSize": {
				"light": "p(length-26)",
				"dark": "p(length-26)",
				"ultraDark": "p(length-26)",
				"transparent": "p(length-26)"
			},
			"theme.geometry.data.codeHeaderHeight": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.data.codeTerminalDot": {
				"light": "p(space100)",
				"dark": "p(space100)",
				"ultraDark": "p(space100)",
				"transparent": "p(space100)"
			},
			"theme.geometry.data.codeTerminalDotGap": {
				"light": "p(length-3)",
				"dark": "p(length-3)",
				"ultraDark": "p(length-3)",
				"transparent": "p(length-3)"
			},
			"theme.geometry.data.codeHeaderPaddingX": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.geometry.data.codeBodyPaddingX": {
				"light": "p(space250)",
				"dark": "p(space250)",
				"ultraDark": "p(space250)",
				"transparent": "p(space250)"
			},
			"theme.geometry.data.codeLineNumberWidth": {
				"light": "p(space800)",
				"dark": "p(space800)",
				"ultraDark": "p(space800)",
				"transparent": "p(space800)"
			},
			"theme.geometry.data.codeWrappedLineWidth": {
				"light": "p(length-520)",
				"dark": "p(length-520)",
				"ultraDark": "p(length-520)",
				"transparent": "p(length-520)"
			},
			"theme.geometry.data.codeMaximumHeight": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.data.codeCollapsedHeight": {
				"light": "p(length-120)",
				"dark": "p(length-120)",
				"ultraDark": "p(length-120)",
				"transparent": "p(length-120)"
			},
			"theme.geometry.data.codeDisclosureSize": {
				"light": "p(length-9)",
				"dark": "p(length-9)",
				"ultraDark": "p(length-9)",
				"transparent": "p(length-9)"
			},
			"theme.geometry.data.filePreviewHeight": {
				"light": "p(length-220)",
				"dark": "p(length-220)",
				"ultraDark": "p(length-220)",
				"transparent": "p(length-220)"
			},
			"theme.geometry.data.previewCardCompactHeight": {
				"light": "p(space1600)",
				"dark": "p(space1600)",
				"ultraDark": "p(space1600)",
				"transparent": "p(space1600)"
			},
			"theme.geometry.data.previewCardStandardHeight": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.geometry.data.previewCardLargeHeight": {
				"light": "p(length-192)",
				"dark": "p(length-192)",
				"ultraDark": "p(length-192)",
				"transparent": "p(length-192)"
			},
			"theme.geometry.data.dateGridCellHeight": {
				"light": "p(length-128)",
				"dark": "p(length-128)",
				"ultraDark": "p(length-128)",
				"transparent": "p(length-128)"
			},
			"theme.geometry.data.keyValueLabelWidthCompact": {
				"light": "p(space2400)",
				"dark": "p(space2400)",
				"ultraDark": "p(space2400)",
				"transparent": "p(space2400)"
			},
			"theme.geometry.data.keyValueLabelWidthStandard": {
				"light": "p(length-112)",
				"dark": "p(length-112)",
				"ultraDark": "p(length-112)",
				"transparent": "p(length-112)"
			},
			"theme.geometry.data.stepperMarkerSize": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.data.stepperLabelWidth": {
				"light": "p(length-60)",
				"dark": "p(length-60)",
				"ultraDark": "p(length-60)",
				"transparent": "p(length-60)"
			},
			"theme.geometry.data.progressIndeterminateFraction": {
				"light": "p(ratio-0_35)",
				"dark": "p(ratio-0_35)",
				"ultraDark": "p(ratio-0_35)",
				"transparent": "p(ratio-0_35)"
			},
			"theme.geometry.data.placeholderMinimumHeight": {
				"light": "p(length-120)",
				"dark": "p(length-120)",
				"ultraDark": "p(length-120)",
				"transparent": "p(length-120)"
			},
			"theme.geometry.data.placeholderContentPaddingY": {
				"light": "p(space300)",
				"dark": "p(space300)",
				"ultraDark": "p(space300)",
				"transparent": "p(space300)"
			},
			"theme.geometry.data.placeholderActionPaddingY": {
				"light": "p(length-5)",
				"dark": "p(length-5)",
				"ultraDark": "p(length-5)",
				"transparent": "p(length-5)"
			},
			"theme.geometry.data.placeholderHatchBand": {
				"light": "p(length-10_5)",
				"dark": "p(length-10_5)",
				"ultraDark": "p(length-10_5)",
				"transparent": "p(length-10_5)"
			},
			"theme.geometry.data.placeholderHatchGap": {
				"light": "p(length-10_5)",
				"dark": "p(length-10_5)",
				"ultraDark": "p(length-10_5)",
				"transparent": "p(length-10_5)"
			},
			"theme.geometry.data.placeholderLabelTracking": {
				"light": "p(trackingWider)",
				"dark": "p(trackingWider)",
				"ultraDark": "p(trackingWider)",
				"transparent": "p(trackingWider)"
			},
			"theme.geometry.data.placeholderDetailMaximumWidth": {
				"light": "p(length-336)",
				"dark": "p(length-336)",
				"ultraDark": "p(length-336)",
				"transparent": "p(length-336)"
			},
			"theme.geometry.data.spinnerSquareFactor": {
				"light": "p(ratio-0_32)",
				"dark": "p(ratio-0_32)",
				"ultraDark": "p(ratio-0_32)",
				"transparent": "p(ratio-0_32)"
			},
			"theme.geometry.data.spinnerOrbitFactor": {
				"light": "p(ratio-0_22)",
				"dark": "p(ratio-0_22)",
				"ultraDark": "p(ratio-0_22)",
				"transparent": "p(ratio-0_22)"
			},
			"theme.geometry.data.spinnerCornerFactor": {
				"light": "p(ratio-0_06)",
				"dark": "p(ratio-0_06)",
				"ultraDark": "p(ratio-0_06)",
				"transparent": "p(ratio-0_06)"
			},
			"theme.geometry.layout.drawerWidth": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.layout.drawerHeight": {
				"light": "p(length-320)",
				"dark": "p(length-320)",
				"ultraDark": "p(length-320)",
				"transparent": "p(length-320)"
			},
			"theme.geometry.layout.resizeHandleExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.overlayViewportInset": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.railDropTargetExtent": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.disclosureIconSize": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.treeLeadingGap": {
				"light": "p(ratio-8)",
				"dark": "p(ratio-8)",
				"ultraDark": "p(ratio-8)",
				"transparent": "p(ratio-8)"
			},
			"theme.geometry.layout.tooltipOffsetX": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.primaryPaneWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.secondaryPaneWidth": {
				"light": "p(length-350)",
				"dark": "p(length-350)",
				"ultraDark": "p(length-350)",
				"transparent": "p(length-350)"
			},
			"theme.geometry.layout.primaryPaneBreakpoint": {
				"light": "p(length-400)",
				"dark": "p(length-400)",
				"ultraDark": "p(length-400)",
				"transparent": "p(length-400)"
			},
			"theme.geometry.layout.primaryPaneContentBreakpoint": {
				"light": "p(length-800)",
				"dark": "p(length-800)",
				"ultraDark": "p(length-800)",
				"transparent": "p(length-800)"
			},
			"theme.geometry.layout.responsivePaneBreakpoint": {
				"light": "p(length-960)",
				"dark": "p(length-960)",
				"ultraDark": "p(length-960)",
				"transparent": "p(length-960)"
			},
			"theme.geometry.layout.secondaryPaneBreakpoint": {
				"light": "p(length-1120)",
				"dark": "p(length-1120)",
				"ultraDark": "p(length-1120)",
				"transparent": "p(length-1120)"
			},
			"theme.geometry.layout.menuWidth": {
				"light": "p(length-200)",
				"dark": "p(length-200)",
				"ultraDark": "p(length-200)",
				"transparent": "p(length-200)"
			},
			"theme.geometry.layout.commandMenuWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.menuHeaderHeight": {
				"light": "p(font700)",
				"dark": "p(font700)",
				"ultraDark": "p(font700)",
				"transparent": "p(font700)"
			},
			"theme.geometry.layout.menuItemHeight": {
				"light": "p(space1000)",
				"dark": "p(space1000)",
				"ultraDark": "p(space1000)",
				"transparent": "p(space1000)"
			},
			"theme.geometry.layout.dialogMaximumWidth": {
				"light": "p(length-520)",
				"dark": "p(length-520)",
				"ultraDark": "p(length-520)",
				"transparent": "p(length-520)"
			},
			"theme.geometry.layout.toastMaximumWidth": {
				"light": "p(length-360)",
				"dark": "p(length-360)",
				"ultraDark": "p(length-360)",
				"transparent": "p(length-360)"
			},
			"theme.geometry.layout.inlineNoticeBreakpoint": {
				"light": "p(length-480)",
				"dark": "p(length-480)",
				"ultraDark": "p(length-480)",
				"transparent": "p(length-480)"
			},
			"theme.geometry.layout.statusBarBreakpoint": {
				"light": "p(length-400)",
				"dark": "p(length-400)",
				"ultraDark": "p(length-400)",
				"transparent": "p(length-400)"
			},
			"theme.geometry.layout.settingsDialogMaximumWidth": {
				"light": "p(length-1380)",
				"dark": "p(length-1380)",
				"ultraDark": "p(length-1380)",
				"transparent": "p(length-1380)"
			},
			"theme.geometry.layout.settingsDialogMaximumHeight": {
				"light": "p(length-880)",
				"dark": "p(length-880)",
				"ultraDark": "p(length-880)",
				"transparent": "p(length-880)"
			},
			"theme.geometry.layout.settingsPaneGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.layout.settingsNavigationWidth": {
				"light": "p(length-300)",
				"dark": "p(length-300)",
				"ultraDark": "p(length-300)",
				"transparent": "p(length-300)"
			},
			"theme.geometry.layout.settingsNavigationMinimumWidth": {
				"light": "p(length-260)",
				"dark": "p(length-260)",
				"ultraDark": "p(length-260)",
				"transparent": "p(length-260)"
			},
			"theme.geometry.layout.settingsNavigationMaximumWidth": {
				"light": "p(length-360)",
				"dark": "p(length-360)",
				"ultraDark": "p(length-360)",
				"transparent": "p(length-360)"
			},
			"theme.geometry.layout.settingsContentMaximumWidth": {
				"light": "p(length-820)",
				"dark": "p(length-820)",
				"ultraDark": "p(length-820)",
				"transparent": "p(length-820)"
			},
			"theme.geometry.layout.themePreviewTileWidth": {
				"light": "p(length-168)",
				"dark": "p(length-168)",
				"ultraDark": "p(length-168)",
				"transparent": "p(length-168)"
			},
			"theme.geometry.layout.windowHeaderHeight": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.layout.windowHeaderControlSize": {
				"light": "p(space600)",
				"dark": "p(space600)",
				"ultraDark": "p(space600)",
				"transparent": "p(space600)"
			},
			"theme.geometry.layout.windowAppIconSize": {
				"light": "p(length-20)",
				"dark": "p(length-20)",
				"ultraDark": "p(length-20)",
				"transparent": "p(length-20)"
			},
			"theme.geometry.layout.windowIdentityGap": {
				"light": "p(space200)",
				"dark": "p(space200)",
				"ultraDark": "p(space200)",
				"transparent": "p(space200)"
			},
			"theme.geometry.optical.menuIconOffsetY": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.optical.railBadgeInset": {
				"light": "p(space50)",
				"dark": "p(space50)",
				"ultraDark": "p(space50)",
				"transparent": "p(space50)"
			},
			"theme.geometry.optical.statusIconOffsetY": {
				"light": "p(stroke100)",
				"dark": "p(stroke100)",
				"ultraDark": "p(stroke100)",
				"transparent": "p(stroke100)"
			},
			"theme.geometry.optical.monoBaselineOffsetY": {
				"light": "p(length-minus-1)",
				"dark": "p(length-minus-1)",
				"ultraDark": "p(length-minus-1)",
				"transparent": "p(length-minus-1)"
			},
			"theme.geometry.optical.uiBaselineOffsetY": {
				"light": "p(space0)",
				"dark": "p(space0)",
				"ultraDark": "p(space0)",
				"transparent": "p(space0)"
			},
			"theme.dataVisualization.series": {
				"light": "[p(sand500), p(gold500), p(ochre500), p(terracotta500), p(clay500), p(umber500)]",
				"dark": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]",
				"ultraDark": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]",
				"transparent": "[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]"
			},
			"theme.dataVisualization.seriesWash": {
				"light": "[p(sand50), p(gold50), p(ochre50), p(terracotta50), p(clay50), p(umber50)]",
				"dark": "[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]",
				"ultraDark": "[p(sand900), p(gold900), p(ochre900), p(terracotta900), p(clay900), p(umber900)]",
				"transparent": "[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]"
			},
			"theme.dataVisualization.axis": {
				"light": "p(warmNeutral100)",
				"dark": "p(warmNeutral700)",
				"ultraDark": "p(warmNeutral750)",
				"transparent": "p(warmNeutral700)"
			},
			"theme.dataVisualization.grid": {
				"light": "p(warmNeutral50)",
				"dark": "p(warmNeutral800)",
				"ultraDark": "p(warmNeutral900)",
				"transparent": "p(warmNeutral800)"
			},
			"theme.dataVisualization.gridStrong": {
				"light": "p(warmNeutral200)",
				"dark": "p(warmNeutral600)",
				"ultraDark": "p(warmNeutral700)",
				"transparent": "p(warmNeutral600)"
			},
			"theme.dataVisualization.label": {
				"light": "p(ink550)",
				"dark": "p(warmNeutral300)",
				"ultraDark": "p(warmNeutral300)",
				"transparent": "p(warmNeutral300)"
			},
			"theme.dataVisualization.value": {
				"light": "p(ink900)",
				"dark": "p(warmNeutral25)",
				"ultraDark": "p(warmNeutral25)",
				"transparent": "p(warmNeutral25)"
			},
			"theme.dataVisualization.plotBackground": {
				"light": "p(transparent)",
				"dark": "p(transparent)",
				"ultraDark": "p(transparent)",
				"transparent": "p(transparent)"
			},
			"theme.dataVisualization.crosshair": {
				"light": "p(warmNeutral450)",
				"dark": "p(warmNeutral400)",
				"ultraDark": "p(warmNeutral500)",
				"transparent": "p(warmNeutral400)"
			},
			"theme.dataVisualization.marketUp": {
				"light": "p(green600)",
				"dark": "p(green400)",
				"ultraDark": "p(green400)",
				"transparent": "p(green400)"
			},
			"theme.dataVisualization.marketUpWash": {
				"light": "p(green100)",
				"dark": "p(green800)",
				"ultraDark": "p(green900)",
				"transparent": "p(green800)"
			},
			"theme.dataVisualization.marketDown": {
				"light": "p(red600)",
				"dark": "p(red400)",
				"ultraDark": "p(red400)",
				"transparent": "p(red400)"
			},
			"theme.dataVisualization.marketDownWash": {
				"light": "p(red100)",
				"dark": "p(red800)",
				"ultraDark": "p(red900)",
				"transparent": "p(red800)"
			},
			"theme.dataVisualization.marketFlat": {
				"light": "p(warmNeutral450)",
				"dark": "p(warmNeutral400)",
				"ultraDark": "p(warmNeutral500)",
				"transparent": "p(warmNeutral400)"
			}
		},
		"recipes": {
			"app-background": {
				"aliases": "app background／應用背景／頁面背景",
				"inherit": "—",
				"parameters": "background=s(theme.colors.app); foreground=s(theme.colors.text); padding=p(space0); border=none; radius=s(theme.shape.none); size=產品決定; shadow=none"
			},
			"workspace-layout": {
				"aliases": "工作區間距／workspace layout",
				"inherit": "—",
				"parameters": "background=繼承 app-background.background; frame-inset=s(theme.spacing.space2); frame-gap=s(theme.spacing.space2); size=產品決定; border=none"
			},
			"surface-base": {
				"aliases": "一般／輔助表面／surface base",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-inset": {
				"aliases": "內嵌表面／surface inset",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-muted": {
				"aliases": "弱化表面／surface muted",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceMuted); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-component": {
				"aliases": "控制表面／surface component",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-overlay": {
				"aliases": "浮層表面／surface overlay",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-raised": {
				"aliases": "較亮表面／surface raised",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceRaised); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-stage": {
				"aliases": "主內容表面／surface stage",
				"inherit": "—",
				"parameters": "background=s(theme.colors.stageSurface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-accent": {
				"aliases": "強調表面／surface accent",
				"inherit": "—",
				"parameters": "background=s(theme.colors.accent); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-accent-soft": {
				"aliases": "柔和強調表面／surface accent-soft",
				"inherit": "—",
				"parameters": "background=s(theme.colors.accentSoft); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-transparent": {
				"aliases": "透明表面／surface transparent",
				"inherit": "—",
				"parameters": "background=s(theme.colors.transparent); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=s(theme.components.cardRadius); size=產品決定; shadow=none; gradient=none"
			},
			"surface-frosted": {
				"aliases": "毛玻璃表面／frosted",
				"inherit": "surface-base",
				"parameters": "background=alpha(繼承.background,s(theme.surface.frostedOpacity)); blur-sigma=s(theme.surface.backdropBlurSigma); geometry=繼承"
			},
			"text-tone-primary": {
				"aliases": "主文字色／primary text／prominent",
				"inherit": "—",
				"parameters": "color=s(theme.colors.text); typography=繼承父層; padding/border=不適用; size=內容決定"
			},
			"text-tone-muted": {
				"aliases": "次要文字／說明文字／muted",
				"inherit": "text-tone-primary",
				"parameters": "color=s(theme.colors.textMuted)"
			},
			"text-tone-faint": {
				"aliases": "弱化文字／提示文字色／faint",
				"inherit": "text-tone-primary",
				"parameters": "color=s(theme.colors.textFaint)"
			},
			"text-display": {
				"aliases": "展示大字／text display",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.display); line-height=s(theme.typography.displayLeading); font-weight=s(theme.typography.bold); letter-spacing=s(theme.typography.displayTracking); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h1": {
				"aliases": "一級標題／text h1",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h1); line-height=s(theme.typography.h1Leading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h2": {
				"aliases": "二級標題／text h2",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h2); line-height=s(theme.typography.h2Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h3": {
				"aliases": "三級標題／text h3",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h3); line-height=s(theme.typography.h3Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-h4": {
				"aliases": "四級標題／text h4",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.h4); line-height=s(theme.typography.h4Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-lead": {
				"aliases": "導言／text lead",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.lead); line-height=s(theme.typography.leadLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-body": {
				"aliases": "正文／內文／text body",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-sub": {
				"aliases": "副正文／text sub",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.subLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-caption": {
				"aliases": "註解小字／text caption",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-caption-strong": {
				"aliases": "強調小字／text captionStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-mono-caption-strong": {
				"aliases": "等寬強調小字／text monoCaptionStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.caption); line-height=s(theme.typography.captionLeading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-micro": {
				"aliases": "極小字／text micro",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.micro); line-height=s(theme.typography.microLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-title": {
				"aliases": "頁面標題／text title",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.title); line-height=s(theme.typography.h1Leading); font-weight=s(theme.typography.bold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-section": {
				"aliases": "區段標題／text section",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.section); line-height=s(theme.typography.h3Leading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-editor": {
				"aliases": "編輯文字／text editor",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=p(space0); font-family=s(theme.typography.bodyFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-terminal": {
				"aliases": "終端文字／text terminal",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-body-strong": {
				"aliases": "強調正文／text bodyStrong",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); optical-y=s(theme.geometry.optical.uiBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-app-title": {
				"aliases": "應用名稱／text appTitle",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.labelLeading); font-weight=p(weight500); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-header": {
				"aliases": "Header文字／text header",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.body); line-height=s(theme.typography.bodyLeading); font-weight=s(theme.typography.semiBold); letter-spacing=p(space0); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-status": {
				"aliases": "狀態列文字／text status",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.codeLeading); font-weight=p(weight500); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-label": {
				"aliases": "控制標籤／text label",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.labelLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"text-code": {
				"aliases": "程式碼／路徑文字／text code",
				"inherit": "text-tone-primary",
				"parameters": "font-size=s(theme.typography.sub); line-height=s(theme.typography.codeLeading); font-weight=s(theme.typography.regular); letter-spacing=s(theme.typography.labelTracking); font-family=s(theme.typography.monoFamily); fallback=s(theme.typography.monoFallback); optical-y=s(theme.geometry.optical.monoBaselineOffsetY); color=s(theme.colors.text)"
			},
			"button-base": {
				"aliases": "按鈕共用幾何",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); padding-x=s(theme.components.buttonPaddingX); padding-y=p(space0); height=s(theme.components.buttonHeight); width=內容決定; radius=s(theme.components.buttonRadius); border-width=s(theme.components.buttonBorderWidth); border-color=s(theme.colors.border); border-style=solid（width=0 時none）; gap=s(theme.spacing.controlContentGap); typography=s(text-body); shadow=none; transition=s(theme.motion.stateTransition); curve=s(theme.motion.standard)"
			},
			"button-primary": {
				"aliases": "主要按鈕／主操作／button primary",
				"inherit": "button-base",
				"parameters": "background=opaque(s(theme.colors.brand)); foreground=primaryForeground(background); typography=s(text-body-strong)"
			},
			"button-secondary": {
				"aliases": "次要按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); typography=s(text-body)"
			},
			"button-ghost": {
				"aliases": "透明按鈕／幽靈按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.text); typography=s(text-body)"
			},
			"button-danger": {
				"aliases": "危險按鈕／刪除按鈕",
				"inherit": "button-base",
				"parameters": "background=alpha(s(theme.colors.danger),s(theme.surface.statusFillOpacity)); foreground=s(theme.colors.danger); typography=s(text-body)"
			},
			"button-dashed": {
				"aliases": "裝飾虛線按鈕",
				"inherit": "button-base",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.text); typography=s(text-body); decoration=dashed; dash-color=s(theme.colors.guide); dash-width=s(theme.shape.hairline); dash-length=s(theme.shape.dashedLength); dash-gap=s(theme.shape.dashedGap); dash-opacity=s(theme.shape.dashedOpacity)"
			},
			"button-size-xs": {
				"aliases": "按鈕 xs",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightXSmall); padding-x=s(theme.spacing.controlInset); padding-y=p(space0); typography=s(text-caption); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-sm": {
				"aliases": "按鈕 sm",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightSmall); padding-x=s(theme.spacing.controlPaddingXSmall); padding-y=p(space0); typography=s(text-caption); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-md": {
				"aliases": "按鈕 md",
				"inherit": "button-base",
				"parameters": "height=s(theme.components.buttonHeight); padding-x=s(theme.components.buttonPaddingX); padding-y=p(space0); typography=s(text-body); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-lg": {
				"aliases": "按鈕 lg",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightLarge); padding-x=s(theme.spacing.controlPaddingXLarge); padding-y=p(space0); typography=s(text-lead); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-size-xl": {
				"aliases": "按鈕 xl",
				"inherit": "button-base",
				"parameters": "height=s(theme.geometry.control.buttonHeightXLarge); padding-x=s(theme.spacing.controlPaddingXXLarge); padding-y=p(space0); typography=s(text-lead); primary-label=xs/sm用text-caption-strong，md用text-body-strong，lg/xl用text-lead"
			},
			"button-hover": {
				"aliases": "按鈕 hover／focus",
				"inherit": "繼承目前 button-*",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),繼承.background); primary特例=以primaryForeground(繼承.background)取代疊色text; foreground=primary時依新背景重新算，其他繼承; geometry=繼承"
			},
			"button-selected": {
				"aliases": "按鈕 selected",
				"inherit": "繼承目前 button-*",
				"parameters": "background=over(alpha(s(theme.colors.interaction),s(theme.surface.focusWashOpacity)),繼承.background); primary特例=以primaryForeground(繼承.background)取代疊色interaction; foreground=primary時依新背景重新算，其他繼承; geometry=繼承"
			},
			"button-disabled": {
				"aliases": "停用按鈕",
				"inherit": "繼承目前 button-*",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=s(theme.colors.textFaint); hover/selected=不套用; geometry=繼承"
			},
			"icon-button": {
				"aliases": "獨立圖示按鈕／icon button",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); width=s(theme.spacing.iconButton); height=s(theme.spacing.iconButton); radius=s(theme.shape.control); padding=無額外padding，圖示置中; icon-size=s(theme.spacing.iconBase); border=none; shadow=none"
			},
			"icon-button-inline": {
				"aliases": "行內圖示按鈕",
				"inherit": "icon-button",
				"parameters": "background=s(theme.colors.transparent)"
			},
			"icon-button-window": {
				"aliases": "視窗控制圖示按鈕",
				"inherit": "icon-button",
				"parameters": "width=s(theme.geometry.layout.windowHeaderControlSize); height=s(theme.geometry.layout.windowHeaderControlSize)"
			},
			"icon-button-hover": {
				"aliases": "圖示按鈕 hover／focus",
				"inherit": "繼承目前 icon-button*",
				"parameters": "background=over(alpha(s(theme.colors.text),byBrightness(s(theme.surface.focusWashOpacity),s(theme.surface.selectionWashOpacity))),s(theme.colors.component)); geometry/foreground=繼承"
			},
			"icon-button-selected": {
				"aliases": "圖示按鈕 selected",
				"inherit": "繼承目前 icon-button*",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text); geometry=繼承"
			},
			"icon-button-disabled": {
				"aliases": "停用圖示按鈕",
				"inherit": "繼承目前 icon-button*",
				"parameters": "foreground=s(theme.colors.textFaint); background=selected時s(theme.colors.interactionSoft)，否則繼承rest; hover=不套用; geometry=繼承"
			},
			"field-base": {
				"aliases": "輸入框／文字輸入欄位／text field",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surfaceInset); foreground=s(theme.colors.text); placeholder=s(theme.colors.textFaint); icon-color=s(theme.colors.textMuted); cursor-color=s(theme.colors.interaction); height=s(theme.components.fieldHeight); width=產品決定; padding-x=s(theme.components.fieldPaddingX); padding-y=div(sub(height,mul(font-size,s(theme.geometry.control.textFieldLineHeightFactor))),p(ratio-2)); radius=s(theme.components.fieldRadius); border-width=s(theme.components.fieldBorderWidth); border-color=s(theme.colors.border); border-style=solid（width=0時none）; font-size=s(theme.typography.body); font-family=s(theme.typography.uiFamily); fallback=s(theme.typography.sansFallback); line-height=s(theme.typography.captionLeading); shadow=none"
			},
			"field-size-xs": {
				"aliases": "輸入框 xs",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightXSmall); font-size=s(theme.typography.caption); padding-x=s(theme.spacing.tight); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-sm": {
				"aliases": "輸入框 sm",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightSmall); font-size=s(theme.typography.sub); padding-x=s(theme.spacing.tight); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-md": {
				"aliases": "輸入框 md",
				"inherit": "field-base",
				"parameters": "height=s(theme.components.fieldHeight); font-size=s(theme.typography.body); padding-x=s(theme.components.fieldPaddingX); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-lg": {
				"aliases": "輸入框 lg",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightLarge); font-size=s(theme.typography.lead); padding-x=s(theme.spacing.base); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-size-xl": {
				"aliases": "輸入框 xl",
				"inherit": "field-base",
				"parameters": "height=s(theme.spacing.controlHeightXLarge); font-size=s(theme.typography.lead); padding-x=s(theme.spacing.comfortable); padding-y=繼承field-base公式，以此尺寸代入"
			},
			"field-hover": {
				"aliases": "懸停輸入框",
				"inherit": "field-base",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),s(theme.colors.surfaceInset));  geometry=繼承"
			},
			"field-focused": {
				"aliases": "聚焦／選取輸入框",
				"inherit": "field-base",
				"parameters": "background=over(alpha(s(theme.colors.interaction),s(theme.surface.focusWashOpacity)),s(theme.colors.surfaceInset));  focus-indicator=inset(s(theme.shape.stroke),s(theme.colors.interaction)); outer-outline=none; geometry=繼承（含焦點提示不增加外徑）"
			},
			"field-error": {
				"aliases": "錯誤輸入框",
				"inherit": "field-base",
				"parameters": "background=alpha(s(theme.colors.danger),s(theme.surface.invalidFillOpacity));  geometry=繼承"
			},
			"field-disabled": {
				"aliases": "停用輸入框",
				"inherit": "field-base",
				"parameters": "background=s(theme.colors.surfaceMuted); foreground=s(theme.colors.textFaint); icon-color=s(theme.colors.textFaint); geometry=繼承"
			},
			"field-outlined": {
				"aliases": "有邊框輸入框",
				"inherit": "field-base",
				"parameters": "border-width=max(繼承.border-width,s(theme.shape.stroke)); border-color=focused時s(theme.colors.interaction)，否則s(theme.colors.border); geometry=繼承"
			},
			"field-multiline": {
				"aliases": "多行輸入框／textarea",
				"inherit": "field-base",
				"parameters": "height=內容決定; padding-y=s(theme.spacing.controlPaddingY); min-lines=s(theme.geometry.control.textFieldMinLines); max-lines=s(theme.geometry.control.textFieldMaxLines); alignment=top-left"
			},
			"card": {
				"aliases": "卡片／內容卡片",
				"inherit": "—",
				"parameters": "background=s(theme.colors.component); foreground=繼承文字角色; radius=s(theme.components.cardRadius); header-padding=s(theme.components.cardPadding); content-padding=s(theme.components.cardPadding); footer-padding=s(theme.spacing.contentInset); title=s(text-body-strong); label=s(text-label); gap=s(theme.spacing.contentInlineGap); border=none; shadow=none; size=產品決定"
			},
			"card-surface": {
				"aliases": "卡片 surface",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surface); shadow=none（raised只改底色）"
			},
			"card-muted": {
				"aliases": "卡片 muted",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surfaceMuted); shadow=none（raised只改底色）"
			},
			"card-raised": {
				"aliases": "卡片 raised",
				"inherit": "card",
				"parameters": "background=s(theme.colors.surfaceRaised); shadow=none（raised只改底色）"
			},
			"card-selected": {
				"aliases": "選取卡片",
				"inherit": "繼承目前 card*",
				"parameters": "background=over(alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)),繼承.background); geometry=繼承"
			},
			"badge-base": {
				"aliases": "狀態標記共用幾何／badge",
				"inherit": "—",
				"parameters": "padding-x=s(theme.components.badgePaddingX); padding-y=s(theme.spacing.space0_5); radius=s(theme.components.badgeRadius); typography=s(text-caption); size=內容決定; text-transform=uppercase; dot-size=s(theme.spacing.indicatorDot); dot-gap=s(theme.spacing.tight); shadow=none; tone-color=neutral時s(theme.colors.textMuted)，其他取status-*"
			},
			"badge-neutral": {
				"aliases": "中性標記／filled neutral",
				"inherit": "badge-base",
				"parameters": "background=s(theme.colors.component); foreground=s(theme.colors.text); border-width=p(space0); border-style=none"
			},
			"badge-status": {
				"aliases": "語意色標記／filled status",
				"inherit": "badge-base",
				"parameters": "background=over(alpha(tone-color,s(theme.surface.statusFillOpacity)),opaque(s(theme.colors.component))); foreground=s(theme.colors.text); border=none; shadow=s(effect-frame-relief)"
			},
			"badge-outline": {
				"aliases": "描邊標記",
				"inherit": "badge-base",
				"parameters": "background=none; foreground=tone-color; border-width=s(theme.shape.hairline); border-color=tone-color; border-style=solid"
			},
			"badge-solid": {
				"aliases": "實底標記",
				"inherit": "badge-base",
				"parameters": "background=s(theme.colors.text); foreground=s(theme.colors.stageSurface); border=none"
			},
			"status-success": {
				"aliases": "成功／完成",
				"inherit": "—",
				"parameters": "color=s(theme.colors.success); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-warning": {
				"aliases": "警告",
				"inherit": "—",
				"parameters": "color=s(theme.colors.warning); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-danger": {
				"aliases": "危險／錯誤／破壞性操作",
				"inherit": "—",
				"parameters": "color=s(theme.colors.danger); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"status-info": {
				"aliases": "資訊",
				"inherit": "—",
				"parameters": "color=s(theme.colors.info); on-status=s(theme.colors.onStatus); fill-opacity=s(theme.surface.statusFillOpacity); padding/border/size=繼承使用它的元件"
			},
			"frame": {
				"aliases": "內容Frame／app frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); padding=p(space0); radius=s(theme.shape.panel); border=none; shadow=none; size=父布局分配; outer-gap=繼承workspace-layout.frame-gap"
			},
			"frame-sidebar": {
				"aliases": "側欄Frame",
				"inherit": "frame",
				"parameters": "background=s(theme.colors.surfaceInset); width=s(theme.geometry.layout.primaryPaneWidth)"
			},
			"frame-auxiliary": {
				"aliases": "輔助Frame",
				"inherit": "frame",
				"parameters": "background=s(theme.colors.surfaceInset)"
			},
			"frame-right-sidebar": {
				"aliases": "右側欄Frame",
				"inherit": "frame",
				"parameters": "background=繼承父層; radius=不適用; shadow=none; width=s(theme.geometry.layout.secondaryPaneWidth); decoration=none（bare）"
			},
			"frame-toolbar-controls": {
				"aliases": "工具控制區Frame",
				"inherit": "frame",
				"parameters": "background=繼承父層; radius=不適用; shadow=none; width=add(mul(s(theme.spacing.space8),p(ratio-3)),mul(s(theme.spacing.space1),p(ratio-6))); decoration=none（bare）"
			},
			"frame-raised": {
				"aliases": "微立體Frame",
				"inherit": "繼承目前 frame*",
				"parameters": "shadow=s(effect-frame-relief); bare角色=不套用; geometry=繼承"
			},
			"panel-frame": {
				"aliases": "面板框架／panel frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.surface); foreground=backgroundForeground(background); outer-margin=s(theme.spacing.dockMargin); padding=p(space0); radius=s(theme.shape.card); clip-radius=sub(s(theme.shape.card),s(theme.shape.stroke)); header-height=s(theme.spacing.chromeHeader); footer-height=s(theme.spacing.chromeStatusBar); border=none; shadow=none; size=父布局分配"
			},
			"panel-frame-stage": {
				"aliases": "主內容面板框架",
				"inherit": "panel-frame",
				"parameters": "background=s(theme.colors.stageSurface)"
			},
			"panel-frame-dock": {
				"aliases": "Dock面板標題尺度",
				"inherit": "panel-frame",
				"parameters": "header-height=s(theme.spacing.chromeTab)"
			},
			"panel-frame-raised": {
				"aliases": "微立體面板",
				"inherit": "繼承目前 panel-frame*",
				"parameters": "shadow=s(effect-frame-relief)"
			},
			"stage-frame": {
				"aliases": "舞台容器／stage frame",
				"inherit": "—",
				"parameters": "background=s(theme.colors.stageSurface); foreground=backgroundForeground(background); padding=p(space0); border=none; radius=不適用; shadow=none; header-min-height=s(theme.spacing.chromeHeader); status-height=s(theme.spacing.chromeStatusBar); size=父布局分配"
			},
			"explorer-row": {
				"aliases": "Explorer資料列／檔案列",
				"inherit": "—",
				"parameters": "background=繼承父層; foreground=s(theme.colors.text); height=add(s(theme.spacing.controlHeightXSmall),s(theme.geometry.control.fileExplorerRowHeightAdjustment)); row-padding-end=s(theme.spacing.tight); icon-size=s(theme.spacing.iconSmall); icon-color=s(theme.colors.textMuted); icon-gap=s(theme.spacing.contentInlineGap); typography=s(text-code); leading-width=add(s(theme.spacing.iconSmall),s(theme.geometry.layout.treeLeadingGap)); indent=mul(level,s(theme.spacing.tight)); outer-padding-x=s(theme.spacing.navigationItemInset); outer-padding-y=s(theme.spacing.hairline); border=none; shadow=none; width=父布局分配"
			},
			"explorer-folder-row": {
				"aliases": "Explorer資料夾列",
				"inherit": "explorer-row",
				"parameters": "height=s(theme.spacing.controlHeightXSmall); disclosure=產品選用圖示"
			},
			"explorer-row-hover": {
				"aliases": "Explorer懸停資料列",
				"inherit": "explorer-row",
				"parameters": "overlay=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity)); overlay-radius=s(theme.shape.control); geometry=繼承"
			},
			"explorer-row-selected": {
				"aliases": "Explorer選取資料列",
				"inherit": "explorer-row-hover",
				"parameters": "icon-color=s(theme.colors.text); overlay=繼承（hover／selected同色）；不新增虛線框"
			},
			"explorer-spacing-relaxed": {
				"aliases": "較寬樹狀節奏",
				"inherit": "explorer-row",
				"parameters": "indent=mul(level,s(theme.spacing.base))"
			},
			"explorer-spacing-flush": {
				"aliases": "貼齊Explorer／flush",
				"inherit": "explorer-row",
				"parameters": "outer-padding-x=p(space0); outer-padding-y=p(space0); section-margin-x=s(theme.spacing.hairline)"
			},
			"action-region": {
				"aliases": "可操作資料區域",
				"inherit": "—",
				"parameters": "background=s(theme.colors.transparent); foreground=s(theme.colors.textMuted); radius=s(theme.shape.card); padding/size=繼承所屬元件; border=none; shadow=none"
			},
			"action-region-hover": {
				"aliases": "可操作資料區域hover／focus",
				"inherit": "action-region",
				"parameters": "background=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity))"
			},
			"action-region-selected": {
				"aliases": "可操作資料區域selected",
				"inherit": "action-region",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text)"
			},
			"action-region-destructive": {
				"aliases": "破壞性可操作區域",
				"inherit": "action-region",
				"parameters": "foreground=s(theme.colors.danger); active-background=s(theme.colors.danger); active-foreground=s(theme.colors.onStatus)"
			},
			"menu": {
				"aliases": "彈出選單／menu panel",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=backgroundForeground(background); padding=s(theme.spacing.tight); radius=s(theme.components.menuRadius); width-base=s(theme.geometry.layout.menuWidth); width=依項目量測／scrollable選項，基準width-base; border-width=s(theme.shape.hairline); border-style=dashed; border-color=s(theme.colors.divider); shadow=s(effect-menu-shadow)"
			},
			"menu-item": {
				"aliases": "選單項目",
				"inherit": "action-region",
				"parameters": "radius=s(theme.shape.control); height=s(theme.components.menuItemHeight); padding-x=s(theme.components.menuPadding); padding-y=p(space0); typography=s(text-label); icon-size=s(theme.spacing.iconSmall); gap=s(theme.spacing.overlayItemGap); icon-optical-y=s(theme.geometry.optical.menuIconOffsetY)"
			},
			"menu-item-description": {
				"aliases": "附說明選單項目",
				"inherit": "menu-item",
				"parameters": "height=mul(s(theme.components.menuItemHeight),p(ratio-2)); description=s(text-caption); description-color=s(theme.colors.textMuted)"
			},
			"menu-item-selected": {
				"aliases": "選取選單項目",
				"inherit": "menu-item",
				"parameters": "background=s(theme.colors.interactionSoft); foreground=s(theme.colors.text)"
			},
			"menu-item-hover": {
				"aliases": "選單hover／keyboard focus",
				"inherit": "menu-item",
				"parameters": "background=alpha(s(theme.colors.text),s(theme.surface.selectionWashOpacity))"
			},
			"menu-item-danger": {
				"aliases": "危險選單項目",
				"inherit": "menu-item",
				"parameters": "foreground=s(theme.colors.danger); active-background=s(theme.colors.danger); active-foreground=s(theme.colors.onStatus)"
			},
			"dialog": {
				"aliases": "對話框",
				"inherit": "surface-base",
				"parameters": "radius=s(theme.shape.panel); max-width=s(theme.geometry.layout.dialogMaximumWidth); heading-padding=s(theme.spacing.loose); content-padding=s(theme.spacing.loose); actions-padding=s(theme.spacing.base); heading-gap=s(theme.spacing.overlayHeadingGap); action-gap=s(theme.spacing.actionGap); title=s(text-title); label=s(text-label); primary-action=s(button-primary); secondary-action=s(button-ghost); border-width=s(theme.shape.hairline); border-style=dashed; border-color=s(theme.colors.divider); shadow=微立體; positioning/scrim=產品彈出宿主決定"
			},
			"scrollbar": {
				"aliases": "捲軸",
				"inherit": "—",
				"parameters": "thumb-color=s(theme.colors.textFaint); track-color=s(theme.colors.transparent); track-border-color=s(theme.colors.transparent); thickness=s(theme.geometry.control.scrollbarThickness); radius=s(theme.shape.pill); track-visible=false; length/padding=宿主決定"
			},
			"tooltip": {
				"aliases": "工具提示",
				"inherit": "—",
				"parameters": "background=s(theme.colors.overlay); foreground=s(theme.colors.textMuted); radius=s(theme.shape.control); padding-x=s(theme.spacing.overlayContentInset); padding-y=s(theme.spacing.tight); font-family=s(theme.typography.uiFamily); font-size=s(theme.typography.caption); border=none; delay=s(theme.motion.tooltipDelay); dwell=s(theme.motion.tooltipDwell); prefer-below=false; size=內容決定"
			},
			"effect-paper-shadow": {
				"aliases": "紙片雙層陰影／overlayShadow",
				"inherit": "—",
				"parameters": "contact=color alpha(s(theme.surface.overlayShadowColor),s(theme.surface.contactShadowOpacity)), offset(p(space0),s(theme.surface.contactOffsetY)), blur=s(theme.surface.contactBlur), spread=p(space0); ambient=color alpha(s(theme.surface.overlayShadowColor),s(theme.surface.overlayShadowOpacity)), offset(p(space0),s(theme.surface.overlayOffsetY)), blur=s(theme.surface.overlayBlur), spread=s(theme.surface.overlaySpread); enabled=theme.surface.separation=shadow，其餘none"
			},
			"effect-menu-shadow": {
				"aliases": "選單專用單層陰影",
				"inherit": "—",
				"parameters": "color=alpha(s(theme.colors.modalScrim),s(theme.surface.overlayShadowOpacity)); offset=(p(space0),s(theme.surface.overlayOffsetY)); blur=s(theme.surface.overlayBlur); spread=s(theme.surface.overlaySpread); 不增加接觸層"
			},
			"effect-frame-relief": {
				"aliases": "Frame微立體陰影與亮邊",
				"inherit": "—",
				"parameters": "scale=div(s(theme.spacing.space1),p(space100)); dark=surface.R/G/B全部小於100; shadow-rgb=s(theme.surface.overlayShadowColor); shadow-alpha=dark?p(opacity-0_47843137254901963):p(opacity-0_1803921568627451); shadow-offset=(mul(p(space50),scale),mul(p(length-3),scale)); blur=mul(p(length-5),scale); spread=mul(p(length-minus-1),scale); highlight-rgb=p(ink50); highlight-alpha=dark?p(opacity-0_07058823529411765):p(opacity-0_8509803921568627); highlight-offset=(mul(p(length-minus-1),scale),mul(p(length-minus-1),scale)); highlight-blur=p(space0); 陰影在裁切之外"
			},
			"motion-reduced": {
				"aliases": "減少動態效果",
				"inherit": "—",
				"parameters": "state-transition=p(duration0); overlay-enter=p(duration0); overlay-exit=p(duration0); 其他=繼承theme.motion"
			}
		},
		"primitiveDescriptions": {
			"parchment50": "現有公開primitive",
			"parchment75": "現有公開primitive",
			"parchment100": "現有公開primitive",
			"parchment150": "現有公開primitive",
			"parchment200": "現有公開primitive",
			"parchment250": "現有公開primitive",
			"parchment350": "現有公開primitive",
			"parchment550": "現有公開primitive",
			"parchment700": "現有公開primitive",
			"parchment750": "現有公開primitive",
			"parchment800": "現有公開primitive",
			"parchment825": "現有公開primitive",
			"parchment900": "現有公開primitive",
			"parchment925": "現有公開primitive",
			"parchment950": "現有公開primitive",
			"ink1000": "現有公開primitive",
			"transparent": "現有公開primitive",
			"ink50": "現有公開primitive",
			"ink100": "現有公開primitive",
			"ink150": "現有公開primitive",
			"ink200": "現有公開primitive",
			"ink250": "現有公開primitive",
			"ink300": "現有公開primitive",
			"ink350": "現有公開primitive",
			"ink400": "現有公開primitive",
			"ink450": "現有公開primitive",
			"ink500": "現有公開primitive",
			"ink550": "現有公開primitive",
			"ink600": "現有公開primitive",
			"ink650": "現有公開primitive",
			"ink700": "現有公開primitive",
			"ink750": "現有公開primitive",
			"ink800": "現有公開primitive",
			"ink850": "現有公開primitive",
			"ink900": "現有公開primitive",
			"ink950": "現有公開primitive",
			"warmNeutral25": "現有公開primitive",
			"warmNeutral50": "現有公開primitive",
			"warmNeutral100": "現有公開primitive",
			"warmNeutral200": "現有公開primitive",
			"warmNeutral300": "現有公開primitive",
			"warmNeutral400": "現有公開primitive",
			"warmNeutral450": "現有公開primitive",
			"warmNeutral500": "現有公開primitive",
			"warmNeutral600": "現有公開primitive",
			"warmNeutral700": "現有公開primitive",
			"warmNeutral750": "現有公開primitive",
			"warmNeutral800": "現有公開primitive",
			"warmNeutral900": "現有公開primitive",
			"sand50": "現有公開primitive",
			"sand300": "現有公開primitive",
			"sand500": "現有公開primitive",
			"sand800": "現有公開primitive",
			"sand900": "現有公開primitive",
			"gold50": "現有公開primitive",
			"gold300": "現有公開primitive",
			"gold500": "現有公開primitive",
			"gold800": "現有公開primitive",
			"gold900": "現有公開primitive",
			"ochre50": "現有公開primitive",
			"ochre300": "現有公開primitive",
			"ochre500": "現有公開primitive",
			"ochre800": "現有公開primitive",
			"ochre900": "現有公開primitive",
			"terracotta50": "現有公開primitive",
			"terracotta300": "現有公開primitive",
			"terracotta500": "現有公開primitive",
			"terracotta800": "現有公開primitive",
			"terracotta900": "現有公開primitive",
			"clay50": "現有公開primitive",
			"clay300": "現有公開primitive",
			"clay500": "現有公開primitive",
			"clay800": "現有公開primitive",
			"clay900": "現有公開primitive",
			"umber50": "現有公開primitive",
			"umber300": "現有公開primitive",
			"umber500": "現有公開primitive",
			"umber800": "現有公開primitive",
			"umber900": "現有公開primitive",
			"green100": "現有公開primitive",
			"green400": "現有公開primitive",
			"green500": "現有公開primitive",
			"green600": "現有公開primitive",
			"green800": "現有公開primitive",
			"green900": "現有公開primitive",
			"red100": "現有公開primitive",
			"red300": "現有公開primitive",
			"red400": "現有公開primitive",
			"red600": "現有公開primitive",
			"red800": "現有公開primitive",
			"red900": "現有公開primitive",
			"amber500": "現有公開primitive",
			"blue500": "現有公開primitive",
			"scrim": "現有公開primitive",
			"line": "現有公開primitive",
			"transparentSurface": "現有公開primitive",
			"transparentSurfaceInset": "現有公開primitive",
			"pureWhite": "現有公開primitive",
			"pureBlack": "現有公開primitive",
			"accent-ink-light": "現有accent配對原料",
			"accent-ink-dark": "現有accent配對原料",
			"accent-terracotta-light": "現有accent配對原料",
			"accent-terracotta-dark": "現有accent配對原料",
			"accent-ochre-light": "現有accent配對原料",
			"accent-ochre-dark": "現有accent配對原料",
			"accent-olive-light": "現有accent配對原料",
			"accent-olive-dark": "現有accent配對原料",
			"accent-slate-light": "現有accent配對原料",
			"accent-slate-dark": "現有accent配對原料",
			"accent-crimson-light": "現有accent配對原料",
			"accent-crimson-dark": "現有accent配對原料",
			"color-b8292724": "原實作值的文件名稱；未新增設計",
			"color-b835322d": "原實作值的文件名稱；未新增設計",
			"space0": "現有公開primitive",
			"space50": "現有公開primitive",
			"space100": "現有公開primitive",
			"space200": "現有公開primitive",
			"space250": "現有公開primitive",
			"space300": "現有公開primitive",
			"space400": "現有公開primitive",
			"space600": "現有公開primitive",
			"space800": "現有公開primitive",
			"space1000": "現有公開primitive",
			"space1200": "現有公開primitive",
			"space1600": "現有公開primitive",
			"space2400": "現有公開primitive",
			"radius0": "現有公開primitive",
			"radius50": "現有公開primitive",
			"radius100": "現有公開primitive",
			"radius150": "現有公開primitive",
			"radius200": "現有公開primitive",
			"radius250": "現有公開primitive",
			"radius300": "現有公開primitive",
			"radius400": "現有公開primitive",
			"radiusFull": "現有公開primitive",
			"stroke0": "現有公開primitive",
			"stroke100": "現有公開primitive",
			"stroke200": "現有公開primitive",
			"font100": "現有公開primitive",
			"font200": "現有公開primitive",
			"font300": "現有公開primitive",
			"font400": "現有公開primitive",
			"font500": "現有公開primitive",
			"font600": "現有公開primitive",
			"font700": "現有公開primitive",
			"font800": "現有公開primitive",
			"font900": "現有公開primitive",
			"font1000": "現有公開primitive",
			"tracking0": "現有公開primitive",
			"trackingTight": "現有公開primitive",
			"trackingWide": "現有公開primitive",
			"trackingWider": "現有公開primitive",
			"length-30": "原實作值的文件名稱；未新增設計",
			"length-56": "原實作值的文件名稱；未新增設計",
			"length-20": "原實作值的文件名稱；未新增設計",
			"length-60": "原實作值的文件名稱；未新增設計",
			"length-74": "原實作值的文件名稱；未新增設計",
			"length-170": "原實作值的文件名稱；未新增設計",
			"length-11": "原實作值的文件名稱；未新增設計",
			"length-3": "原實作值的文件名稱；未新增設計",
			"length-5": "原實作值的文件名稱；未新增設計",
			"length-7": "原實作值的文件名稱；未新增設計",
			"length-3_5": "原實作值的文件名稱；未新增設計",
			"length-41_4": "原實作值的文件名稱；未新增設計",
			"length-168": "原實作值的文件名稱；未新增設計",
			"length-26": "原實作值的文件名稱；未新增設計",
			"length-520": "原實作值的文件名稱；未新增設計",
			"length-320": "原實作值的文件名稱；未新增設計",
			"length-120": "原實作值的文件名稱；未新增設計",
			"length-9": "原實作值的文件名稱；未新增設計",
			"length-220": "原實作值的文件名稱；未新增設計",
			"length-192": "原實作值的文件名稱；未新增設計",
			"length-128": "原實作值的文件名稱；未新增設計",
			"length-112": "原實作值的文件名稱；未新增設計",
			"length-10_5": "原實作值的文件名稱；未新增設計",
			"length-336": "原實作值的文件名稱；未新增設計",
			"length-300": "原實作值的文件名稱；未新增設計",
			"length-350": "原實作值的文件名稱；未新增設計",
			"length-400": "原實作值的文件名稱；未新增設計",
			"length-800": "原實作值的文件名稱；未新增設計",
			"length-960": "原實作值的文件名稱；未新增設計",
			"length-1120": "原實作值的文件名稱；未新增設計",
			"length-200": "原實作值的文件名稱；未新增設計",
			"length-360": "原實作值的文件名稱；未新增設計",
			"length-480": "原實作值的文件名稱；未新增設計",
			"length-1380": "原實作值的文件名稱；未新增設計",
			"length-880": "原實作值的文件名稱；未新增設計",
			"length-260": "原實作值的文件名稱；未新增設計",
			"length-820": "原實作值的文件名稱；未新增設計",
			"length-minus-1": "原實作值的文件名稱；未新增設計",
			"leading100": "現有公開primitive",
			"leading116": "現有公開primitive",
			"leading120": "現有公開primitive",
			"leading122": "現有公開primitive",
			"leading127": "現有公開primitive",
			"leading128": "現有公開primitive",
			"leading133": "現有公開primitive",
			"leading142": "現有公開primitive",
			"leading150": "現有公開primitive",
			"leading155": "現有公開primitive",
			"leading150Legacy": "現有公開primitive",
			"leading200": "現有公開primitive",
			"leading300": "現有公開primitive",
			"leading350": "現有公開primitive",
			"leading400": "現有公開primitive",
			"leading450": "現有公開primitive",
			"leading500": "現有公開primitive",
			"leading550": "現有公開primitive",
			"leading650": "現有公開primitive",
			"ratio-0_4": "原實作值的文件名稱；未新增設計",
			"ratio-0_35": "原實作值的文件名稱；未新增設計",
			"ratio-0_32": "原實作值的文件名稱；未新增設計",
			"ratio-0_22": "原實作值的文件名稱；未新增設計",
			"ratio-0_06": "原實作值的文件名稱；未新增設計",
			"ratio-8": "原實作值的文件名稱；未新增設計",
			"ratio-2": "原實作值的文件名稱；未新增設計",
			"ratio-3": "原實作值的文件名稱；未新增設計",
			"ratio-6": "原實作值的文件名稱；未新增設計",
			"weight400": "現有公開primitive",
			"weight500": "現有公開primitive",
			"weight600": "現有公開primitive",
			"weight700": "現有公開primitive",
			"weight800": "現有公開primitive",
			"duration0": "現有公開primitive",
			"duration100": "現有公開primitive",
			"duration150": "現有公開primitive",
			"duration400": "現有公開primitive",
			"duration500": "現有公開primitive",
			"duration-4000": "原實作值的文件名稱；未新增設計",
			"duration-1000": "原實作值的文件名稱；未新增設計",
			"easeStandard": "現有公開primitive",
			"easeEmphasized": "現有公開primitive",
			"opacity100": "現有公開primitive",
			"opacity120": "現有公開primitive",
			"opacity140": "現有公開primitive",
			"opacity160": "現有公開primitive",
			"opacity180": "現有公開primitive",
			"opacity220": "現有公開primitive",
			"opacity280": "現有公開primitive",
			"opacity320": "現有公開primitive",
			"opacity350": "現有公開primitive",
			"opacity440": "現有公開primitive",
			"opacity480": "現有公開primitive",
			"opacity550": "現有公開primitive",
			"opacity620": "現有公開primitive",
			"opacity720": "現有公開primitive",
			"opacity780": "現有公開primitive",
			"opacity820": "現有公開primitive",
			"opacity-0_13333333333333333": "原實作值的文件名稱；未新增設計",
			"opacity-0_6": "原實作值的文件名稱；未新增設計",
			"opacity-0_88": "原實作值的文件名稱；未新增設計",
			"opacity-0_47843137254901963": "原實作值的文件名稱；未新增設計",
			"opacity-0_1803921568627451": "原實作值的文件名稱；未新增設計",
			"opacity-0_07058823529411765": "原實作值的文件名稱；未新增設計",
			"opacity-0_8509803921568627": "原實作值的文件名稱；未新增設計",
			"family-packages-kallopis-noto-sans-tc": "原實作值的文件名稱；未新增設計",
			"family-noto-sans-tc": "原實作值的文件名稱；未新增設計",
			"family-microsoft-jhenghei-ui": "原實作值的文件名稱；未新增設計",
			"family-microsoft-jhenghei": "原實作值的文件名稱；未新增設計",
			"family-pingfang-tc": "原實作值的文件名稱；未新增設計",
			"family-sans-serif": "原實作值的文件名稱；未新增設計",
			"family-packages-kallopis-ibm-plex-mono": "原實作值的文件名稱；未新增設計",
			"family-ibm-plex-mono": "原實作值的文件名稱；未新增設計",
			"family-consolas": "原實作值的文件名稱；未新增設計",
			"family-courier-new": "原實作值的文件名稱；未新增設計",
			"family-monospace": "原實作值的文件名稱；未新增設計",
			"string-shadow": "原實作值的文件名稱；未新增設計",
			"count-4": "原實作值的文件名稱；未新增設計",
			"count-8": "原實作值的文件名稱；未新增設計",
			"length-15": "checkbox 13px 增加 2px 的明確尺寸"
		},
		"semanticDescriptions": {
			"theme.colors.app": "<br>app background／應用背景色",
			"theme.colors.surface": "<br>base surface／輔助表面色",
			"theme.colors.surfaceInset": "<br>inset surface／內嵌表面色",
			"theme.colors.surfaceMuted": "<br>muted surface／弱化表面色",
			"theme.colors.component": "<br>control surface／控制表面色",
			"theme.colors.stageSurface": "<br>stage background／主內容表面色",
			"theme.colors.overlay": "<br>overlay background／浮層色",
			"theme.colors.surfaceRaised": "<br>raised surface／較亮表面",
			"theme.colors.modalScrim": "<br>遮罩色",
			"theme.colors.guide": "<br>colors / guide",
			"theme.colors.divider": "<br>分隔線色",
			"theme.colors.pagePattern": "<br>colors / page Pattern",
			"theme.colors.text": "<br>primary text／主文字",
			"theme.colors.textMuted": "<br>muted text／次要文字",
			"theme.colors.textFaint": "<br>faint text／弱化文字",
			"theme.colors.border": "<br>邊框色",
			"theme.colors.borderStrong": "<br>colors / border Strong",
			"theme.colors.brand": "<br>brand／品牌色／主動作底色",
			"theme.colors.accent": "<br>colors / accent",
			"theme.colors.accentSoft": "<br>colors / accent Soft",
			"theme.colors.interaction": "<br>interaction／操作色",
			"theme.colors.interactionSoft": "<br>selection background／柔和操作色",
			"theme.colors.success": "<br>colors / success",
			"theme.colors.warning": "<br>colors / warning",
			"theme.colors.danger": "<br>colors / danger",
			"theme.colors.info": "<br>colors / info",
			"theme.colors.onStatus": "<br>colors / on Status",
			"theme.colors.onLightBackground": "<br>colors / on Light Background",
			"theme.colors.onDarkBackground": "<br>colors / on Dark Background",
			"theme.colors.mutedOnLightBackground": "<br>colors / muted On Light Background",
			"theme.colors.mutedOnDarkBackground": "<br>colors / muted On Dark Background",
			"theme.colors.faintOnBackground": "<br>colors / faint On Background",
			"theme.colors.transparent": "<br>透明",
			"theme.typography.sansFamily": "<br>typography / sans Family",
			"theme.typography.sansFallback": "<br>typography / sans Fallback",
			"theme.typography.monoFamily": "<br>typography / mono Family",
			"theme.typography.monoFallback": "<br>typography / mono Fallback",
			"theme.typography.uiFamily": "<br>typography / ui Family",
			"theme.typography.bodyFamily": "<br>typography / body Family",
			"theme.typography.codeFamily": "<br>typography / code Family",
			"theme.typography.micro": "<br>typography / micro",
			"theme.typography.caption": "<br>typography / caption",
			"theme.typography.sub": "<br>typography / sub",
			"theme.typography.body": "<br>typography / body",
			"theme.typography.lead": "<br>typography / lead",
			"theme.typography.h4": "<br>typography / h4",
			"theme.typography.h3": "<br>typography / h3",
			"theme.typography.h2": "<br>typography / h2",
			"theme.typography.h1": "<br>typography / h1",
			"theme.typography.display": "<br>typography / display",
			"theme.typography.label": "<br>typography / label",
			"theme.typography.section": "<br>typography / section",
			"theme.typography.headingSmall": "<br>typography / heading Small",
			"theme.typography.heading": "<br>typography / heading",
			"theme.typography.title": "<br>typography / title",
			"theme.typography.microLeading": "<br>typography / micro Leading",
			"theme.typography.captionLeading": "<br>typography / caption Leading",
			"theme.typography.subLeading": "<br>typography / sub Leading",
			"theme.typography.bodyLeading": "<br>typography / body Leading",
			"theme.typography.leadLeading": "<br>typography / lead Leading",
			"theme.typography.h4Leading": "<br>typography / h4Leading",
			"theme.typography.h3Leading": "<br>typography / h3Leading",
			"theme.typography.h2Leading": "<br>typography / h2Leading",
			"theme.typography.h1Leading": "<br>typography / h1Leading",
			"theme.typography.displayLeading": "<br>typography / display Leading",
			"theme.typography.headingLeading": "<br>typography / heading Leading",
			"theme.typography.codeLeading": "<br>typography / code Leading",
			"theme.typography.readingLeading": "<br>typography / reading Leading",
			"theme.typography.labelLeading": "<br>typography / label Leading",
			"theme.typography.labelTracking": "<br>typography / label Tracking",
			"theme.typography.displayTracking": "<br>typography / display Tracking",
			"theme.typography.regular": "<br>typography / regular",
			"theme.typography.medium": "<br>typography / medium",
			"theme.typography.semiBold": "<br>typography / semi Bold",
			"theme.typography.bold": "<br>typography / bold",
			"theme.typography.extraBold": "<br>typography / extra Bold",
			"theme.typography.strong": "<br>typography / strong",
			"theme.spacing.space0_5": "<br>spacing / space0_5",
			"theme.spacing.space1": "<br>spacing / space1",
			"theme.spacing.space2": "<br>spacing / space2",
			"theme.spacing.space3": "<br>spacing / space3",
			"theme.spacing.space4": "<br>spacing / space4",
			"theme.spacing.space6": "<br>spacing / space6",
			"theme.spacing.space8": "<br>spacing / space8",
			"theme.spacing.space12": "<br>spacing / space12",
			"theme.spacing.space16": "<br>spacing / space16",
			"theme.spacing.space24": "<br>spacing / space24",
			"theme.spacing.hairline": "<br>spacing / hairline",
			"theme.spacing.tight": "<br>spacing / tight",
			"theme.spacing.contentInlineGap": "<br>spacing / content Inline Gap",
			"theme.spacing.contentStackGap": "<br>spacing / content Stack Gap",
			"theme.spacing.contentInset": "<br>spacing / content Inset",
			"theme.spacing.controlContentGap": "<br>spacing / control Content Gap",
			"theme.spacing.controlInset": "<br>spacing / control Inset",
			"theme.spacing.actionGap": "<br>spacing / action Gap",
			"theme.spacing.chromeGap": "<br>spacing / chrome Gap",
			"theme.spacing.chromePanelInset": "<br>spacing / chrome Panel Inset",
			"theme.spacing.chromeToolbarGap": "<br>spacing / chrome Toolbar Gap",
			"theme.spacing.navigationItemInset": "<br>spacing / navigation Item Inset",
			"theme.spacing.navigationRailInset": "<br>spacing / navigation Rail Inset",
			"theme.spacing.navigationRailItemGap": "<br>spacing / navigation Rail Item Gap",
			"theme.spacing.overlayContentInset": "<br>spacing / overlay Content Inset",
			"theme.spacing.overlayHeadingGap": "<br>spacing / overlay Heading Gap",
			"theme.spacing.overlayItemGap": "<br>spacing / overlay Item Gap",
			"theme.spacing.navigationSectionGap": "<br>spacing / navigation Section Gap",
			"theme.spacing.appFrameInset": "<br>spacing / app Frame Inset",
			"theme.spacing.windowHeaderMargin": "<br>spacing / window Header Margin",
			"theme.spacing.dockMargin": "<br>spacing / dock Margin",
			"theme.spacing.base": "<br>spacing / base",
			"theme.spacing.comfortable": "<br>spacing / comfortable",
			"theme.spacing.loose": "<br>spacing / loose",
			"theme.spacing.section": "<br>spacing / section",
			"theme.spacing.sectionLarge": "<br>spacing / section Large",
			"theme.spacing.page": "<br>spacing / page",
			"theme.spacing.pageLarge": "<br>spacing / page Large",
			"theme.spacing.controlPaddingXSmall": "<br>spacing / control Padding XSmall",
			"theme.spacing.controlPaddingX": "<br>spacing / control Padding X",
			"theme.spacing.controlPaddingXLarge": "<br>spacing / control Padding XLarge",
			"theme.spacing.controlPaddingXXLarge": "<br>spacing / control Padding XXLarge",
			"theme.spacing.controlPaddingY": "<br>spacing / control Padding Y",
			"theme.spacing.containerPadding": "<br>spacing / container Padding",
			"theme.spacing.itemGap": "<br>spacing / item Gap",
			"theme.spacing.groupGap": "<br>spacing / group Gap",
			"theme.spacing.controlHeightXSmall": "<br>spacing / control Height XSmall",
			"theme.spacing.controlHeightSmall": "<br>spacing / control Height Small",
			"theme.spacing.controlHeight": "<br>spacing / control Height",
			"theme.spacing.controlHeightLarge": "<br>spacing / control Height Large",
			"theme.spacing.controlHeightXLarge": "<br>spacing / control Height XLarge",
			"theme.spacing.iconSmall": "<br>spacing / icon Small",
			"theme.spacing.iconBase": "<br>spacing / icon Base",
			"theme.spacing.iconGlyph": "<br>spacing / icon Glyph",
			"theme.spacing.icon": "<br>spacing / icon",
			"theme.spacing.iconMedium": "<br>spacing / icon Medium",
			"theme.spacing.iconLarge": "<br>spacing / icon Large",
			"theme.spacing.chromeHeader": "<br>spacing / chrome Header",
			"theme.spacing.chromeStatusBar": "<br>spacing / chrome Status Bar",
			"theme.spacing.chromeRail": "<br>spacing / chrome Rail",
			"theme.spacing.chromeTab": "<br>spacing / chrome Tab",
			"theme.spacing.iconButton": "<br>spacing / icon Button",
			"theme.spacing.iconTiny": "<br>spacing / icon Tiny",
			"theme.spacing.indicatorDot": "<br>spacing / indicator Dot",
			"theme.spacing.indicatorDotLarge": "<br>spacing / indicator Dot Large",
			"theme.spacing.noticeIconSlot": "<br>spacing / notice Icon Slot",
			"theme.spacing.toastIconSlot": "<br>spacing / toast Icon Slot",
			"theme.spacing.gutterNumber": "<br>spacing / gutter Number",
			"theme.spacing.gutterMarker": "<br>spacing / gutter Marker",
			"theme.spacing.micro": "<br>spacing / micro",
			"theme.spacing.calendarContentCell": "<br>spacing / calendar Content Cell",
			"theme.spacing.gridTileWidth": "<br>spacing / grid Tile Width",
			"theme.spacing.iconMicro": "<br>spacing / icon Micro",
			"theme.spacing.avatarSmall": "<br>spacing / avatar Small",
			"theme.spacing.progressTrack": "<br>spacing / progress Track",
			"theme.spacing.skeletonLine": "<br>spacing / skeleton Line",
			"theme.spacing.railItem": "<br>spacing / rail Item",
			"theme.shape.none": "<br>shape / none",
			"theme.shape.sm": "<br>shape / sm",
			"theme.shape.control": "<br>shape / control",
			"theme.shape.controlInner": "<br>shape / control Inner",
			"theme.shape.toggleTrack": "<br>shape / toggle Track",
			"theme.shape.card": "<br>shape / card",
			"theme.shape.panel": "<br>shape / panel",
			"theme.shape.pill": "<br>shape / pill",
			"theme.shape.hairline": "<br>shape / hairline",
			"theme.shape.stroke": "<br>shape / stroke",
			"theme.shape.dashedLength": "<br>shape / dashed Length",
			"theme.shape.dashedGap": "<br>shape / dashed Gap",
			"theme.shape.dashedOpacity": "<br>shape / dashed Opacity",
			"theme.motion.themeTransition": "<br>motion / theme Transition",
			"theme.motion.styleTransition": "<br>motion / style Transition",
			"theme.motion.stateTransition": "<br>motion / state Transition",
			"theme.motion.overlayEnter": "<br>motion / overlay Enter",
			"theme.motion.overlayExit": "<br>motion / overlay Exit",
			"theme.motion.toastDwell": "<br>motion / toast Dwell",
			"theme.motion.tooltipDelay": "<br>motion / tooltip Delay",
			"theme.motion.tooltipDwell": "<br>motion / tooltip Dwell",
			"theme.motion.spinnerCycle": "<br>motion / spinner Cycle",
			"theme.motion.longPressThreshold": "<br>motion / long Press Threshold",
			"theme.motion.standard": "<br>motion / standard",
			"theme.motion.emphasized": "<br>motion / emphasized",
			"theme.surface.separation": "<br>surface / separation",
			"theme.surface.overlayBlur": "<br>surface / overlay Blur",
			"theme.surface.overlaySpread": "<br>surface / overlay Spread",
			"theme.surface.overlayOffsetY": "<br>surface / overlay Offset Y",
			"theme.surface.overlayShadowOpacity": "<br>surface / overlay Shadow Opacity",
			"theme.surface.scrimOpacity": "<br>surface / scrim Opacity",
			"theme.surface.selectionWashOpacity": "<br>surface / selection Wash Opacity",
			"theme.surface.focusWashOpacity": "<br>surface / focus Wash Opacity",
			"theme.surface.statusFillOpacity": "<br>surface / status Fill Opacity",
			"theme.surface.pressProgressOpacity": "<br>surface / press Progress Opacity",
			"theme.surface.diffFillOpacity": "<br>surface / diff Fill Opacity",
			"theme.surface.gridLineOpacity": "<br>surface / grid Line Opacity",
			"theme.surface.veilOpacity": "<br>surface / veil Opacity",
			"theme.surface.statusRowOpacity": "<br>surface / status Row Opacity",
			"theme.surface.statusRowSelectedOpacity": "<br>surface / status Row Selected Opacity",
			"theme.surface.statusRowOpacityDark": "<br>surface / status Row Opacity Dark",
			"theme.surface.statusRowSelectedOpacityDark": "<br>surface / status Row Selected Opacity Dark",
			"theme.surface.frostedOpacity": "<br>surface / frosted Opacity",
			"theme.surface.frostedVeilOpacity": "<br>surface / frosted Veil Opacity",
			"theme.surface.backdropBlurSigma": "<br>surface / backdrop Blur Sigma",
			"theme.surface.dragOpacity": "<br>surface / drag Opacity",
			"theme.surface.dragSourceOpacity": "<br>surface / drag Source Opacity",
			"theme.surface.themePreviewDisabledOpacity": "<br>surface / theme Preview Disabled Opacity",
			"theme.surface.listStatusOpacity": "<br>surface / list Status Opacity",
			"theme.surface.listStatusSelectedOpacity": "<br>surface / list Status Selected Opacity",
			"theme.surface.accentSoftOpacityLight": "<br>surface / accent Soft Opacity Light",
			"theme.surface.accentSoftOpacityDark": "<br>surface / accent Soft Opacity Dark",
			"theme.surface.windowPaneOpacityLight": "<br>surface / window Pane Opacity Light",
			"theme.surface.windowPaneOpacityDark": "<br>surface / window Pane Opacity Dark",
			"theme.surface.invalidFillOpacity": "<br>surface / invalid Fill Opacity",
			"theme.surface.contactBlur": "<br>surface / contact Blur",
			"theme.surface.contactOffsetY": "<br>surface / contact Offset Y",
			"theme.surface.contactShadowOpacity": "<br>surface / contact Shadow Opacity",
			"theme.surface.overlayShadowColor": "<br>surface / overlay Shadow Color",
			"theme.components.buttonRadius": "<br>components / button Radius",
			"theme.components.buttonPaddingX": "<br>components / button Padding X",
			"theme.components.buttonPaddingY": "<br>components / button Padding Y",
			"theme.components.buttonHeight": "<br>components / button Height",
			"theme.components.buttonBorderWidth": "<br>components / button Border Width",
			"theme.components.fieldRadius": "<br>components / field Radius",
			"theme.components.fieldPaddingX": "<br>components / field Padding X",
			"theme.components.fieldHeight": "<br>components / field Height",
			"theme.components.fieldBorderWidth": "<br>components / field Border Width",
			"theme.components.menuRadius": "<br>components / menu Radius",
			"theme.components.menuPadding": "<br>components / menu Padding",
			"theme.components.menuItemHeight": "<br>components / menu Item Height",
			"theme.components.cardRadius": "<br>components / card Radius",
			"theme.components.cardPadding": "<br>components / card Padding",
			"theme.components.badgeRadius": "<br>components / badge Radius",
			"theme.components.badgePaddingX": "<br>components / badge Padding X",
			"theme.geometry.control.switchTrackWidth": "<br>geometry / control / switch Track Width",
			"theme.geometry.control.switchTrackHeight": "<br>geometry / control / switch Track Height",
			"theme.geometry.control.switchThumb": "<br>geometry / control / switch Thumb",
			"theme.geometry.control.buttonHeightXSmall": "<br>geometry / control / button Height XSmall",
			"theme.geometry.control.buttonHeightSmall": "<br>geometry / control / button Height Small",
			"theme.geometry.control.buttonHeight": "<br>geometry / control / button Height",
			"theme.geometry.control.buttonHeightLarge": "<br>geometry / control / button Height Large",
			"theme.geometry.control.buttonHeightXLarge": "<br>geometry / control / button Height XLarge",
			"theme.geometry.control.pageBackgroundHitRadius": "<br>geometry / control / page Background Hit Radius",
			"theme.geometry.control.presenceMarkerExtent": "<br>geometry / control / presence Marker Extent",
			"theme.geometry.control.colorPickerCursorRadius": "<br>geometry / control / color Picker Cursor Radius",
			"theme.geometry.control.swatchExtent": "<br>geometry / control / swatch Extent",
			"theme.geometry.control.segmentedProgressHeight": "<br>geometry / control / segmented Progress Height",
			"theme.geometry.control.fieldHeight": "<br>geometry / control / field Height",
			"theme.geometry.control.selectionControl": "<br>geometry / control / selection Control",
			"theme.geometry.control.selectionIndicatorInset": "<br>geometry / control / selection Indicator Inset",
			"theme.geometry.control.selectionIcon": "<br>geometry / control / selection Icon",
			"theme.geometry.control.toggleWidth": "<br>geometry / control / toggle Width",
			"theme.geometry.control.toggleHeight": "<br>geometry / control / toggle Height",
			"theme.geometry.control.toggleThumb": "<br>geometry / control / toggle Thumb",
			"theme.geometry.control.toggleInset": "<br>geometry / control / toggle Inset",
			"theme.geometry.control.segmentedDenseHeight": "<br>geometry / control / segmented Dense Height",
			"theme.geometry.control.segmentedDenseInset": "<br>geometry / control / segmented Dense Inset",
			"theme.geometry.control.segmentedDenseContentInset": "<br>geometry / control / segmented Dense Content Inset",
			"theme.geometry.control.segmentedDenseItemHeight": "<br>geometry / control / segmented Dense Item Height",
			"theme.geometry.control.slidingSelectionHeight": "<br>geometry / control / sliding Selection Height",
			"theme.geometry.control.slidingSelectionSegmentWidth": "<br>geometry / control / sliding Selection Segment Width",
			"theme.geometry.control.slidingSelectionPadding": "<br>geometry / control / sliding Selection Padding",
			"theme.geometry.control.slidingSelectionIndicatorHeight": "<br>geometry / control / sliding Selection Indicator Height",
			"theme.geometry.control.scrollbarThickness": "<br>geometry / control / scrollbar Thickness",
			"theme.geometry.control.sliderTrackHeight": "<br>geometry / control / slider Track Height",
			"theme.geometry.control.colorPlaneExtent": "<br>geometry / control / color Plane Extent",
			"theme.geometry.control.textFieldIndicatorHeightFactor": "<br>geometry / control / text Field Indicator Height Factor",
			"theme.geometry.control.textFieldLineHeightFactor": "<br>geometry / control / text Field Line Height Factor",
			"theme.geometry.control.textFieldMinLines": "<br>geometry / control / text Field Min Lines",
			"theme.geometry.control.textFieldMaxLines": "<br>geometry / control / text Field Max Lines",
			"theme.geometry.control.fileExplorerRowHeightAdjustment": "<br>geometry / control / file Explorer Row Height Adjustment",
			"theme.geometry.data.codeActionButtonSize": "<br>geometry / data / code Action Button Size",
			"theme.geometry.data.codeHeaderHeight": "<br>geometry / data / code Header Height",
			"theme.geometry.data.codeTerminalDot": "<br>geometry / data / code Terminal Dot",
			"theme.geometry.data.codeTerminalDotGap": "<br>geometry / data / code Terminal Dot Gap",
			"theme.geometry.data.codeHeaderPaddingX": "<br>geometry / data / code Header Padding X",
			"theme.geometry.data.codeBodyPaddingX": "<br>geometry / data / code Body Padding X",
			"theme.geometry.data.codeLineNumberWidth": "<br>geometry / data / code Line Number Width",
			"theme.geometry.data.codeWrappedLineWidth": "<br>geometry / data / code Wrapped Line Width",
			"theme.geometry.data.codeMaximumHeight": "<br>geometry / data / code Maximum Height",
			"theme.geometry.data.codeCollapsedHeight": "<br>geometry / data / code Collapsed Height",
			"theme.geometry.data.codeDisclosureSize": "<br>geometry / data / code Disclosure Size",
			"theme.geometry.data.filePreviewHeight": "<br>geometry / data / file Preview Height",
			"theme.geometry.data.previewCardCompactHeight": "<br>geometry / data / preview Card Compact Height",
			"theme.geometry.data.previewCardStandardHeight": "<br>geometry / data / preview Card Standard Height",
			"theme.geometry.data.previewCardLargeHeight": "<br>geometry / data / preview Card Large Height",
			"theme.geometry.data.dateGridCellHeight": "<br>geometry / data / date Grid Cell Height",
			"theme.geometry.data.keyValueLabelWidthCompact": "<br>geometry / data / key Value Label Width Compact",
			"theme.geometry.data.keyValueLabelWidthStandard": "<br>geometry / data / key Value Label Width Standard",
			"theme.geometry.data.stepperMarkerSize": "<br>geometry / data / stepper Marker Size",
			"theme.geometry.data.stepperLabelWidth": "<br>geometry / data / stepper Label Width",
			"theme.geometry.data.progressIndeterminateFraction": "<br>geometry / data / progress Indeterminate Fraction",
			"theme.geometry.data.placeholderMinimumHeight": "<br>geometry / data / placeholder Minimum Height",
			"theme.geometry.data.placeholderContentPaddingY": "<br>geometry / data / placeholder Content Padding Y",
			"theme.geometry.data.placeholderActionPaddingY": "<br>geometry / data / placeholder Action Padding Y",
			"theme.geometry.data.placeholderHatchBand": "<br>geometry / data / placeholder Hatch Band",
			"theme.geometry.data.placeholderHatchGap": "<br>geometry / data / placeholder Hatch Gap",
			"theme.geometry.data.placeholderLabelTracking": "<br>geometry / data / placeholder Label Tracking",
			"theme.geometry.data.placeholderDetailMaximumWidth": "<br>geometry / data / placeholder Detail Maximum Width",
			"theme.geometry.data.spinnerSquareFactor": "<br>geometry / data / spinner Square Factor",
			"theme.geometry.data.spinnerOrbitFactor": "<br>geometry / data / spinner Orbit Factor",
			"theme.geometry.data.spinnerCornerFactor": "<br>geometry / data / spinner Corner Factor",
			"theme.geometry.layout.drawerWidth": "<br>geometry / layout / drawer Width",
			"theme.geometry.layout.drawerHeight": "<br>geometry / layout / drawer Height",
			"theme.geometry.layout.resizeHandleExtent": "<br>geometry / layout / resize Handle Extent",
			"theme.geometry.layout.overlayViewportInset": "<br>geometry / layout / overlay Viewport Inset",
			"theme.geometry.layout.railDropTargetExtent": "<br>geometry / layout / rail Drop Target Extent",
			"theme.geometry.layout.disclosureIconSize": "<br>geometry / layout / disclosure Icon Size",
			"theme.geometry.layout.treeLeadingGap": "<br>geometry / layout / tree Leading Gap",
			"theme.geometry.layout.tooltipOffsetX": "<br>geometry / layout / tooltip Offset X",
			"theme.geometry.layout.primaryPaneWidth": "<br>geometry / layout / primary Pane Width",
			"theme.geometry.layout.secondaryPaneWidth": "<br>geometry / layout / secondary Pane Width",
			"theme.geometry.layout.primaryPaneBreakpoint": "<br>geometry / layout / primary Pane Breakpoint",
			"theme.geometry.layout.primaryPaneContentBreakpoint": "<br>geometry / layout / primary Pane Content Breakpoint",
			"theme.geometry.layout.responsivePaneBreakpoint": "<br>geometry / layout / responsive Pane Breakpoint",
			"theme.geometry.layout.secondaryPaneBreakpoint": "<br>geometry / layout / secondary Pane Breakpoint",
			"theme.geometry.layout.menuWidth": "<br>geometry / layout / menu Width",
			"theme.geometry.layout.commandMenuWidth": "<br>geometry / layout / command Menu Width",
			"theme.geometry.layout.menuHeaderHeight": "<br>geometry / layout / menu Header Height",
			"theme.geometry.layout.menuItemHeight": "<br>geometry / layout / menu Item Height",
			"theme.geometry.layout.dialogMaximumWidth": "<br>geometry / layout / dialog Maximum Width",
			"theme.geometry.layout.toastMaximumWidth": "<br>geometry / layout / toast Maximum Width",
			"theme.geometry.layout.inlineNoticeBreakpoint": "<br>geometry / layout / inline Notice Breakpoint",
			"theme.geometry.layout.statusBarBreakpoint": "<br>geometry / layout / status Bar Breakpoint",
			"theme.geometry.layout.settingsDialogMaximumWidth": "<br>geometry / layout / settings Dialog Maximum Width",
			"theme.geometry.layout.settingsDialogMaximumHeight": "<br>geometry / layout / settings Dialog Maximum Height",
			"theme.geometry.layout.settingsPaneGap": "<br>geometry / layout / settings Pane Gap",
			"theme.geometry.layout.settingsNavigationWidth": "<br>geometry / layout / settings Navigation Width",
			"theme.geometry.layout.settingsNavigationMinimumWidth": "<br>geometry / layout / settings Navigation Minimum Width",
			"theme.geometry.layout.settingsNavigationMaximumWidth": "<br>geometry / layout / settings Navigation Maximum Width",
			"theme.geometry.layout.settingsContentMaximumWidth": "<br>geometry / layout / settings Content Maximum Width",
			"theme.geometry.layout.themePreviewTileWidth": "<br>geometry / layout / theme Preview Tile Width",
			"theme.geometry.layout.windowHeaderHeight": "<br>geometry / layout / window Header Height",
			"theme.geometry.layout.windowHeaderControlSize": "<br>geometry / layout / window Header Control Size",
			"theme.geometry.layout.windowAppIconSize": "<br>geometry / layout / window App Icon Size",
			"theme.geometry.layout.windowIdentityGap": "<br>geometry / layout / window Identity Gap",
			"theme.geometry.optical.menuIconOffsetY": "<br>geometry / optical / menu Icon Offset Y",
			"theme.geometry.optical.railBadgeInset": "<br>geometry / optical / rail Badge Inset",
			"theme.geometry.optical.statusIconOffsetY": "<br>geometry / optical / status Icon Offset Y",
			"theme.geometry.optical.monoBaselineOffsetY": "<br>geometry / optical / mono Baseline Offset Y",
			"theme.geometry.optical.uiBaselineOffsetY": "<br>geometry / optical / ui Baseline Offset Y",
			"theme.dataVisualization.series": "<br>data Visualization / series",
			"theme.dataVisualization.seriesWash": "<br>data Visualization / series Wash",
			"theme.dataVisualization.axis": "<br>data Visualization / axis",
			"theme.dataVisualization.grid": "<br>data Visualization / grid",
			"theme.dataVisualization.gridStrong": "<br>data Visualization / grid Strong",
			"theme.dataVisualization.label": "<br>data Visualization / label",
			"theme.dataVisualization.value": "<br>data Visualization / value",
			"theme.dataVisualization.plotBackground": "<br>data Visualization / plot Background",
			"theme.dataVisualization.crosshair": "<br>data Visualization / crosshair",
			"theme.dataVisualization.marketUp": "<br>data Visualization / market Up",
			"theme.dataVisualization.marketUpWash": "<br>data Visualization / market Up Wash",
			"theme.dataVisualization.marketDown": "<br>data Visualization / market Down",
			"theme.dataVisualization.marketDownWash": "<br>data Visualization / market Down Wash",
			"theme.dataVisualization.marketFlat": "<br>data Visualization / market Flat"
		}
	}
});
