import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_dashed_border.dart';
import '../surface/klp_stroke.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 下拉選擇的觸發器。**它只負責顯示目前的值與觸發 `onPressed`**，選單本身由呼叫端
/// 以 `KlpMenu` 開啟——選項來源是產品資料，不屬於視覺層。
class KlpSelect extends StatefulWidget {
  const KlpSelect({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final String value;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  State<KlpSelect> createState() => _KlpSelectState();
}

class _KlpSelectState extends State<KlpSelect> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final strokeState = !widget.enabled
        ? KlpStrokeState.disabled
        : _focused
        ? KlpStrokeState.focused
        : _hovered
        ? KlpStrokeState.hovered
        : KlpStrokeState.rest;

    Widget field = KlpStrokeFrame(
      role: KlpStrokeRole.field,
      state: strokeState,
      radius: context.klp.shape.control,
      child: Material(
        color: tokens.clear,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        ),
        child: InkWell(
          onTap: widget.enabled ? widget.onPressed : null,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (value) => setState(() => _focused = value),
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          child: SizedBox(
            height: context.klp.geometry.control.fieldHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.klp.space.base),
              child: Row(
                children: [
                  Expanded(
                    child: KlpText(
                      widget.value,
                      tone: widget.enabled
                          ? KlpTextTone.primary
                          : KlpTextTone.faint,
                    ),
                  ),
                  KlpIcon(
                    KlpIcons.chevronDown,
                    size: context.klp.space.iconSmall,
                    color: widget.enabled ? tokens.textMuted : tokens.textFaint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if ((_hovered || _focused) && widget.enabled) {
      field = KlpDashedBorder(
        color: _focused ? tokens.textMuted : context.klp.hoverBorder,
        radius: context.klp.shape.control,
        child: field,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(widget.label, role: KlpTextRole.caption),
        SizedBox(height: context.klp.space.tight),
        field,
      ],
    );
  }
}
