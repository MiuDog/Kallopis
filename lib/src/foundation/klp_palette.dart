import 'package:flutter/widgets.dart';

abstract final class KlpPalette {
  /// 「沒有顏色」。這不是風格決定，但仍然需要一個名字——散落各處的
  /// `Color(0x00000000)` 無法與真正寫死的顏色區分，會讓紀律檢查失去意義。
  static const Color transparent = Color(0x00000000);

  static const Color paper = Color(0xFFF2F0EB);
  static const Color canvas = Color(0xFFE4E0D8);
  static const Color paperInset = Color(0xFFE6E3DC);
  static const Color canvasMuted = Color(0xFFDAD4CA);
  static const Color component = Color(0xFFF7F5F0);
  static const Color stage = Color(0xFFFFFEFC);
  static const Color guide = Color(0xFF8C8477);
  static const Color divider = Color(0xFFD6D0C6);
  static const Color ink = Color(0xFF1D1D1D);
  static const Color inkMuted = Color(0xFF5B554C);
  static const Color inkFaint = Color(0xFFB5AEA0);
  static const Color line = Color(0x00000000);
  static const Color lineStrong = Color(0x00000000);
  static const Color accent = Color(0xFF1D1D1D);
  static const Color accentSoft = Color(0xFFE6E3DC);
  static const Color interaction = Color(0xFF1D1D1D);
  static const Color interactionSoft = Color(0xFFE6E3DC);
  static const Color lightSuccess = Color(0xFF3B7240);
  static const Color lightWarning = Color(0xFF7E6525);
  static const Color lightDanger = Color(0xFFA14736);
  static const Color lightInfo = Color(0xFF466A7C);
  static const Color darkSuccess = Color(0xFF6BB371);
  static const Color darkWarning = Color(0xFFCCAF66);
  static const Color darkDanger = Color(0xFFD28D7F);
  static const Color darkInfo = Color(0xFF81A8BB);

  static const Color night = Color(0xFF000000);
  static const Color nightRaised = Color(0xFF0A0A09);
  static const Color nightInset = Color(0xFF121110);
  static const Color nightMuted = Color(0xFF1A1917);
  static const Color nightComponent = Color(0xFF0A0A09);
  static const Color nightStage = Color(0xFF0A0A09);
  static const Color nightGuide = Color(0xFF7A7566);
  static const Color nightDivider = Color(0xFF45413A);
  static const Color chalk = Color(0xFFF5F2EC);
  static const Color chalkMuted = Color(0xFFC8C2B6);
  static const Color chalkFaint = Color(0xFF7A7566);
  static const Color nightLine = Color(0x00000000);
  static const Color nightLineStrong = Color(0x00000000);
  static const Color nightInteractionSoft = Color(0xFF213A32);
  static const Color pureBlack = Color(0xFF000000);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color modalScrim = Color(0x99000000);

  static const Color dusk = Color(0xFF171513);
  static const Color duskRaised = Color(0xFF171513);
  static const Color duskInset = Color(0xFF211F1C);
  static const Color duskMuted = Color(0xFF292622);
  static const Color duskLifted = Color(0xFF34302C);
  static const Color duskComponent = Color(0xFF211F1C);
  static const Color duskStage = Color(0xFF211F1C);
  static const Color duskGuide = Color(0xFF918A7B);
  static const Color duskDivider = Color(0xFF585249);

  static const Color transparentSurface = Color(0x94292622);
  static const Color transparentSurfaceInset = Color(0xA834302C);
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
