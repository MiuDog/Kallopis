part of '../klp_dock_header.dart';

class _KlpDockHeaderState extends State<KlpDockHeader> {
  final ScrollController _scrollController = ScrollController();
  final KlpContextMenuController _menuController = KlpContextMenuController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final delta = event.scrollDelta.dy != 0
        ? event.scrollDelta.dy
        : event.scrollDelta.dx;
    final nextOffset = (_scrollController.offset + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();

    _scrollController.jumpTo(nextOffset);
  }

  @override
  Widget build(BuildContext context) {
    final moreActionsLabel = KlpLocalizations.of(context).dockMoreActionsLabel;
    return KlpBox(
      height: KlpDockHeader.extent,
      child: KlpLayoutBuilder(
        builder: (context, constraints) {
          final actionSlotExtent = context.klp.space.iconButton;
          final totalSlots = (constraints.maxWidth / actionSlotExtent).floor();
          final maxActionSlots = (totalSlots - 1).clamp(
            0,
            widget.actions.length,
          );
          final needsOverflow = widget.actions.length > maxActionSlots;
          final visibleCount = needsOverflow
              ? (maxActionSlots - 1).clamp(0, widget.actions.length)
              : widget.actions.length;
          final visibleActions = widget.actions
              .take(visibleCount)
              .toList(growable: false);
          final overflowActions = widget.actions
              .skip(visibleCount)
              .toList(growable: false);
          final leading = _KlpDockHeaderViewport(
            controller: _scrollController,
            onPointerSignal: _handlePointerSignal,
            child: widget.leading,
          );
          return KlpPanelHeader(
            content: leading,
            dragRegionBuilder: widget.dragRegionBuilder,
            actions: [
              for (final action in visibleActions)
                KlpIconButton(
                  icon: action.icon,
                  label: action.label,
                  onPressed: action.enabled ? action.onPressed : null,
                  tone: KlpIconButtonTone.inline,
                ),
              if (overflowActions.isNotEmpty)
                _KlpDockContextBuilder(
                  builder: (buttonContext) => KlpContextMenu(
                    controller: _menuController,
                    label: moreActionsLabel,
                    items: [
                      for (final action in overflowActions)
                        KlpMenuItemData(
                          icon: action.icon,
                          label: action.label,
                          enabled: action.enabled,
                          onPressed: action.onPressed,
                        ),
                    ],
                    child: KlpIconButton(
                      icon: KlpIcons.more,
                      label: moreActionsLabel,
                      tone: KlpIconButtonTone.inline,
                      onPressed: () {
                        final renderObject = buttonContext.findRenderObject();
                        if (renderObject is! RenderBox) return;

                        _menuController.openAt(
                          renderObject.localToGlobal(
                            Offset(0, renderObject.size.height),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
