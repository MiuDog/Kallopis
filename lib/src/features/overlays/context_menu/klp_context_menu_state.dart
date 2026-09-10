part of '../klp_context_menu.dart';

class _KlpContextMenuState extends State<KlpContextMenu> {
  final OverlayPortalController _controller = OverlayPortalController();
  Offset _anchor = Offset.zero;

  @override
  void initState() {
    super.initState();
    _attachController();
  }

  @override
  void didUpdateWidget(KlpContextMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    oldWidget.controller?._detach();
    _attachController();
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  void _attachController() {
    widget.controller?._attach(open: _openAt, close: _close);
  }

  void _openAt(Offset globalPosition) {
    setState(() => _anchor = globalPosition);
    _controller.show();
  }

  void _close() {
    if (_controller.isShowing) _controller.hide();
  }

  /// 包一層 `onPressed`：選到項目後先關閉選單再執行原本的動作，
  /// 呼叫端不需要自己記得關閉時機。
  List<KlpMenuItemData> _dismissingItems() => [
    for (final item in widget.items)
      KlpMenuItemData(
        key: item.key,
        label: item.label,
        icon: item.icon,
        shortcut: item.shortcut,
        toggleValue: item.toggleValue,
        hasSubmenu: item.hasSubmenu,
        danger: item.danger,
        separatedBefore: item.separatedBefore,
        dashedSeparatorBefore: item.dashedSeparatorBefore,
        selected: item.selected,
        enabled: item.enabled,
        onPressed: () {
          _close();
          item.onPressed();
        },
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final separatorCount = widget.items
        .where((item) => item.separatedBefore || item.dashedSeparatorBefore)
        .length;

    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (overlayContext) {
        final viewport = MediaQuery.sizeOf(overlayContext);
        final position = KlpMenuLayout.resolvePosition(
          anchor: _anchor,
          viewport: viewport,
          context: overlayContext,
          itemCount: widget.items.length,
          separatorCount: separatorCount,
        );

        return KlpStack(
          children: [
            KlpPositioned.fill(
              child: KlpGestureRegion(
                behavior: HitTestBehavior.opaque,
                onTap: _close,
                onSecondaryTap: _close,
                child: const KlpBox.expand(),
              ),
            ),
            KlpPositioned(
              left: position.dx,
              top: position.dy,
              child: KlpMenu(
                label: widget.label,
                items: _dismissingItems(),
                onEscape: _close,
              ),
            ),
          ],
        );
      },
      child: KlpGestureRegion(
        onSecondaryTapDown: (details) => _openAt(details.globalPosition),
        child: RawGestureDetector(
          gestures: {
            LongPressGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  LongPressGestureRecognizer
                >(
                  () => LongPressGestureRecognizer(
                    duration: context.klp.motion.longPressThreshold,
                  ),
                  (recognizer) =>
                      recognizer.onLongPressStart = (details) =>
                          _openAt(details.globalPosition),
                ),
          },
          child: widget.child,
        ),
      ),
    );
  }
}
