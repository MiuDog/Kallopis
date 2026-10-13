part of '../klp_dock_header.dart';

/// Dock Group 專用的緊湊 Header。
///
/// 左側區域可由 Layout 包成拖曳來源；右側 actions 是獨立 clickable 區域，
/// 因此操作按鈕不會誤觸 panel 拖曳。
class KlpDockHeader extends StatefulWidget {
  static const double extent = 32;

  const KlpDockHeader({
    super.key,
    required this.leading,
    this.actions = const [],
    this.dragRegionBuilder,
  });

  final Widget leading;
  final List<KlpDockHeaderAction> actions;
  final KlpDockHeaderDragRegionBuilder? dragRegionBuilder;

  @override
  State<KlpDockHeader> createState() => _KlpDockHeaderState();
}
