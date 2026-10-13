part of '../klp_combobox.dart';

class _KlpComboboxState extends State<KlpCombobox> {
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller = TextEditingController(
    text: widget.query,
  );
  int _highlightedIndex = -1;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant KlpCombobox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部改寫查詢時才同步，避免使用者輸入時重設游標位置。
    if (_controller.text != widget.query) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
    if (oldWidget.query != widget.query) _highlightedIndex = -1;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) _highlightedIndex = -1;
    setState(() {});
  }

  List<KlpComboboxOption> get _filteredOptions {
    final query = widget.query.trim().toLowerCase();
    if (query.isEmpty) return widget.options;
    return widget.options
        .where((option) => option.label.toLowerCase().contains(query))
        .toList();
  }

  void _select(KlpComboboxOption option) {
    widget.onSelected(option);
    _focusNode.unfocus();
  }

  void _submitHighlightedOrFreeText() {
    final options = _filteredOptions;
    if (_highlightedIndex >= 0 && _highlightedIndex < options.length) {
      _select(options[_highlightedIndex]);
      return;
    }
    if (widget.allowFreeText && widget.query.trim().isNotEmpty) {
      widget.onFreeTextSubmitted!(widget.query);
      _focusNode.unfocus();
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final options = _filteredOptions;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (options.isEmpty) return KeyEventResult.ignored;
      setState(
        () => _highlightedIndex = KlpRovingIndex.move(
          current: _highlightedIndex,
          count: options.length,
          forward: true,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (options.isEmpty) return KeyEventResult.ignored;
      setState(
        () => _highlightedIndex = KlpRovingIndex.move(
          current: _highlightedIndex,
          count: options.length,
          forward: false,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submitHighlightedOrFreeText();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _focusNode.unfocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final options = _filteredOptions;
    final showDropdown =
        widget.enabled && _focusNode.hasFocus && options.isNotEmpty;

    return KlpFocusRegion(
      onKeyEvent: _handleKey,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpTextField(
            label: widget.label,
            controller: _controller,
            placeholder: widget.placeholder,
            helper: widget.helper,
            error: widget.error,
            enabled: widget.enabled,
            focusNode: _focusNode,
            onChanged: widget.onQueryChanged,
            onSubmitted: (_) => _submitHighlightedOrFreeText(),
          ),
          if (showDropdown) ...[
            const KlpGap.heightSize(KlpSpaceSize.tight),
            KlpMenu(
              label: widget.menuLabel,
              // 輸入框持有焦點與方向鍵，選單不能搶走自動焦點。
              autofocus: false,
              items: [
                for (var index = 0; index < options.length; index++)
                  KlpMenuItemData(
                    key: ValueKey(options[index].id),
                    label: options[index].label,
                    selected: index == _highlightedIndex,
                    onPressed: () => _select(options[index]),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
