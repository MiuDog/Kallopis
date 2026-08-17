import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpOfflineState extends StatelessWidget {
  const KlpOfflineState({
    super.key,
    required this.onRetry,
    this.detail = '最後同步於 14:28 · 本機變更已安全保存',
  });

  final VoidCallback onRetry;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return _KlpSystemState(
      code: 'CONNECTION / 04',
      icon: KlpIcons.slash,
      title: '目前離線',
      description: '仍可繼續編輯；重新連線後會依序同步本機變更。',
      detail: detail,
      primaryAction: KlpButton(
        label: '重新連線',
        onPressed: onRetry,
        tone: KlpButtonTone.primary,
      ),
    );
  }
}

class KlpConflictState extends StatelessWidget {
  const KlpConflictState({
    super.key,
    required this.onReview,
    required this.onKeepMine,
  });

  final VoidCallback onReview;
  final VoidCallback onKeepMine;

  @override
  Widget build(BuildContext context) {
    return _KlpSystemState(
      code: 'SYNC CONFLICT / 09',
      icon: KlpIcons.switchVertical,
      title: '兩個版本需要確認',
      description: '遠端版本在你編輯期間更新。先檢視差異，再決定要保留的內容。',
      detail: '本機 14:31 · 遠端 14:33 · 3 個區塊不同',
      primaryAction: KlpButton(
        label: '檢視差異',
        onPressed: onReview,
        tone: KlpButtonTone.primary,
      ),
      secondaryAction: KlpButton(
        label: '保留本機版本',
        onPressed: onKeepMine,
        tone: KlpButtonTone.ghost,
      ),
    );
  }
}

class _KlpSystemState extends StatelessWidget {
  const _KlpSystemState({
    required this.code,
    required this.icon,
    required this.title,
    required this.description,
    required this.detail,
    required this.primaryAction,
    this.secondaryAction,
  });

  final String code;
  final String icon;
  final String title;
  final String description;
  final String detail;
  final Widget primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 560;

        return KlpSurface(
          tone: KlpSurfaceTone.base,
          border: false,
          padding: const EdgeInsets.all(KlpSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.surfaceInset,
                      borderRadius: BorderRadius.circular(KlpRadius.card),
                    ),
                    child: KlpIcon(icon, color: tokens.text),
                  ),
                  const SizedBox(width: KlpSpace.md),
                  Expanded(child: KlpText(code, role: KlpTextRole.label)),
                  if (!isCompact)
                    const KlpText(
                      'SYSTEM STATE',
                      role: KlpTextRole.label,
                      tone: KlpTextTone.faint,
                    ),
                ],
              ),
              const SizedBox(height: KlpSpace.xl),
              KlpText(title, role: KlpTextRole.title),
              const SizedBox(height: KlpSpace.sm),
              KlpText(description, tone: KlpTextTone.muted),
              const SizedBox(height: KlpSpace.lg),
              if (isCompact) ...[
                KlpText(
                  detail,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.faint,
                ),
                const SizedBox(height: KlpSpace.md),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: KlpSpace.sm,
                  runSpacing: KlpSpace.sm,
                  children: [?secondaryAction, primaryAction],
                ),
              ] else
                Row(
                  children: [
                    Expanded(
                      child: KlpText(
                        detail,
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.faint,
                      ),
                    ),
                    if (secondaryAction != null) ...[
                      secondaryAction!,
                      const SizedBox(width: KlpSpace.sm),
                    ],
                    primaryAction,
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
