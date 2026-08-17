import 'package:flutter/widgets.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../typography/pln_text.dart';

class PlnDialog extends StatelessWidget {
  const PlnDialog({
    super.key,
    required this.label,
    required this.title,
    required this.child,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel = '取消',
    this.onSecondary,
  });

  final String label;
  final String title;
  final Widget child;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: PlnSurface(
        tone: PlnSurfaceTone.base,
        radius: PlnRadius.panel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(PlnSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlnText(label.toUpperCase(), role: PlnTextRole.label),
                  const SizedBox(height: PlnSpace.sm),
                  PlnText(title, role: PlnTextRole.title),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(PlnSpace.lg), child: child),
            Padding(
              padding: const EdgeInsets.all(PlnSpace.md),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: PlnSpace.sm,
                runSpacing: PlnSpace.sm,
                children: [
                  PlnButton(
                    label: secondaryLabel,
                    onPressed: onSecondary,
                    tone: PlnButtonTone.ghost,
                  ),
                  PlnButton(
                    label: primaryLabel,
                    onPressed: onPrimary,
                    tone: PlnButtonTone.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
