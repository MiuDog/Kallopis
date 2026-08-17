import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../typography/pln_text.dart';

class PlnSection extends StatelessWidget {
  const PlnSection({
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
      spacing: PlnSpace.md,
      runSpacing: PlnSpace.xs,
      children: [
        PlnText(title, role: PlnTextRole.section),
        if (label != null)
          PlnText(label!.toUpperCase(), role: PlnTextRole.label),
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
              const SizedBox(width: PlnSpace.md),
              trailing!,
            ],
          ],
        ),
        const SizedBox(height: PlnSpace.lg),
        child,
      ],
    );
  }
}
