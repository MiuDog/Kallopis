part of '../klp_message_composer.dart';

class _KlpMessageComposerStackedLayout extends StatelessWidget {
  const _KlpMessageComposerStackedLayout({
    required this.textArea,
    required this.attachLabel,
    required this.sendLabel,
    required this.onAttach,
    required this.onSend,
  });

  final Widget textArea;
  final String attachLabel;
  final String sendLabel;
  final VoidCallback? onAttach;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        textArea,
        const KlpGap.heightSize(KlpSpaceSize.contentStack),
        KlpRow(
          children: [
            KlpIconButton(
              icon: KlpIcons.folderPlus,
              label: attachLabel,
              onPressed: onAttach,
            ),
            const KlpSpacer(),
            KlpButton(label: sendLabel, compact: true, onPressed: onSend),
          ],
        ),
      ],
    );
  }
}
