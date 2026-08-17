import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_stroke.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(widget.label, role: KlpTextRole.caption),
        const SizedBox(height: KlpSpace.xs),
        KlpStrokeFrame(
          role: KlpStrokeRole.field,
          state: strokeState,
          radius: KlpRadius.control,
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KlpRadius.control),
            ),
            child: InkWell(
              onTap: widget.enabled ? widget.onPressed : null,
              onHover: (value) => setState(() => _hovered = value),
              onFocusChange: (value) => setState(() => _focused = value),
              borderRadius: BorderRadius.circular(KlpRadius.control),
              child: SizedBox(
                height: KlpFormMetrics.fieldHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KlpSpace.md),
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
                        size: KlpSize.iconSmall,
                        color: widget.enabled
                            ? tokens.textMuted
                            : tokens.textFaint,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
