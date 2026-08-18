import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_icon.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_feedback_tone.dart';

/// 短暫通知。**不負責排程與消失**——停留時間取自 `theme.motion.toastDwell`，
/// 但實際的顯示與收起由呼叫端控制。
class KlpToast extends StatelessWidget {
  const KlpToast({
    super.key,
    required this.title,
    this.message,
    this.tone = KlpFeedbackTone.info,
    this.actionLabel,
    this.onAction,
    this.onClose,
    this.closeLabel,
  }) : assert(
         onClose == null || closeLabel != null,
         '提供 onClose 時必須一併提供 closeLabel——庫不替產品決定用什麼語言說「關閉」。',
       );

  final String title;
  final String? message;
  final KlpFeedbackTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  /// 關閉鈕的文字。有 [onClose] 時必填——庫不替產品決定用什麼語言。
  final String? closeLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final toneColor = tone.color(tokens);

    return Semantics(
      liveRegion: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: EdgeInsets.all(context.klp.space.base),
          decoration: BoxDecoration(
            color: tokens.surfaceInset,
            borderRadius: BorderRadius.circular(context.klp.shape.card),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Center(
                      child: KlpIcon(
                        tone.icon,
                        size: context.klp.space.icon,
                        color: toneColor,
                      ),
                    ),
                  ),
                  SizedBox(width: context.klp.space.compact),
                  Expanded(
                    child: KlpText(
                      tone.label,
                      role: KlpTextRole.label,
                      color: toneColor,
                    ),
                  ),
                  const KlpText(
                    'NOW',
                    role: KlpTextRole.label,
                    tone: KlpTextTone.faint,
                  ),
                ],
              ),
              SizedBox(height: context.klp.space.base),
              KlpText(title, role: KlpTextRole.bodyStrong),
              if (message != null) ...[
                SizedBox(height: context.klp.space.tight),
                KlpText(
                  message!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ],
              if (actionLabel != null || onClose != null) ...[
                SizedBox(height: context.klp.space.base),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: context.klp.space.tight,
                  runSpacing: context.klp.space.tight,
                  children: [
                    if (onClose != null)
                      KlpButton(
                        label: closeLabel!,
                        onPressed: onClose,
                        tone: KlpButtonTone.ghost,
                        compact: true,
                      ),
                    if (actionLabel != null && onAction != null)
                      KlpButton(
                        label: actionLabel!,
                        onPressed: onAction,
                        tone: KlpButtonTone.primary,
                        compact: true,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class KlpToastStack extends StatelessWidget {
  const KlpToastStack({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index < children.length - 1) SizedBox(height: context.klp.space.compact),
        ],
      ],
    );
  }
}
