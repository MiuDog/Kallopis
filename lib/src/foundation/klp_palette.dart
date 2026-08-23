import 'package:flutter/widgets.dart';

part 'internal/klp_accent.dart';

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

  /// oklch(1.000 0.000 89.9)
  static const Color ink50 = Color(0xFFFFFFFF);

  /// oklch(0.955 0.007 88.6)
  static const Color ink100 = Color(0xFFF2F0EB);

  /// oklch(0.929 0.009 84.6)
  static const Color ink150 = Color(0xFFEAE7E1);

  /// oklch(0.916 0.010 87.5)
  static const Color ink200 = Color(0xFFE6E3DC);

  /// oklch(0.784 0.013 83.6)
  static const Color ink250 = Color(0xFFBCB8B0);

  /// oklch(0.734 0.015 82.4)
  static const Color ink300 = Color(0xFFADA89E);

  /// oklch(0.683 0.015 80.9)
  static const Color ink350 = Color(0xFF9E998F);

  /// oklch(0.633 0.012 79.0)
  static const Color ink400 = Color(0xFF8E8982);

  /// oklch(0.583 0.010 77.2)
  static const Color ink450 = Color(0xFF7F7A75);

  /// oklch(0.532 0.008 75.3)
  static const Color ink500 = Color(0xFF6F6C67);

  /// oklch(0.506 0.019 79.3)
  static const Color ink550 = Color(0xFF6B6459);

  /// oklch(0.432 0.003 221.2)
  static const Color ink600 = Color(0xFF4F5151);

  /// oklch(0.382 0.003 227.4)
  static const Color ink650 = Color(0xFF414344);

  /// oklch(0.331 0.004 233.6)
  static const Color ink700 = Color(0xFF343637);

  /// oklch(0.309 0.000 89.9)
  static const Color ink750 = Color(0xFF303030);

  /// oklch(0.281 0.000 89.9)
  static const Color ink800 = Color(0xFF292929);

  /// oklch(0.256 0.000 89.9)
  static const Color ink850 = Color(0xFF232323);

  /// oklch(0.231 0.000 89.9)
  static const Color ink900 = Color(0xFF1D1D1D);

  /// oklch(0.173 0.000 89.9)
  static const Color ink950 = Color(0xFF101010);

  // ── 資料視覺化 primitive ──

  static const List<Color> chartSeriesLight = [
    Color(0xFFE0BE73),
    Color(0xFFD3A152),
    Color(0xFFC6823D),
    Color(0xFFA96836),
    Color(0xFF895137),
    Color(0xFF683E33),
  ];
  static const List<Color> chartSeriesDark = [
    Color(0xFFF0D79A),
    Color(0xFFE8BD70),
    Color(0xFFDFA04E),
    Color(0xFFC88745),
    Color(0xFFA86D43),
    Color(0xFF89573E),
  ];
  static const List<Color> chartSeriesWashLight = [
    Color(0xFFF8F1E2),
    Color(0xFFF6EBD7),
    Color(0xFFF3E4CF),
    Color(0xFFEEDDD0),
    Color(0xFFE9D8D1),
    Color(0xFFE4D5D1),
  ];
  static const List<Color> chartSeriesWashDark = [
    Color(0xFF453D2B),
    Color(0xFF443725),
    Color(0xFF413222),
    Color(0xFF3D2D22),
    Color(0xFF382A23),
    Color(0xFF332724),
  ];
  static const List<Color> chartSeriesWashUltraDark = [
    Color(0xFF302B20),
    Color(0xFF30271B),
    Color(0xFF2E241A),
    Color(0xFF2C211B),
    Color(0xFF291F1C),
    Color(0xFF261D1C),
  ];

  static const Color chartAxisLight = Color(0xFFD6D0C6);
  static const Color chartGridLight = Color(0xFFE4E1DA);
  static const Color chartGridStrongLight = Color(0xFFC8C0B4);
  static const Color chartLabelLight = Color(0xFF6B6459);
  static const Color chartValueLight = Color(0xFF1D1D1D);
  static const Color chartCrosshairLight = Color(0xFF8C8477);
  static const Color chartMarketUpLight = Color(0xFF2D8057);
  static const Color chartMarketUpWashLight = Color(0xFFDFF0E5);
  static const Color chartMarketDownLight = Color(0xFFA7443F);
  static const Color chartMarketDownWashLight = Color(0xFFFAE3E2);
  static const Color chartMarketFlatLight = Color(0xFF8C8477);

  static const Color chartAxisDark = Color(0xFF585249);
  static const Color chartGridDark = Color(0xFF433F3A);
  static const Color chartGridStrongDark = Color(0xFF6A6256);
  static const Color chartLabelDark = Color(0xFFB8B2A4);
  static const Color chartValueDark = Color(0xFFF5F2EC);
  static const Color chartCrosshairDark = Color(0xFF918A7B);
  static const Color chartMarketUpDark = Color(0xFF67AE86);
  static const Color chartMarketUpWashDark = Color(0xFF243B2D);
  static const Color chartMarketDownDark = Color(0xFFD27B74);
  static const Color chartMarketDownWashDark = Color(0xFF472925);
  static const Color chartMarketFlatDark = Color(0xFF918A7B);

  static const Color chartAxisUltraDark = Color(0xFF45413A);
  static const Color chartGridUltraDark = Color(0xFF34302B);
  static const Color chartGridStrongUltraDark = Color(0xFF585249);
  static const Color chartLabelUltraDark = Color(0xFFB8B2A4);
  static const Color chartValueUltraDark = Color(0xFFF5F2EC);
  static const Color chartCrosshairUltraDark = Color(0xFF7A7566);
  static const Color chartMarketUpUltraDark = Color(0xFF67AE86);
  static const Color chartMarketUpWashUltraDark = Color(0xFF1D3025);
  static const Color chartMarketDownUltraDark = Color(0xFFD27B74);
  static const Color chartMarketDownWashUltraDark = Color(0xFF3B2320);
  static const Color chartMarketFlatUltraDark = Color(0xFF7A7566);

  // ── 語意色 ──────────────────────────────────────────────────────────────
  // 只用於狀態，不參與視覺層級。
  // 一律使用高明度策展色，不因淺色模式另外調整為暗色。
  //
  /// oklch(0.703 0.131 155.1)
  static const Color success = Color(0xFF51B77B);
  static const Color darkSuccess = success;
  static const Color lightSuccess = success;

  /// oklch(0.707 0.174 19.7)
  static const Color danger = Color(0xFFFA6C73);
  static const Color darkDanger = danger;
  static const Color lightDanger = danger;

  /// oklch(0.813 0.156 80.2)
  static const Color warning = Color(0xFFF6B52E);
  static const Color darkWarning = warning;
  static const Color lightWarning = warning;

  /// oklch(0.668 0.126 250.5)
  static const Color info = Color(0xFF5499DF);
  static const Color darkInfo = info;
  static const Color lightInfo = info;

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

/// 裝飾用顏色：**不屬於設計語言**，因此不會隨主題改變。
///
/// 這些顏色出現在「畫一張示意圖」的場合——主題預覽磚要模擬桌布與視窗紅綠燈，那是插圖，
/// 不是介面。它們刻意與 [KlpPalette] 分開：混在一起會讓人誤以為可以拿來上色元件，
/// 而元件用了它們就會在換主題時原地不動。
abstract final class KlpDecorativePalette {
  /// 主題預覽磚模擬的桌布漸層。
  static const List<Color> previewWallpaper = [
    Color(0xFF2B3A67),
    Color(0xFF6E4E7E),
    Color(0xFFC0693F),
    Color(0xFFE0A24A),
  ];

  static const List<double> previewWallpaperStops = [0, 0.42, 0.78, 1];

  /// 視窗控制鈕的紅、黃、綠。這是對桌面平台既有慣例的複述，不是本設計系統的色彩選擇。
  static const List<Color> windowTrafficLights = [
    Color(0xFFF2655B),
    Color(0xFFF5BE4F),
    Color(0xFF63C654),
  ];
}
