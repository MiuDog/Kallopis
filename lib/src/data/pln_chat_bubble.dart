import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../typography/pln_text.dart';

enum PlnMessageAuthor { user, agent, system }

class PlnChatBubble extends StatelessWidget {
  const PlnChatBubble({
    super.key,
    required this.author,
    required this.name,
    required this.message,
    required this.timestamp,
  });

  final PlnMessageAuthor author;
  final String name;
  final String message;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    final user = author == PlnMessageAuthor.user;

    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: PlnSurface(
          tone: PlnSurfaceTone.component,
          padding: const EdgeInsets.all(PlnSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: PlnText(name, role: PlnTextRole.label)),
                  PlnText(
                    timestamp,
                    role: PlnTextRole.code,
                    tone: PlnTextTone.faint,
                  ),
                ],
              ),
              const SizedBox(height: PlnSpace.sm),
              PlnText(message),
            ],
          ),
        ),
      ),
    );
  }
}
