import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

enum KlpProgressState { active, paused, success, failure }

class KlpProgress extends StatelessWidget {
  const KlpProgress({
    super.key,
    this.value,
    this.label,
    this.trailing,
    this.segments = 12,
    this.detail,
    this.state = KlpProgressState.active,
    this.onCancel,
  });

  final double? value;
  final String? label;
  final String? trailing;
  final int segments;
  final String? detail;
  final KlpProgressState state;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final safeValue = value?.clamp(0.0, 1.0).toDouble();
    final fillColor = switch (state) {
      KlpProgressState.active => tokens.info,
      KlpProgressState.paused => tokens.warning,
      KlpProgressState.success => tokens.success,
      KlpProgressState.failure => tokens.danger,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (label != null)
              Expanded(child: KlpText(label!, role: KlpTextRole.caption))
            else
              const Spacer(),
            if (safeValue != null)
              KlpText(
                trailing ?? '${(safeValue * 100).round()}%',
                role: KlpTextRole.code,
                tone: KlpTextTone.muted,
              ),
            if (onCancel != null && state == KlpProgressState.active) ...[
              const SizedBox(width: KlpSpace.sm),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onCancel,
                child: const KlpText(
                  'Cancel',
                  role: KlpTextRole.label,
                  tone: KlpTextTone.muted,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: KlpSpace.sm),
        Container(
          height: KlpSpace.xs,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(KlpRadius.full),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: safeValue ?? 0.35,
            child: ColoredBox(color: fillColor),
          ),
        ),
        if (detail != null) ...[
          const SizedBox(height: KlpSpace.sm),
          KlpText(detail!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
        ],
      ],
    );
  }
}
