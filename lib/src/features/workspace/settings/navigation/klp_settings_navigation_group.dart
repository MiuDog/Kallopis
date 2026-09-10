part of '../klp_settings_navigation.dart';

/// 設定導覽中不可收縮的分類標題與 section 集合。
class KlpSettingsNavigationGroup extends StatelessWidget {
  const KlpSettingsNavigationGroup({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpBox(
          insets: KlpBoxInsets.directional(
            start: klp.space.contentInset,
            top: klp.space.contentInset,
            end: klp.space.contentInset,
            bottom: klp.space.tight,
          ),
          child: KlpText(
            label,
            role: KlpTextRole.label,
            tone: KlpTextTone.faint,
          ),
        ),
        ...children,
      ],
    );
  }
}
