part of '../klp_message_thread.dart';

/// 可載入較早內容的訊息串版面。
class KlpMessageThread extends StatelessWidget {
  const KlpMessageThread({
    super.key,
    required this.messages,
    this.loadOlderLabel,
    this.onLoadOlder,
    this.dense = false,
  });

  final List<Widget> messages;
  final String? loadOlderLabel;
  final VoidCallback? onLoadOlder;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final messageGap = dense
        ? KlpSpaceSize.contentStack
        : KlpSpaceSize.comfortable;

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (loadOlderLabel != null) ...[
          KlpAlign(
            child: KlpButton(
              label: loadOlderLabel!,
              tone: KlpButtonTone.ghost,
              compact: true,
              onPressed: onLoadOlder,
            ),
          ),
          const KlpGap.heightSize(KlpSpaceSize.base),
        ],
        for (var index = 0; index < messages.length; index++) ...[
          messages[index],
          if (index < messages.length - 1) KlpGap.heightSize(messageGap),
        ],
      ],
    );
  }
}
