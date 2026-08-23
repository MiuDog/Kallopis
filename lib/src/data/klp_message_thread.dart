import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 訊息作者、時間與內容的通用呈現單元。
class KlpMessageBubble extends StatelessWidget {
  const KlpMessageBubble({
    super.key,
    required this.author,
    required this.timestamp,
    required this.child,
    this.emphasized = false,
  });

  final String author;
  final String timestamp;
  final Widget child;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;
    final content = Padding(
      padding: emphasized ? EdgeInsets.all(space.base) : EdgeInsets.zero,
      child: child,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            KlpText(author, role: KlpTextRole.code),
            SizedBox(width: space.compact),
            KlpText(timestamp, role: KlpTextRole.code, tone: KlpTextTone.faint),
          ],
        ),
        SizedBox(height: space.compact),
        if (emphasized)
          KlpSurface(tone: KlpSurfaceTone.component, child: content)
        else
          content,
      ],
    );
  }
}

/// 可載入較早內容的訊息串版面。
class KlpMessageThread extends StatelessWidget {
  const KlpMessageThread({
    super.key,
    required this.messages,
    this.loadOlderLabel,
    this.onLoadOlder,
  });

  final List<Widget> messages;
  final String? loadOlderLabel;
  final VoidCallback? onLoadOlder;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (loadOlderLabel != null) ...[
          Align(
            child: KlpButton(
              label: loadOlderLabel!,
              tone: KlpButtonTone.ghost,
              compact: true,
              onPressed: onLoadOlder,
            ),
          ),
          SizedBox(height: space.base),
        ],
        for (var index = 0; index < messages.length; index++) ...[
          messages[index],
          if (index < messages.length - 1) SizedBox(height: space.comfortable),
        ],
      ],
    );
  }
}
