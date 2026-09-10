part of '../klp_message_composer.dart';

/// 帶有範圍標籤、附件動作與提交動作的多行訊息輸入器。
class KlpMessageComposer extends StatelessWidget {
  const KlpMessageComposer({
    super.key,
    required this.placeholder,
    required this.sendLabel,
    required this.attachLabel,
    required this.onSend,
    required this.onAttach,
    this.tags = const [],
    this.value,
    this.onChanged,
    this.dense = false,
    this.inlineActions = false,
    this.outlined = false,
    this.minLines = 1,
    this.maxLines = 5,
  });

  final String placeholder;
  final String sendLabel;
  final String attachLabel;
  final VoidCallback? onSend;
  final VoidCallback? onAttach;
  final List<String> tags;
  final String? value;
  final ValueChanged<String>? onChanged;
  final bool dense;
  final bool inlineActions;
  final bool outlined;
  final int minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;
    final padding = dense ? space.contentInset : space.base;
    final textArea = KlpTextArea(
      value: value,
      placeholder: placeholder,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      unboundedLines: maxLines == null,
      outlined: outlined,
    );

    return KlpSurface(
      tone: KlpSurfaceTone.muted,
      child: KlpBox(
        insets: KlpBoxInsets.uniform(padding),
        child: KlpLayoutBuilder(
          builder: (context, constraints) {
            final inputAndActions = inlineActions
                ? _KlpMessageComposerInlineLayout(
                    textArea: textArea,
                    attachLabel: attachLabel,
                    sendLabel: sendLabel,
                    onAttach: onAttach,
                    onSend: onSend,
                  )
                : _KlpMessageComposerStackedLayout(
                    textArea: textArea,
                    attachLabel: attachLabel,
                    sendLabel: sendLabel,
                    onAttach: onAttach,
                    onSend: onSend,
                  );

            return KlpColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (tags.isNotEmpty) ...[
                  KlpWrap(
                    spacingSize: KlpSpaceSize.contentInline,
                    runSpacingSize: KlpSpaceSize.tight,
                    children: [for (final tag in tags) KlpBadge(label: tag)],
                  ),
                  const KlpGap.heightSize(KlpSpaceSize.contentStack),
                ],
                if (constraints.hasBoundedHeight)
                  KlpFlexible(child: inputAndActions)
                else
                  inputAndActions,
              ],
            );
          },
        ),
      ),
    );
  }
}
