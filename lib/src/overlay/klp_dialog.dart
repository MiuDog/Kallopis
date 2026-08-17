import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';

class KlpDialog extends StatelessWidget {
  const KlpDialog({
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
      child: KlpSurface(
        tone: KlpSurfaceTone.base,
        radius: KlpRadius.panel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(KlpSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KlpText(label.toUpperCase(), role: KlpTextRole.label),
                  const SizedBox(height: KlpSpace.sm),
                  KlpText(title, role: KlpTextRole.title),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(KlpSpace.lg), child: child),
            Padding(
              padding: const EdgeInsets.all(KlpSpace.md),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: KlpSpace.sm,
                runSpacing: KlpSpace.sm,
                children: [
                  KlpButton(
                    label: secondaryLabel,
                    onPressed: onSecondary,
                    tone: KlpButtonTone.ghost,
                  ),
                  KlpButton(
                    label: primaryLabel,
                    onPressed: onPrimary,
                    tone: KlpButtonTone.primary,
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
