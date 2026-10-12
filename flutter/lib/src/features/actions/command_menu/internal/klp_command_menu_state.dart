part of '../klp_command_menu.dart';

class _KlpCommandMenuState extends State<KlpCommandMenu> {
  int _highlightedIndex = -1;

  List<KlpCommandItemData> get _flatItems => [
    for (final section in widget.sections) ...section.items,
  ];

  bool _isEnabled(int index) => _flatItems[index].onPressed != null;

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final items = _flatItems;
    final count = items.length;
    if (count == 0) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.move(
          current: _highlightedIndex,
          count: count,
          forward: true,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.move(
          current: _highlightedIndex,
          count: count,
          forward: false,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.first(
          count: count,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.last(
          count: count,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_highlightedIndex >= 0 && _highlightedIndex < count) {
        items[_highlightedIndex].onPressed?.call();
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onEscape?.call();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    var flatIndex = -1;
    final content = KlpBox(
      paddingSize: KlpSpaceSize.tight,
      child: KlpColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final section in widget.sections) ...[
            KlpBox(
              insets: KlpBoxInsets.directional(
                start: context.klp.space.contentInset,
                top: context.klp.space.contentInset,
                end: context.klp.space.contentInset,
                bottom: context.klp.space.tight,
              ),
              child: KlpText(
                section.label.toUpperCase(),
                role: KlpTextRole.label,
                tone: KlpTextTone.faint,
              ),
            ),
            for (final item in section.items)
              _KlpCommandItem(
                data: item,
                keyboardHighlighted: ++flatIndex == _highlightedIndex,
              ),
          ],
        ],
      ),
    );
    final menu = widget.framed
        ? _KlpCommandMenuSurfaceFrame(child: content)
        : content;

    return _KlpCommandMenuKeyboardRegion(
      autofocus: widget.autofocus,
      onKeyEvent: _handleKey,
      child: KlpBox(widthSize: KlpSpaceSize.commandMenuWidth, child: menu),
    );
  }
}
