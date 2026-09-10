import 'package:flutter/foundation.dart';

import '../shell/theme/klp_theme_preview_tile.dart';

/// 顏色模式預覽的文案與可用狀態。
@immutable
class KlpThemeModeOption {
  const KlpThemeModeOption({
    required this.mode,
    required this.label,
    required this.description,
    this.enabled = true,
  });

  final KlpThemePreviewMode mode;
  final String label;
  final String description;
  final bool enabled;
}
