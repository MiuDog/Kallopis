part of '../klp_settings_layout.dart';

/// Settings 右欄的固定標題組合，可單獨用於自訂內容 pane。
class KlpSettingsContentHeader extends StatelessWidget {
  const KlpSettingsContentHeader({
    super.key,
    required this.title,
    this.description,
    this.trailing,
  });

  final String title;
  final String? description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KlpExpanded(child: KlpText(title, role: KlpTextRole.h1)),
            if (trailing != null) ...[KlpBox(width: klp.space.base), trailing!],
          ],
        ),
        if (description != null) ...[
          KlpBox(height: klp.space.tight),
          KlpText(description!, tone: KlpTextTone.muted),
        ],
      ],
    );
  }
}
