part of '../klp_message_composer.dart';

/// 在有限區域內組合可捲動訊息內容與底部 Composer。
class KlpMessageConversation extends StatelessWidget {
  const KlpMessageConversation({
    super.key,
    required this.content,
    required this.composer,
  });

  final Widget content;
  final Widget composer;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return KlpBox(
      insets: KlpBoxInsets.directional(
        start: space.contentInset,
        top: space.contentInset,
        end: space.contentInset,
      ),
      child: KlpLayoutBuilder(
        builder: (context, constraints) {
          return KlpColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KlpExpanded(child: content),
              KlpConstrainedBox(
                constraints: KlpBoxConstraints(
                  maxHeight: constraints.maxHeight,
                ),
                child: KlpBox(
                  insets: KlpBoxInsets.directional(
                    start: space.space0_5,
                    top: space.space0_5,
                    end: space.space0_5,
                    bottom: space.space1,
                  ),
                  child: composer,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
