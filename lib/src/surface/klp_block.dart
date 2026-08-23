import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../theme/klp_theme.dart';
import 'klp_surface.dart';

part 'internal/klp_block_handle.dart';

/// 文件內容的共通互動基底。
///
/// hover、focus 與受控選取共用同一套高亮；左上角六點操作鈕透過
/// [onHandlePressed] 回報選單錨點。拖曳 callbacks 只回報手勢，區塊順序仍由
/// Docs 等消費端持有。
class KlpBlock extends StatefulWidget {
  const KlpBlock({
    super.key,
    required this.child,
    required this.handleLabel,
    required this.onHandlePressed,
    required this.onPressed,
    this.selected = false,
    this.padding,
    this.onHover,
    this.semanticLabel,
    this.onHandleDragStart,
    this.onHandleDragUpdate,
    this.onHandleDragEnd,
  });

  final Widget child;
  final String handleLabel;
  final ValueChanged<Offset> onHandlePressed;

  /// `null` 只用於刻意停用的呈現；Docs 內容區塊應提供 callback。
  final VoidCallback? onPressed;
  final bool selected;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<bool>? onHover;
  final String? semanticLabel;

  /// Catalog 不提供這三個 callback，因此六點操作鈕只能開啟選單、不能重新排序。
  final GestureDragStartCallback? onHandleDragStart;
  final GestureDragUpdateCallback? onHandleDragUpdate;
  final GestureDragEndCallback? onHandleDragEnd;

  @override
  State<KlpBlock> createState() => _KlpBlockState();
}

class _KlpBlockState extends State<KlpBlock> {
  var _hovered = false;
  var _focused = false;

  void _handleHover(bool hovered) {
    if (_hovered == hovered) return;
    setState(() => _hovered = hovered);
    widget.onHover?.call(hovered);
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final radius = BorderRadius.circular(klp.shape.control);
    final highlighted = widget.selected || _hovered || _focused;
    final surface = KlpSurface(
      tone: KlpSurfaceTone.component,
      border: widget.selected
          ? Border.all(
              color: context.klpColors.textMuted,
              width: klp.shape.hairline,
            )
          : null,
      radius: klp.shape.control,
      padding: widget.padding ?? EdgeInsets.all(klp.space.base),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final handle = _KlpBlockHandle(
            key: const ValueKey('klp-block-handle'),
            label: widget.handleLabel,
            onPressed: widget.onHandlePressed,
            onDragStart: widget.onHandleDragStart,
            onDragUpdate: widget.onHandleDragUpdate,
            onDragEnd: widget.onHandleDragEnd,
          );

          return Row(
            mainAxisSize: constraints.hasBoundedWidth
                ? MainAxisSize.max
                : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              handle,
              SizedBox(width: klp.space.compact),
              if (constraints.hasBoundedWidth)
                Expanded(child: widget.child)
              else
                widget.child,
            ],
          );
        },
      ),
    );

    return Semantics(
      container: true,
      label: widget.semanticLabel,
      button: widget.onPressed != null,
      selected: widget.onPressed == null ? null : widget.selected,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onPressed,
            onFocusChange: (focused) => setState(() => _focused = focused),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStatePropertyAll(klp.color.clear),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                surface,
                if (highlighted)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        key: const ValueKey('klp-block-highlight'),
                        decoration: BoxDecoration(
                          color: klp.selectionWash,
                          borderRadius: radius,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KlpBlockCanvas extends StatelessWidget {
  const KlpBlockCanvas({
    super.key,
    required this.children,
    this.constrained = false,
  });

  final List<Widget> children;
  final bool constrained;

  @override
  Widget build(BuildContext context) {
    final canvas = KlpSurface(
      tone: KlpSurfaceTone.inset,
      child: Stack(children: children),
    );

    return constrained ? canvas : InteractiveViewer(child: canvas);
  }
}
