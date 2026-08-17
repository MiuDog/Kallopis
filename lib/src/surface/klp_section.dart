import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../typography/klp_text.dart';

class KlpSection extends StatelessWidget {
  const KlpSection({
    super.key,
    required this.title,
    required this.child,
    this.label,
    this.trailing,
  });

  final String title;
  final String? label;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final heading = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: KlpSpace.md,
      runSpacing: KlpSpace.xs,
      children: [
        KlpText(title, role: KlpTextRole.section),
        if (label != null)
          KlpText(label!.toUpperCase(), role: KlpTextRole.label),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: heading),
            if (trailing != null) ...[
              const SizedBox(width: KlpSpace.md),
              trailing!,
            ],
          ],
        ),
        const SizedBox(height: KlpSpace.lg),
        child,
      ],
    );
  }
}
