import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../interaction/klp_roving_index.dart';
import '../overlay/klp_menu.dart';
import '../theme/klp_theme.dart';
import 'klp_text_field.dart';

/// [KlpCombobox] 的一個候選項。
@immutable
class KlpComboboxOption {
  const KlpComboboxOption({required this.id, required this.label});

  /// 穩定識別碼，用於 `Key` 與比對，不用於顯示。
  final String id;

  /// 顯示文字，也是輸入時比對過濾的依據。
  final String label;
}

/// 可輸入的下拉選單（autocomplete）。
///
/// **輸入框重用 [KlpTextField]，下拉面板重用 [KlpMenu]**——本庫「一條規則只能有
/// 一個實作」：欄位外觀與選單外觀已經各自只有一份，這裡不重新畫一套。
///
/// 是**受控元件**：目前的輸入文字（[query]）、候選清單（[options]）都由呼叫端
/// 持有並傳入，本元件只負責過濾顯示、鍵盤導覽與觸發 [onQueryChanged]／
/// [onSelected]。選出一個選項後，呼叫端通常會把 [query] 更新成該選項的
/// [KlpComboboxOption.label]。
///
/// 鍵盤：↓／↑ 在目前過濾結果間移動，Enter 選定醒目提示的項目；[allowFreeText]
/// 為 `true` 時，Enter 在沒有醒目提示項目但輸入框非空時改觸發
/// [onFreeTextSubmitted]，讓呼叫端接受清單以外的自由輸入值。Esc 收起面板。
class KlpCombobox extends StatefulWidget {
  const KlpCombobox({
    super.key,
    required this.label,
    required this.query,
    required this.options,
    required this.menuLabel,
    required this.onQueryChanged,
    required this.onSelected,
    this.placeholder,
    this.helper,
    this.error,
    this.enabled = true,
    this.allowFreeText = false,
    this.onFreeTextSubmitted,
  }) : assert(
         !allowFreeText || onFreeTextSubmitted != null,
         'allowFreeText 為 true 時必須提供 onFreeTextSubmitted。',
       );

  /// 輸入框的標籤。
  final String label;

  /// 目前的輸入文字。過濾候選清單時以此比對。
  final String query;

  /// 全部候選項；本元件依 [query] 在其中過濾顯示，不會向外發出額外的查詢。
  final List<KlpComboboxOption> options;

  /// 下拉面板（[KlpMenu]）頂部的分組標題文字。
  final String menuLabel;

  final String? placeholder;
  final String? helper;
  final String? error;
  final bool enabled;

  /// 使用者輸入文字時呼叫，攜帶最新的輸入內容。
  final ValueChanged<String> onQueryChanged;

  /// 使用者以滑鼠或鍵盤選定一個候選項時呼叫。
  final ValueChanged<KlpComboboxOption> onSelected;

  /// 是否允許輸入清單以外的自由文字。為 `true` 時必須提供 [onFreeTextSubmitted]。
  final bool allowFreeText;

  /// [allowFreeText] 為 `true` 時，按下 Enter 但沒有醒目提示項目時呼叫，
  /// 攜帶目前的輸入文字。
  final ValueChanged<String>? onFreeTextSubmitted;

  @override
  State<KlpCombobox> createState() => _KlpComboboxState();
}

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
    // 只在文字是被外部（例如選定選項後）改掉時才同步進 controller——使用者自己
    // 打字時，controller 早已是同一個值，這裡是 no-op，不會打斷輸入中的游標。
    if (_controller.text != widget.query) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
    if (oldWidget.query != widget.query) {
      _highlightedIndex = -1;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _highlightedIndex = -1;
    }
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

    return Focus(
      onKeyEvent: _handleKey,
      child: Column(
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
            SizedBox(height: context.klp.space.tight),
            KlpMenu(
              label: widget.menuLabel,
              // combobox 自己已經在管方向鍵與焦點（見上方 [Focus]／[_handleKey]），
              // 選單這裡不能再搶自動焦點，否則會把焦點從輸入框搬走，使用者打字
              // 打到一半就被踢出輸入框。
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
