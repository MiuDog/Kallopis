part of '../klp_canvas_workspace.dart';

/// 選取範圍與可選 resize handles 的通用覆層。
class KlpCanvasSelectionOverlay extends StatelessWidget {
  const KlpCanvasSelectionOverlay({
    super.key,
    required this.child,
    this.selected = true,
    this.showHandles = false,
  });

  final Widget child;
  final bool selected;
  final bool showHandles;

  @override
  Widget build(BuildContext context) {
    return _KlpCanvasSelectionFrame(
      selected: selected,
      showHandles: showHandles,
      child: child,
    );
  }
}
