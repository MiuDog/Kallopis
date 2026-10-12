part of '../klp_file_explorer.dart';

class _KlpFileExplorerInteractiveRow extends StatelessWidget {
  const _KlpFileExplorerInteractiveRow({
    required this.spacing,
    required this.onHoverChanged,
    required this.onTap,
    required this.child,
  });

  final KlpFileExplorerSpacing spacing;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: KlpGestureRegion(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: KlpBox(insets: spacing.itemPadding(context), child: child),
      ),
    );
  }
}
