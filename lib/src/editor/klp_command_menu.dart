import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../interaction/klp_roving_index.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

@immutable
class KlpCommandItemData {
  const KlpCommandItemData({
    required this.label,
    this.onPressed,
    this.caption,
    this.shortcut,
    this.selected = false,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? caption;
  final String? shortcut;
  final bool selected;
  final bool danger;
}

@immutable
class KlpCommandSectionData {
  const KlpCommandSectionData({required this.label, required this.items});

  final String label;
  final List<KlpCommandItemData> items;
}

/// 命令面板：分組的指令清單，存在的意義就是不用滑鼠也能操作。
///
/// **鍵盤**：`↓`／`↑` 在（跨分組攤平後的）項目間移動高亮，跳過
/// [KlpCommandItemData.onPressed] 為 `null`（停用）的項目，並在頭尾之間循環；
/// `Home`／`End` 跳到第一／最後一個可用項目；`Enter`／`Space` 觸發目前高亮的
/// 項目；`Escape` 呼叫 [onEscape]。索引移動規則沿用 [KlpRovingIndex]，與
/// [KlpMenu]、[KlpCombobox] 共用同一套實作。
///
/// 面板預設會在出現時自動取得鍵盤焦點（[autofocus]），因為命令面板通常是剛彈出
/// 的 overlay。
class KlpCommandMenu extends StatefulWidget {
  const KlpCommandMenu({
    super.key,
    required this.sections,
    this.width = 300,
    this.framed = true,
    this.autofocus = true,
    this.onEscape,
  });

  final List<KlpCommandSectionData> sections;
  final double width;
  final bool framed;

  /// 是否在面板出現時自動取得鍵盤焦點。預設 `true`。
  final bool autofocus;

  /// 按下 `Escape` 時呼叫，通常由呼叫端用來關閉面板；未提供時無效果。
  final VoidCallback? onEscape;

  @override
  State<KlpCommandMenu> createState() => _KlpCommandMenuState();
}

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
    final tokens = context.klpColors;

    var flatIndex = -1;
    final content = Padding(
      padding: EdgeInsets.all(context.klp.space.tight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final section in widget.sections) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.klp.space.compact,
                context.klp.space.compact,
                context.klp.space.compact,
                context.klp.space.tight,
              ),
              child: KlpText(
                section.label.toUpperCase(),
                role: KlpTextRole.label,
                tone: KlpTextTone.faint,
              ),
            ),
            for (final item in section.items)
              _CommandItem(
                data: item,
                keyboardHighlighted: ++flatIndex == _highlightedIndex,
              ),
          ],
        ],
      ),
    );
    final menu = widget.framed
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.component,
              borderRadius: BorderRadius.circular(context.klp.shape.card),
            ),
            child: content,
          )
        : content;

    return Focus(
      autofocus: widget.autofocus,
      onKeyEvent: _handleKey,
      child: SizedBox(width: widget.width, child: menu),
    );
  }
}

class _CommandItem extends StatelessWidget {
  const _CommandItem({required this.data, this.keyboardHighlighted = false});

  final KlpCommandItemData data;

  /// 由 [KlpCommandMenu] 以鍵盤方向鍵移動出的高亮狀態。沿用與
  /// [KlpCommandItemData.selected] 相同的底色語言——這個元件目前沒有另一套
  /// hover 視覺可以借用，加第三種視覺不如共用既有的這一種。
  final bool keyboardHighlighted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final enabled = data.onPressed != null;
    final highlighted = data.selected || keyboardHighlighted;
    final foreground = data.danger
        ? tokens.danger
        : enabled
        ? tokens.text
        : tokens.textFaint;

    return Semantics(
      button: true,
      enabled: enabled,
      selected: data.selected,
      child: Material(
        color: highlighted ? tokens.surfaceMuted : tokens.clear,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: InkWell(
          onTap: data.onPressed,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.klp.space.compact,
              vertical: context.klp.space.compact,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KlpText(data.label, color: foreground),
                      if (data.caption != null)
                        KlpText(
                          data.caption!,
                          role: KlpTextRole.caption,
                          tone: enabled ? KlpTextTone.muted : KlpTextTone.faint,
                        ),
                    ],
                  ),
                ),
                if (data.shortcut != null)
                  KlpText(
                    data.shortcut!,
                    role: KlpTextRole.code,
                    tone: KlpTextTone.faint,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
