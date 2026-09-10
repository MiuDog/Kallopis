part of '../klp_date_grid.dart';

/// 日期格專用的七欄 Flutter grid 實作邊界。
class _KlpDateGridViewport extends StatelessWidget {
  const _KlpDateGridViewport({
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisExtent: context.klp.geometry.data.dateGridCellHeight,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
