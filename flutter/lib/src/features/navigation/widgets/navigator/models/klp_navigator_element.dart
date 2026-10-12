part of '../klp_navigator_models.dart';

/// 可在根層或分類內出現，並可遞迴包含子元素的 Navigator 節點。
@immutable
final class KlpNavigatorElement extends KlpNavigatorItem {
  const KlpNavigatorElement({
    required super.id,
    required this.label,
    this.icon,
    this.children = const [],
    this.expandable = false,
    this.expanded = false,
    this.selected = false,
    this.badge,
    this.trailing,
    this.data,
  });

  final String label;
  final KlpIconData? icon;
  final List<KlpNavigatorElement> children;
  final bool expandable;
  final bool expanded;
  final bool selected;
  final String? badge;
  final Widget? trailing;
  final Object? data;

  bool get isBranch => expandable || children.isNotEmpty;
}
