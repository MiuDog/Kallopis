import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_stroke.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnSelect extends StatefulWidget {
  const PlnSelect({
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
  State<PlnSelect> createState() => _PlnSelectState();
}

class _PlnSelectState extends State<PlnSelect> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final strokeState = !widget.enabled
        ? PlnStrokeState.disabled
        : _focused
        ? PlnStrokeState.focused
        : _hovered
        ? PlnStrokeState.hovered
        : PlnStrokeState.rest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlnText(widget.label, role: PlnTextRole.caption),
        const SizedBox(height: PlnSpace.xs),
        PlnStrokeFrame(
          role: PlnStrokeRole.field,
          state: strokeState,
          radius: PlnRadius.control,
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PlnRadius.control),
            ),
            child: InkWell(
              onTap: widget.enabled ? widget.onPressed : null,
              onHover: (value) => setState(() => _hovered = value),
              onFocusChange: (value) => setState(() => _focused = value),
              borderRadius: BorderRadius.circular(PlnRadius.control),
              child: SizedBox(
                height: PlnFormMetrics.fieldHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: PlnSpace.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: PlnText(
                          widget.value,
                          tone: widget.enabled
                              ? PlnTextTone.primary
                              : PlnTextTone.faint,
                        ),
                      ),
                      PlnIcon(
                        PlnIcons.chevronDown,
                        size: PlnSize.iconSmall,
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
