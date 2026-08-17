import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';

enum KlpMessageAuthor { user, agent, system }

class KlpChatBubble extends StatelessWidget {
  const KlpChatBubble({
    super.key,
    required this.author,
    required this.name,
    required this.message,
    required this.timestamp,
  });

  final KlpMessageAuthor author;
  final String name;
  final String message;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    final user = author == KlpMessageAuthor.user;

    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: KlpSurface(
          tone: KlpSurfaceTone.component,
          padding: const EdgeInsets.all(KlpSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: KlpText(name, role: KlpTextRole.label)),
                  KlpText(
                    timestamp,
                    role: KlpTextRole.code,
                    tone: KlpTextTone.faint,
                  ),
                ],
              ),
              const SizedBox(height: KlpSpace.sm),
              KlpText(message),
            ],
          ),
        ),
      ),
    );
  }
}
