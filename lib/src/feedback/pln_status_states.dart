import 'package:flutter/widgets.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnOfflineState extends StatelessWidget {
  const PlnOfflineState({
    super.key,
    required this.onRetry,
    this.detail = '最後同步於 14:28 · 本機變更已安全保存',
  });

  final VoidCallback onRetry;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return _PlnSystemState(
      code: 'CONNECTION / 04',
      icon: PlnIcons.slash,
      title: '目前離線',
      description: '仍可繼續編輯；重新連線後，Planist 會依序同步本機變更。',
      detail: detail,
      primaryAction: PlnButton(
        label: '重新連線',
        onPressed: onRetry,
        tone: PlnButtonTone.primary,
      ),
    );
  }
}

class PlnConflictState extends StatelessWidget {
  const PlnConflictState({
    super.key,
    required this.onReview,
    required this.onKeepMine,
  });

  final VoidCallback onReview;
  final VoidCallback onKeepMine;

  @override
  Widget build(BuildContext context) {
    return _PlnSystemState(
      code: 'SYNC CONFLICT / 09',
      icon: PlnIcons.switchVertical,
      title: '兩個版本需要確認',
      description: '遠端版本在你編輯期間更新。先檢視差異，再決定要保留的內容。',
      detail: '本機 14:31 · 遠端 14:33 · 3 個區塊不同',
      primaryAction: PlnButton(
        label: '檢視差異',
        onPressed: onReview,
        tone: PlnButtonTone.primary,
      ),
      secondaryAction: PlnButton(
        label: '保留本機版本',
        onPressed: onKeepMine,
        tone: PlnButtonTone.ghost,
      ),
    );
  }
}

class _PlnSystemState extends StatelessWidget {
  const _PlnSystemState({
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

        return PlnSurface(
          tone: PlnSurfaceTone.base,
          border: false,
          padding: const EdgeInsets.all(PlnSpace.xl),
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
                      borderRadius: BorderRadius.circular(PlnRadius.card),
                    ),
                    child: PlnIcon(icon, color: tokens.text),
                  ),
                  const SizedBox(width: PlnSpace.md),
                  Expanded(child: PlnText(code, role: PlnTextRole.label)),
                  if (!isCompact)
                    const PlnText(
                      'SYSTEM STATE',
                      role: PlnTextRole.label,
                      tone: PlnTextTone.faint,
                    ),
                ],
              ),
              const SizedBox(height: PlnSpace.xl),
              PlnText(title, role: PlnTextRole.title),
              const SizedBox(height: PlnSpace.sm),
              PlnText(description, tone: PlnTextTone.muted),
              const SizedBox(height: PlnSpace.lg),
              if (isCompact) ...[
                PlnText(
                  detail,
                  role: PlnTextRole.caption,
                  tone: PlnTextTone.faint,
                ),
                const SizedBox(height: PlnSpace.md),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: PlnSpace.sm,
                  runSpacing: PlnSpace.sm,
                  children: [?secondaryAction, primaryAction],
                ),
              ] else
                Row(
                  children: [
                    Expanded(
                      child: PlnText(
                        detail,
                        role: PlnTextRole.caption,
                        tone: PlnTextTone.faint,
                      ),
                    ),
                    if (secondaryAction != null) ...[
                      secondaryAction!,
                      const SizedBox(width: PlnSpace.sm),
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
