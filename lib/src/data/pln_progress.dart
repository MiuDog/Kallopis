import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

enum PlnProgressState { active, paused, success, failure }

class PlnProgress extends StatelessWidget {
  const PlnProgress({
    super.key,
    this.value,
    this.label,
    this.trailing,
    this.segments = 12,
    this.detail,
    this.state = PlnProgressState.active,
    this.onCancel,
  });

  final double? value;
  final String? label;
  final String? trailing;
  final int segments;
  final String? detail;
  final PlnProgressState state;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final safeValue = value?.clamp(0.0, 1.0).toDouble();
    final fillColor = switch (state) {
      PlnProgressState.active => tokens.info,
      PlnProgressState.paused => tokens.warning,
      PlnProgressState.success => tokens.success,
      PlnProgressState.failure => tokens.danger,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (label != null)
              Expanded(child: PlnText(label!, role: PlnTextRole.caption))
            else
              const Spacer(),
            if (safeValue != null)
              PlnText(
                trailing ?? '${(safeValue * 100).round()}%',
                role: PlnTextRole.code,
                tone: PlnTextTone.muted,
              ),
            if (onCancel != null && state == PlnProgressState.active) ...[
              const SizedBox(width: PlnSpace.sm),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onCancel,
                child: const PlnText(
                  'Cancel',
                  role: PlnTextRole.label,
                  tone: PlnTextTone.muted,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: PlnSpace.sm),
        Container(
          height: PlnSpace.xs,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(PlnRadius.full),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: safeValue ?? 0.35,
            child: ColoredBox(color: fillColor),
          ),
        ),
        if (detail != null) ...[
          const SizedBox(height: PlnSpace.sm),
          PlnText(detail!, role: PlnTextRole.caption, tone: PlnTextTone.muted),
        ],
      ],
    );
  }
}
