import 'package:flutter/widgets.dart';

import '../../styling/legacy_theme/klp_theme.dart';

/// 格狀虛擬化捲動檢視。
class KlpVirtualGrid extends StatelessWidget {
  const KlpVirtualGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minimumItemWidth = 240,
    this.crossAxisCount,
    this.spacing,
    this.childAspectRatio = 1.0,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double minimumItemWidth;
  final int? crossAxisCount;
  final double? spacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count =
            crossAxisCount ??
            (constraints.maxWidth / minimumItemWidth).floor().clamp(
              1,
              itemCount == 0 ? 1 : itemCount,
            );

        return GridView.builder(
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisSpacing: spacing ?? context.klp.space.base,
            crossAxisSpacing: spacing ?? context.klp.space.base,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
