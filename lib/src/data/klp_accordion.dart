import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// [KlpAccordion] 裡的單一可摺疊項目。
///
/// [id] 在同一個 [KlpAccordion] 內須唯一，用來追蹤展開狀態；[child] 是展開後顯示的
/// 內容——它何時被建構、狀態如何保留由呼叫端決定，這裡不快取也不知道內容是什麼。
@immutable
class KlpAccordionItemData {
  const KlpAccordionItemData({
    required this.id,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;
  final Widget child;
}

/// 可摺疊的內容區清單。
///
/// [multiple] 為 `false`（預設）時同一時間只能展開一項，再點其他標題會先收合原本
/// 展開的那項；為 `true` 時各項互不影響。展開狀態是暫存的 UI 狀態而非產品資料，
/// 因此元件自行持有——需要預先展開特定項目或觀察變化時用 [initialExpandedIds] 與
/// [onExpandedChanged]。
class KlpAccordion extends StatefulWidget {
  const KlpAccordion({
    super.key,
    required this.items,
    this.multiple = false,
    this.initialExpandedIds = const <String>{},
    this.onExpandedChanged,
  });

  final List<KlpAccordionItemData> items;
  final bool multiple;
  final Set<String> initialExpandedIds;
  final ValueChanged<Set<String>>? onExpandedChanged;

  @override
  State<KlpAccordion> createState() => _KlpAccordionState();
}

class _KlpAccordionState extends State<KlpAccordion> {
  late Set<String> _expandedIds;

  @override
  void initState() {
    super.initState();
    _expandedIds = {...widget.initialExpandedIds};
  }

  void _toggle(String id) {
    setState(() {
      final isExpanded = _expandedIds.contains(id);
      if (widget.multiple) {
        if (isExpanded) {
          _expandedIds = {..._expandedIds}..remove(id);
        } else {
          _expandedIds = {..._expandedIds, id};
        }
      } else {
        _expandedIds = isExpanded ? const <String>{} : {id};
      }
    });
    widget.onExpandedChanged?.call(_expandedIds);
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.items.length; i++) ...[
          if (i > 0) SizedBox(height: klp.space.tight),
          _KlpAccordionPanel(
            item: widget.items[i],
            expanded: _expandedIds.contains(widget.items[i].id),
            onToggle: () => _toggle(widget.items[i].id),
          ),
        ],
      ],
    );
  }
}

class _KlpAccordionPanel extends StatefulWidget {
  const _KlpAccordionPanel({
    required this.item,
    required this.expanded,
    required this.onToggle,
  });

  final KlpAccordionItemData item;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  State<_KlpAccordionPanel> createState() => _KlpAccordionPanelState();
}

class _KlpAccordionPanelState extends State<_KlpAccordionPanel> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final isHighlighted = _hovered || _focused;

    Widget header = Material(
      color: klp.color.clear,
      borderRadius: BorderRadius.circular(klp.shape.control),
      child: InkWell(
        onTap: widget.onToggle,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        overlayColor: WidgetStatePropertyAll(klp.color.clear),
        borderRadius: BorderRadius.circular(klp.shape.control),
        child: Semantics(
          button: true,
          expanded: widget.expanded,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: klp.space.compact,
              vertical: klp.space.compact,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      KlpText(widget.item.title, role: KlpTextRole.bodyStrong),
                      if (widget.item.subtitle != null) ...[
                        SizedBox(height: klp.space.tight),
                        KlpText(
                          widget.item.subtitle!,
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: klp.space.compact),
                AnimatedRotation(
                  turns: widget.expanded ? 0.5 : 0,
                  duration: klp.motion.stateTransition,
                  curve: klp.motion.standard,
                  child: KlpIcon(
                    KlpIcons.chevronDown,
                    size: klp.space.iconSmall,
                    color: tokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (isHighlighted) {
      // KlpDashedBorder 目前固定用 guide 色（無法自訂 color），與其餘元件的
      // hover 虛線框色一致；一旦它加回可自訂顏色的參數，這裡應改用 klp.hoverBorder。
      header = KlpDashedBorder(radius: klp.shape.control, child: header);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        AnimatedSize(
          duration: klp.motion.stateTransition,
          curve: klp.motion.standard,
          alignment: Alignment.topCenter,
          child: widget.expanded
              ? Padding(
                  padding: EdgeInsets.only(
                    left: klp.space.compact,
                    right: klp.space.compact,
                    bottom: klp.space.compact,
                  ),
                  child: widget.item.child,
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
