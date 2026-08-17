import 'package:flutter/widgets.dart';

import '../feedback/pln_feedback_tone.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../typography/pln_text.dart';
import 'pln_badge.dart';
import 'pln_progress.dart';

class PlnTaskCard extends StatelessWidget {
  const PlnTaskCard({
    super.key,
    required this.title,
    required this.owner,
    required this.progress,
    this.status = 'RUNNING',
  });

  final String title;
  final String owner;
  final double progress;
  final String status;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: PlnText(title, role: PlnTextRole.bodyStrong)),
              PlnBadge(label: status, tone: PlnFeedbackTone.success, dot: true),
            ],
          ),
          const SizedBox(height: PlnSpace.xs),
          PlnText(owner, role: PlnTextRole.code, tone: PlnTextTone.faint),
          const SizedBox(height: PlnSpace.md),
          PlnProgress(
            value: progress,
            trailing: '${(progress * 100).round()}%',
          ),
        ],
      ),
    );
  }
}
