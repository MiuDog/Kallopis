import 'package:flutter/widgets.dart';

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
  // 淺色端 (50-300): 偏向溫暖石色 (H: 75°~88°, C: 0.015~0.018)
  // 中間層 (400-600): 平滑過渡區間
  // 深色端 (700-950): 完全收斂回冷藍灰 (H: 238°~249°, C: 0.003~0.009)

  /// oklch(0.970 0.006 87.9)
  static const Color ink50 = Color(0xFFF7F5F1);

  /// oklch(0.930 0.009 87.8)
  static const Color ink100 = Color(0xFFEAE8E1);

  /// oklch(0.860 0.015 80.7)
  static const Color ink200 = Color(0xFFD6D0C6);

  /// oklch(0.770 0.018 84.1)
  static const Color ink300 = Color(0xFFBAB4A8);

  /// oklch(0.680 0.014 82.0)
  static const Color ink400 = Color(0xFF9D988F);

  /// oklch(0.580 0.008 78.6)
  static const Color ink500 = Color(0xFF7D7A75);

  /// oklch(0.480 0.002 70.2)
  static const Color ink600 = Color(0xFF5E5D5C);

  /// oklch(0.380 0.002 267.3)
  static const Color ink700 = Color(0xFF424244);

  /// oklch(0.280 0.004 264.5)
  static const Color ink800 = Color(0xFF28292B);

  /// oklch(0.180 0.004 264.5)
  static const Color ink900 = Color(0xFF111213);

  /// oklch(0.120 0.004 264.5)
  static const Color ink950 = Color(0xFF050607);

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
  static const Color scrim = Color(0x99050607);

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
