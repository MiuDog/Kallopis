part of '../klp_date_grid.dart';

/// 日期格專用的邊線、表面與內距實作邊界。
class _KlpDateGridCellFrame extends StatelessWidget {
  const _KlpDateGridCellFrame({
    required this.index,
    required this.itemCount,
    required this.selected,
    required this.child,
  });

  final int index;
  final int itemCount;
  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final separator = BorderSide(
      color: context.klpColors.border,
      width: klp.shape.hairline,
    );
    final columnIndex = index % 7;
    final isWeekend = columnIndex == 0 || columnIndex == 6;
    final tone = selected
        ? KlpSurfaceTone.component
        : (isWeekend ? KlpSurfaceTone.muted : KlpSurfaceTone.transparent);

    return KlpSurface(
      tone: tone,
      radius: 0,
      border: Border(
        right: columnIndex == 6 ? BorderSide.none : separator,
        bottom: index + 7 >= itemCount ? BorderSide.none : separator,
      ),
      padding: EdgeInsets.all(klp.space.tight + klp.space.hairline),
      child: child,
    );
  }
}
