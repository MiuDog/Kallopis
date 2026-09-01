import 'package:flutter/widgets.dart';

class KlpSettingsPaneScope extends InheritedWidget {
  const KlpSettingsPaneScope({
    super.key,
    required this.embedded,
    required super.child,
  });

  final bool embedded;

  static bool isEmbedded(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<KlpSettingsPaneScope>()
            ?.embedded ??
        false;
  }

  @override
  bool updateShouldNotify(KlpSettingsPaneScope oldWidget) {
    return embedded != oldWidget.embedded;
  }
}
