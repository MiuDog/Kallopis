import 'package:flutter/widgets.dart';

class KlpInteractionSettings extends InheritedWidget {
  const KlpInteractionSettings({
    super.key,
    required super.child,
    this.longPressThreshold = defaultThreshold,
  });

  static const Duration defaultThreshold = Duration(milliseconds: 500);

  final Duration longPressThreshold;

  static Duration thresholdOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<KlpInteractionSettings>()
            ?.longPressThreshold ??
        defaultThreshold;
  }

  @override
  bool updateShouldNotify(KlpInteractionSettings oldWidget) {
    return longPressThreshold != oldWidget.longPressThreshold;
  }
}

extension KlpInteractionSettingsContext on BuildContext {
  Duration get plnLongPressThreshold =>
      KlpInteractionSettings.thresholdOf(this);
}
