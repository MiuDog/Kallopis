part of '../klp_navigator.dart';

class _KlpNavigatorItemView extends StatelessWidget {
  const _KlpNavigatorItemView({required this.item, required this.level});

  final KlpNavigatorItem item;
  final int level;

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      KlpNavigatorCategory() => _KlpNavigatorCategoryView(
        category: item as KlpNavigatorCategory,
      ),
      KlpNavigatorElement() => _KlpNavigatorElementView(
        element: item as KlpNavigatorElement,
        level: level,
      ),
      KlpNavigatorComponent() => KlpBox(
        key: ValueKey(item.id),
        child: (item as KlpNavigatorComponent).child,
      ),
    };
  }
}
