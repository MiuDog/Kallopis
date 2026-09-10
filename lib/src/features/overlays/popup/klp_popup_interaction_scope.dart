part of '../klp_popup.dart';

/// 供 App frame 注入視窗標題列保留範圍。
class KlpPopupInteractionScope extends InheritedWidget {
  const KlpPopupInteractionScope({
    super.key,
    required this.topInset,
    required super.child,
  });

  final double topInset;

  static double topInsetOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<KlpPopupInteractionScope>()
          ?.topInset ??
      0;

  @override
  bool updateShouldNotify(KlpPopupInteractionScope oldWidget) =>
      topInset != oldWidget.topInset;
}
