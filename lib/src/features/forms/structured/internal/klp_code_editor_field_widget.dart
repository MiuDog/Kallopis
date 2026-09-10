part of '../klp_code_editor_field.dart';

/// 結構化設定與程式碼編輯器欄位。支援頂部動作列、行內錯誤／警告提示與底部運算式動作列。
class KlpCodeEditorField extends StatelessWidget {
  const KlpCodeEditorField({
    super.key,
    required this.label,
    this.subtitle,
    this.actions,
    required this.code,
    this.error,
    this.warning,
    this.footerLeft,
    this.footerRight,
  });

  final String label;
  final String? subtitle;
  final List<String>? actions;
  final String code;
  final String? error;
  final String? warning;
  final Widget? footerLeft;
  final Widget? footerRight;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KlpRow(
              children: [
                KlpText(label, role: KlpTextRole.caption),
                if (subtitle != null) ...[
                  const KlpGap.widthSize(KlpSpaceSize.contentInline),
                  KlpText(
                    subtitle!,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ],
            ),
            if (actions != null)
              KlpRow(
                children: [
                  for (final action in actions!)
                    KlpBox(
                      marginInsets: KlpBoxInsets.directional(
                        start: klp.space.actionGap,
                      ),
                      child: KlpText(action, role: KlpTextRole.caption),
                    ),
                ],
              ),
          ],
        ),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        KlpStructuredFrame(
          style: KlpStructuredFrameStyle.codeBody(context),
          child: KlpColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KlpText(code, role: KlpTextRole.code),
              if (footerLeft != null || footerRight != null) ...[
                const KlpGap.heightSize(KlpSpaceSize.base),
                KlpStructuredFrame(
                  style: KlpStructuredFrameStyle.codeFooter(context),
                  child: KlpRow(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      footerLeft ?? const KlpBox.shrink(),
                      footerRight ?? const KlpBox.shrink(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (error != null) ...[
          const KlpGap.heightSize(KlpSpaceSize.tight),
          KlpText(error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
        ],
        if (warning != null) ...[
          const KlpGap.heightSize(KlpSpaceSize.tight),
          KlpText(
            warning!,
            role: KlpTextRole.caption,
            color: klp.color.warning,
          ),
        ],
      ],
    );
  }
}
