import 'package:flutter/widgets.dart';

part 'internal/klp_accent.dart';

/// Layer 1：primitive token（原始階梯）。
///
/// 這一層只有數值，**沒有語意**——`space400` 不知道自己會被用在哪裡。任何「這個位置該用
/// 多少」的判斷都屬於 layer 2（semantic）或 layer 3（component）。
///
/// primitive 刻意維持 `static const` 且**不可被消費者覆寫**：它是設計語言的字彙表，不是
/// 設定項。消費者要調整外觀，覆寫的是 semantic 或 component token（兩者都是
/// `ThemeExtension`），而不是重新定義「4 是多少」。
///
/// 命名採數值階梯而非 t-shirt size，因為 t-shirt size 本身就是一種語意宣稱
/// （「md 是預設」），那屬於 layer 2。
abstract final class KlpScale {
	// 間距：4 為基準格，2 為半格。刻意不是等比級數——UI 密度在小尺寸需要更細的解析度。
	static const double space0 = 0;
	static const double space50 = 2;
	static const double space100 = 4;
	static const double space200 = 8;
	static const double space250 = 10;
	static const double space300 = 12;
	static const double space400 = 16;
	static const double space600 = 24;
	static const double space800 = 32;
	static const double space1000 = 40;
	static const double space1200 = 48;
	static const double space1600 = 64;
	static const double space2400 = 96;

	// 圓角
	static const double radius0 = 0;
	static const double radius50 = 2;
	static const double radius100 = 4;
	static const double radius150 = 6;
	static const double radius200 = 8;
	static const double radius250 = 10;
	static const double radius300 = 12;
	static const double radius400 = 16;
	static const double radiusFull = 9999;

	// 線寬
	static const double stroke0 = 0;
	static const double stroke100 = 1;
	static const double stroke200 = 2;

	// 字級
	static const double font100 = 10;
	static const double font200 = 12;
	static const double font300 = 14;
	static const double font400 = 16;
	static const double font500 = 18;
	static const double font600 = 22;
	static const double font700 = 28;
	static const double font800 = 36;
	static const double font900 = 48;
	static const double font1000 = 64;

	// 行高倍率
	static const double leading100 = 1.125;
	static const double leading116 = 1.166;
	static const double leading120 = 1.200;
	static const double leading122 = 1.222;
	static const double leading127 = 1.272;
	static const double leading128 = 1.285;
	static const double leading133 = 1.333;
	static const double leading142 = 1.428;
	static const double leading150 = 1.500;
	static const double leading155 = 1.555;
	static const double leading150Legacy = 1.2;
	static const double leading200 = 1.25;
	static const double leading300 = 1.3;
	static const double leading350 = 1.35;
	static const double leading400 = 1.4;
	static const double leading450 = 1.45;
	static const double leading500 = 1.5;
	static const double leading550 = 1.55;
	static const double leading650 = 1.65;

	// 字距
	static const double tracking0 = 0;
	static const double trackingTight = -0.5;
	static const double trackingWide = 1.2;
	static const double trackingWider = 1.32;

	// 字重
	static const FontWeight weight400 = FontWeight.w400;
	static const FontWeight weight500 = FontWeight.w500;
	static const FontWeight weight600 = FontWeight.w600;
	static const FontWeight weight700 = FontWeight.w700;
	static const FontWeight weight800 = FontWeight.w800;

	// 時長。duration0 不是「沒有動畫」的同義詞，而是「這個過場刻意瞬間完成」，
	// 例如切換主題時不希望整個畫面漸變。
	static const Duration duration0 = Duration.zero;
	static const Duration duration100 = Duration(milliseconds: 120);
	static const Duration duration150 = Duration(milliseconds: 140);
	static const Duration duration400 = Duration(milliseconds: 450);
	static const Duration duration500 = Duration(milliseconds: 500);

	// 緩動
	static const Curve easeStandard = Curves.easeOutCubic;
	static const Curve easeEmphasized = Curves.easeInOutCubic;

	// 不透明度
	static const double opacity100 = 0.10;
	static const double opacity120 = 0.12;
	static const double opacity140 = 0.14;
	static const double opacity160 = 0.16;
	static const double opacity180 = 0.18;
	static const double opacity220 = 0.22;
	static const double opacity280 = 0.28;
	static const double opacity320 = 0.32;
	static const double opacity440 = 0.44;
	static const double opacity480 = 0.48;
	static const double opacity550 = 0.55;
	static const double opacity620 = 0.62;
	static const double opacity720 = 0.72;
	static const double opacity780 = 0.78;
	static const double opacity820 = 0.82;
}

const Color _inkAccentLight = KlpPalette.ink900;
const Color _inkAccentDark = KlpPalette.ink50;
const Color _terracottaAccentLight = Color(0xFF92563C);
const Color _terracottaAccentDark = Color(0xFFC18468);
const Color _ochreAccentLight = Color(0xFF7D612F);
const Color _ochreAccentDark = Color(0xFFAE8D55);
const Color _oliveAccentLight = Color(0xFF5E6A39);
const Color _oliveAccentDark = Color(0xFF8A995C);
const Color _slateAccentLight = Color(0xFF4E678A);
const Color _slateAccentDark = Color(0xFF7D94B3);
const Color _crimsonAccentLight = Color(0xFF9F4B59);
const Color _crimsonAccentDark = Color(0xFFC37F8A);

abstract final class KlpPalette {
	/// 「沒有顏色」。這不是風格決定，但仍然需要一個名字——散落各處的
	/// `Color(0x00000000)` 無法與真正寫死的顏色區分，會讓紀律檢查失去意義。
	static const Color transparent = Color(0x00000000);

	// ── ink：中性色梯 ────────────────────────────────────────────────────────
	//
	// 整套設計語言的骨架。所有表面、文字與線條都由這 11 階推導，**不再有各自命名的
	// 中性色**——`paper`／`chalk`／`dusk` 那種名字看不出彼此的明度關係，於是每次要
	// 新增一階都得重新猜。
	//
	// 權威定義是 oklch（等亮度感知，調整時可預測）；hex 是 sRGB 的實作值。
	// Flutter 的 `Color` 只認 sRGB，因此 oklch 記在註解裡——**改值時改的是 oklch，
	// hex 是換算結果**，反過來做會讓明度階梯逐漸走樣。
	//
	// 淺色端 (50-300): 偏向溫暖石色 (H: 79°~89°, C: 0.000~0.019)
	// 中間層 (400-600): 平滑過渡區間
	// 深色端 (700-950): 收斂為中性石墨色，避免與暖色表面產生色偏競爭。

	static const Color ink50 = Color(0xFFFFFFFF); // oklch(1.000 0.000 89.9)
	static const Color ink100 = Color(0xFFF2F0EB); // oklch(0.955 0.007 88.6)
	static const Color ink150 = Color(0xFFEAE7E1); // oklch(0.929 0.009 84.6)
	static const Color ink200 = Color(0xFFE6E3DC); // oklch(0.916 0.010 87.5)
	static const Color ink250 = Color(0xFFBCB8B0); // oklch(0.784 0.013 83.6)
	static const Color ink300 = Color(0xFFADA89E); // oklch(0.734 0.015 82.4)
	static const Color ink350 = Color(0xFF9E998F); // oklch(0.683 0.015 80.9)
	static const Color ink400 = Color(0xFF8E8982); // oklch(0.633 0.012 79.0)
	static const Color ink450 = Color(0xFF7F7A75); // oklch(0.583 0.010 77.2)
	static const Color ink500 = Color(0xFF6F6C67); // oklch(0.532 0.008 75.3)
	static const Color ink550 = Color(0xFF6B6459); // oklch(0.506 0.019 79.3)
	static const Color ink600 = Color(0xFF4F5151); // oklch(0.432 0.003 221.2)
	static const Color ink650 = Color(0xFF414344); // oklch(0.382 0.003 227.4)
	static const Color ink700 = Color(0xFF343637); // oklch(0.331 0.004 233.6)
	static const Color ink750 = Color(0xFF303030); // oklch(0.309 0.000 89.9)
	static const Color ink800 = Color(0xFF292929); // oklch(0.281 0.000 89.9)
	static const Color ink850 = Color(0xFF232323); // oklch(0.256 0.000 89.9)
	static const Color ink900 = Color(0xFF1D1D1D); // oklch(0.231 0.000 89.9)
	static const Color ink950 = Color(0xFF101010); // oklch(0.173 0.000 89.9)

	// ── 暖中性色階 ──────────────────────────────────────────────────────────
	// 名稱只描述色族與明度，不宣告 axis、grid 或主題模式等使用情境。
	static const Color warmNeutral25 = Color(0xFFF5F2EC);
	static const Color warmNeutral50 = Color(0xFFE4E1DA);
	static const Color warmNeutral100 = Color(0xFFD6D0C6);
	static const Color warmNeutral200 = Color(0xFFC8C0B4);
	static const Color warmNeutral300 = Color(0xFFB8B2A4);
	static const Color warmNeutral400 = Color(0xFF918A7B);
	static const Color warmNeutral450 = Color(0xFF8C8477);
	static const Color warmNeutral500 = Color(0xFF7A7566);
	static const Color warmNeutral600 = Color(0xFF6A6256);
	static const Color warmNeutral700 = Color(0xFF585249);
	static const Color warmNeutral750 = Color(0xFF45413A);
	static const Color warmNeutral800 = Color(0xFF433F3A);
	static const Color warmNeutral900 = Color(0xFF34302B);

	// ── 大地色階 ────────────────────────────────────────────────────────────
	// 每一個色族由淺至深排列；如何組成系列與背景 wash 由 semantic theme 決定。
	static const Color sand50 = Color(0xFFF8F1E2);
	static const Color sand300 = Color(0xFFF0D79A);
	static const Color sand500 = Color(0xFFE0BE73);
	static const Color sand800 = Color(0xFF453D2B);
	static const Color sand900 = Color(0xFF302B20);
	static const Color gold50 = Color(0xFFF6EBD7);
	static const Color gold300 = Color(0xFFE8BD70);
	static const Color gold500 = Color(0xFFD3A152);
	static const Color gold800 = Color(0xFF443725);
	static const Color gold900 = Color(0xFF30271B);
	static const Color ochre50 = Color(0xFFF3E4CF);
	static const Color ochre300 = Color(0xFFDFA04E);
	static const Color ochre500 = Color(0xFFC6823D);
	static const Color ochre800 = Color(0xFF413222);
	static const Color ochre900 = Color(0xFF2E241A);
	static const Color terracotta50 = Color(0xFFEEDDD0);
	static const Color terracotta300 = Color(0xFFC88745);
	static const Color terracotta500 = Color(0xFFA96836);
	static const Color terracotta800 = Color(0xFF3D2D22);
	static const Color terracotta900 = Color(0xFF2C211B);
	static const Color clay50 = Color(0xFFE9D8D1);
	static const Color clay300 = Color(0xFFA86D43);
	static const Color clay500 = Color(0xFF895137);
	static const Color clay800 = Color(0xFF382A23);
	static const Color clay900 = Color(0xFF291F1C);
	static const Color umber50 = Color(0xFFE4D5D1);
	static const Color umber300 = Color(0xFF89573E);
	static const Color umber500 = Color(0xFF683E33);
	static const Color umber800 = Color(0xFF332724);
	static const Color umber900 = Color(0xFF261D1C);

	// ── 綠色與紅色色階 ──────────────────────────────────────────────────────
	// 狀態方向由 semantic theme 指派；primitive 本身只提供顏色。
	static const Color green100 = Color(0xFFDFF0E5);
	static const Color green400 = Color(0xFF67AE86);
	static const Color green500 = Color(0xFF51B77B);
	static const Color green600 = Color(0xFF2D8057);
	static const Color green800 = Color(0xFF243B2D);
	static const Color green900 = Color(0xFF1D3025);
	static const Color red100 = Color(0xFFFAE3E2);
	static const Color red300 = Color(0xFFFA6C73);
	static const Color red400 = Color(0xFFD27B74);
	static const Color red600 = Color(0xFFA7443F);
	static const Color red800 = Color(0xFF472925);
	static const Color red900 = Color(0xFF3B2320);
	static const Color amber500 = Color(0xFFF6B52E); // oklch(0.813 0.156 80.2)
	static const Color blue500 = Color(0xFF5499DF); // oklch(0.668 0.126 250.5)

	// ── 極值與特例 ──────────────────────────────────────────────────────────

	// ── 由色梯推導的特例 ────────────────────────────────────────────────────
	// **這裡不得出現梯以外的色相。** 每一個值都是某一階加上 alpha，或是純粹的「無色」。

	/// 遮罩。ink950 @ 60%。
	static const Color scrim = Color(0x99010202);

	/// 邊框預設透明：結構表面靠 tone 分層，不靠描邊。
	static const Color line = Color(0x00000000);

	/// 半透明視窗的表面。ink800／ink700 加上視窗透明度。
	static const Color transparentSurface = Color(0x9426292D);
	static const Color transparentSurfaceInset = Color(0xA8404449);

	/// 對比前景的兩個極值。`KlpThemeContrast` 用它們挑「在這個底色上該用黑字還白字」，
	/// **不作為表面或文字的 token**——表面與文字一律取梯上的階。
	static const Color pureWhite = Color(0xFFFFFFFF);
	static const Color pureBlack = Color(0xFF000000);
}
