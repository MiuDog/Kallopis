part of '../klp_list_tile.dart';

/// ListTile 專用的 Flutter 互動與表面實作邊界。
class _KlpListTileFrame extends StatefulWidget {
  const _KlpListTileFrame({
    required this.onPressed,
    required this.selected,
    required this.style,
    required this.child,
  });

  final VoidCallback? onPressed;
  final bool selected;
  final _KlpListTileFrameStyle style;
  final Widget child;

  @override
  State<_KlpListTileFrame> createState() => _KlpListTileFrameState();
}
