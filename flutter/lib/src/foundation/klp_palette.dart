import 'package:flutter/widgets.dart';

/// 裝飾用顏色：**不屬於設計語言**，因此不會隨主題改變。
///
/// 這些顏色出現在「畫一張示意圖」的場合——主題預覽磚要模擬桌布與視窗紅綠燈，那是插圖，
/// 不是介面。它們刻意與 `KlpPalette` 分開：混在一起會讓人誤以為可以拿來上色元件，
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
