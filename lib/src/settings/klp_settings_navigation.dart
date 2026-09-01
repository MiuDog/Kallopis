import 'package:flutter/widgets.dart';

import '../controls/klp_control_size.dart';
import '../controls/klp_text_field.dart';
import '../data/klp_list_tile.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../interaction/klp_pressable.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// Settings 頂部 scope 切換器的產品中立資料。
@immutable
class KlpSettingsScopeOption {
  const KlpSettingsScopeOption({required this.label, required this.icon});

  final String label;
  final KlpIconData icon;
}

/// 固定於 Settings 導覽頂部的等寬 scope 切換器。
class KlpSettingsScopeSwitcher extends StatelessWidget {
  const KlpSettingsScopeSwitcher({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  }) : assert(options.length > 1),
       assert(selectedIndex >= 0 && selectedIndex < options.length);

  final List<KlpSettingsScopeOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: KlpSurfaceTone.inset,
      radius: klp.shape.control,
      padding: EdgeInsets.all(klp.space.hairline),
      child: SizedBox(
        height: klp.space.controlHeightXSmall,
        child: Row(
          children: [
            for (var index = 0; index < options.length; index++)
              Expanded(
                child: KlpPressable(
                  key: ValueKey('klp-settings-scope-$index'),
                  onPressed: () => onSelected(index),
                  borderRadius: BorderRadius.circular(klp.shape.controlInner),
                  child: SizedBox.expand(
					child: KlpSurface(
                    tone: index == selectedIndex
                        ? KlpSurfaceTone.raised
                        : KlpSurfaceTone.transparent,
                    radius: klp.shape.controlInner,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        KlpIcon(options[index].icon, size: klp.space.iconSmall),
                        SizedBox(width: klp.space.tight),
                        KlpText(
                          options[index].label,
                          role: KlpTextRole.caption,
                        ),
                      ],
                    ),
					),
				),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Settings 左欄固定區域；組合 identity 與搜尋，但不持有帳號或搜尋狀態。
class KlpSettingsNavigationHeader extends StatelessWidget {
  const KlpSettingsNavigationHeader({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.scopeSwitcher,
    this.search,
    this.onIdentityPressed,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? scopeSwitcher;
  final Widget? search;
  final VoidCallback? onIdentityPressed;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final hasIdentity =
        title != null ||
        leading != null ||
        trailing != null ||
        subtitle != null;
    final identity = Padding(
      padding: EdgeInsets.all(klp.space.tight),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: klp.space.compact),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  KlpText(title!, role: KlpTextRole.bodyStrong),
                if (subtitle != null) ...[
                  SizedBox(height: klp.space.micro),
                  KlpText(
                    subtitle!,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.faint,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: klp.space.tight),
            trailing!,
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (scopeSwitcher != null) ...[
          scopeSwitcher!,
          if (hasIdentity) SizedBox(height: klp.space.tight),
        ],
        if (hasIdentity && onIdentityPressed != null)
          KlpPressable(
            onPressed: onIdentityPressed,
            borderRadius: BorderRadius.circular(klp.shape.control),
            child: identity,
          )
        else if (hasIdentity)
          identity,
        if (search != null) ...[
          SizedBox(
            height: scopeSwitcher != null && !hasIdentity
                ? klp.space.tight
                : klp.space.compact,
          ),
          search!,
        ],
      ],
    );
  }
}

/// Settings 搜尋欄的標準組合；查詢與過濾仍由產品層處理。
class KlpSettingsSearchField extends StatelessWidget {
  const KlpSettingsSearchField({
    super.key,
    required this.placeholder,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return KlpTextField(
      controller: controller,
      placeholder: placeholder,
      leadingIcon: KlpIcons.search,
      size: KlpControlSize.sm,
		outlined: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

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
