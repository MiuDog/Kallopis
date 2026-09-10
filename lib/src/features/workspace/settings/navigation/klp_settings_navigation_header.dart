part of '../klp_settings_navigation.dart';

/// Settings 左欄固定區域，組合 identity 與搜尋。
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
				title != null || leading != null || trailing != null || subtitle != null;
		final identity = KlpBox(
			insets: KlpBoxInsets.uniform(klp.space.tight),
			child: KlpRow(
				children: [
					if (leading != null) ...[
						leading!,
						KlpBox(width: klp.space.contentInlineGap),
					],
					KlpExpanded(
						child: KlpColumn(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								if (title != null)
									KlpText(title!, role: KlpTextRole.bodyStrong),
								if (subtitle != null) ...[
									KlpBox(height: klp.space.micro),
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
						KlpBox(width: klp.space.tight),
						trailing!,
					],
				],
			),
		);

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				if (scopeSwitcher != null) ...[
					scopeSwitcher!,
					if (hasIdentity) KlpBox(height: klp.space.tight),
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
					KlpBox(
						height: scopeSwitcher != null && !hasIdentity
								? klp.space.tight
								: klp.space.contentStackGap,
					),
					search!,
				],
			],
		);
	}
}
