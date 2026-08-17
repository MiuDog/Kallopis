import 'package:flutter/widgets.dart';

class PlnInteractionSettings extends InheritedWidget {
  const PlnInteractionSettings({
    super.key,
    required super.child,
    this.longPressThreshold = defaultThreshold,
  });

  static const Duration defaultThreshold = Duration(milliseconds: 500);

  final Duration longPressThreshold;

  static Duration thresholdOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<PlnInteractionSettings>()
            ?.longPressThreshold ??
        defaultThreshold;
  }

  @override
  bool updateShouldNotify(PlnInteractionSettings oldWidget) {
    return longPressThreshold != oldWidget.longPressThreshold;
  }
}

extension PlnInteractionSettingsContext on BuildContext {
  Duration get plnLongPressThreshold =>
      PlnInteractionSettings.thresholdOf(this);
}
