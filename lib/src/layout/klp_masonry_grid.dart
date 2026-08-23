import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

/// 將高度不同的內容依序分配到多欄的瀑布流版面。
class KlpMasonryGrid extends StatelessWidget {
  const KlpMasonryGrid({
    super.key,
    required this.children,
    this.minimumColumnWidth,
  });

  final List<Widget> children;
  final double? minimumColumnWidth;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final gap = klp.space.itemGap;
    final effectiveMinimum =
        minimumColumnWidth ?? klp.geometry.layout.themePreviewTileWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = ((constraints.maxWidth + gap) / (effectiveMinimum + gap))
            .floor()
            .clamp(1, children.length);
        final columns = List.generate(count, (_) => <Widget>[]);

        for (var index = 0; index < children.length; index++) {
          columns[index % count].add(children[index]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var column = 0; column < columns.length; column++) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (
                      var index = 0;
                      index < columns[column].length;
                      index++
                    ) ...[
                      columns[column][index],
                      if (index < columns[column].length - 1)
                        SizedBox(height: gap),
                    ],
                  ],
                ),
              ),
              if (column < columns.length - 1) SizedBox(width: gap),
            ],
          ],
        );
      },
    );
  }
}
