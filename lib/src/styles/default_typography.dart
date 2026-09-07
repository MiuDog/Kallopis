part of '../theme/klp_typography_theme.dart';

/// 此分類的預設風格 recipe；schema 的公開 static 成員保留相同值與 const 契約。

const String _sans = 'packages/kallopis/Noto Sans TC';

const String _mono = 'packages/kallopis/IBM Plex Mono';

/// 系統預設字體與接手順序。
const List<String> _fallback = [
	'Noto Sans TC',
	'Microsoft JhengHei UI',
	'Microsoft JhengHei',
	'PingFang TC',
	'sans-serif',
];

const List<String> _monoFallback = [
	_sans,
	'IBM Plex Mono',
	'Consolas',
	'Courier New',
	'monospace',
];

const KlpTypographyTheme _defaultTypography = KlpTypographyTheme(
	sansFamily: _sans,
	sansFallback: _fallback,
	monoFamily: _mono,
	monoFallback: _monoFallback,
	uiFamily: _sans,
	bodyFamily: _sans,
	codeFamily: _mono,
	micro: KlpScale.font100, // 10px
	caption: KlpScale.font200, // 12px
	sub: KlpScale.font300, // 14px
	body: KlpScale.font400, // 16px
	lead: KlpScale.font500, // 18px
	h4: KlpScale.font600, // 22px
	h3: KlpScale.font700, // 28px
	h2: KlpScale.font800, // 36px
	h1: KlpScale.font900, // 48px
	display: KlpScale.font1000, // 64px
	label: KlpScale.font300, // 14px
	section: KlpScale.font700,
	headingSmall: KlpScale.font600,
	heading: KlpScale.font800,
	title: KlpScale.font900,
	microLeading: KlpScale.leading120, // 1.200 (12/10)
	captionLeading: KlpScale.leading133, // 1.333 (16/12)
	subLeading: KlpScale.leading142, // 1.428 (20/14)
	bodyLeading: KlpScale.leading150, // 1.500 (24/16)
	leadLeading: KlpScale.leading155, // 1.555 (28/18)
	h4Leading: KlpScale.leading127, // 1.272 (28/22)
	h3Leading: KlpScale.leading128, // 1.285 (36/28)
	h2Leading: KlpScale.leading122, // 1.222 (44/36)
	h1Leading: KlpScale.leading116, // 1.166 (56/48)
	displayLeading: KlpScale.leading100, // 1.125 (72/64)
	headingLeading: KlpScale.leading122,
	codeLeading: KlpScale.leading142,
	readingLeading: KlpScale.leading155,
	labelLeading: KlpScale.leading133,
	labelTracking: KlpScale.tracking0,
	displayTracking: KlpScale.trackingTight,
	regular: KlpScale.weight400,
	medium: KlpScale.weight400,
	semiBold: KlpScale.weight600,
	bold: KlpScale.weight700,
	extraBold: KlpScale.weight700,
	strong: KlpScale.weight600,
);
