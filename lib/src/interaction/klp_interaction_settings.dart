import 'package:flutter/widgets.dart';

import '../theme/klp_theme_scope.dart';

/// 長按門檻的區域覆寫。
///
/// 門檻的**預設值來自 theme**（`KlpMotionTheme.longPressThreshold`），這個 InheritedWidget
/// 只負責「某一小塊 UI 要用不一樣的門檻」。原本它自己持有一份 `defaultThreshold` 常數，
/// 與 theme 構成同一條規則的兩份實作——兩份實作必然靜默分岔，改了 theme 卻沒改這裡時
/// 不會有任何錯誤，只是門檻沒變。
class KlpInteractionSettings extends InheritedWidget {
  const KlpInteractionSettings({
    super.key,
    required super.child,
    this.longPressThreshold,
  });

  /// `null` 表示沿用 theme 的值。
  final Duration? longPressThreshold;

  static Duration thresholdOf(BuildContext context) {
    final override = context
        .dependOnInheritedWidgetOfExactType<KlpInteractionSettings>()
        ?.longPressThreshold;
    return override ?? KlpTheme.of(context).motion.longPressThreshold;
  }

  @override
  bool updateShouldNotify(KlpInteractionSettings oldWidget) {
    return longPressThreshold != oldWidget.longPressThreshold;
  }
}

extension KlpInteractionSettingsContext on BuildContext {
  Duration get klpLongPressThreshold =>
      KlpInteractionSettings.thresholdOf(this);
}
