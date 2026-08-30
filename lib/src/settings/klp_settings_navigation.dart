import 'package:flutter/widgets.dart';

import '../data/klp_list_tile.dart';
import '../foundation/klp_icon.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            klp.space.compact,
            klp.space.compact,
            klp.space.compact,
            klp.space.tight,
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

/// 設定 section 導覽列；只有選取項目會建立其 field deep links。
class KlpSettingsNavigationItem extends StatelessWidget {
  const KlpSettingsNavigationItem({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.trailing,
    this.selected = false,
    this.children = const [],
  });

  final String title;
  final KlpIconData? icon;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpListTile(
          title: title,
          icon: icon,
          trailing: trailing,
          selected: selected,
          compact: true,
          onPressed: onPressed,
        ),
        if (selected && children.isNotEmpty)
          KlpSurface(
            key: const ValueKey('klp-settings-field-guide'),
            tone: KlpSurfaceTone.transparent,
            radius: klp.shape.none,
            padding: EdgeInsets.only(left: klp.space.compact),
            border: Border(
              left: BorderSide(
                color: klp.color.divider,
                width: klp.shape.hairline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
      ],
    );
  }
}
