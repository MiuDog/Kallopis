import '../internal/klp_form_dependencies.dart';

/// 狀態色彩角色色票組（Roles only）。只提供語意角色選擇，不提供直接色碼選擇。
class KlpStatusRoleSwatches extends StatelessWidget {
	const KlpStatusRoleSwatches({
		super.key,
		required this.label,
		this.helper,
		this.selectedRole,
		this.onSelectRole,
	});

	final String label;
	final String? helper;
	final String? selectedRole;
	final ValueChanged<String>? onSelectRole;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final klp = context.klp;

		final roles = [
			('SUCCESS', tokens.success),
			('DANGER', tokens.danger),
			('WARNING', tokens.warning),
			('INFO', tokens.info),
		];

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				if (helper != null) ...[
					SizedBox(height: klp.space.tight),
					KlpText(helper!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
				],
				SizedBox(height: klp.space.tight),
				Wrap(
					spacing: klp.space.base,
					runSpacing: klp.space.contentStackGap,
					children: [
						for (final (name, color) in roles)
							GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: onSelectRole == null ? null : () => onSelectRole!(name),
								child: Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										Container(
											width: klp.geometry.control.swatchExtent,
											height: klp.geometry.control.swatchExtent,
											decoration: BoxDecoration(
												color: color,
												borderRadius: BorderRadius.circular(
													klp.shape.control / 2,
												),
											),
										),
										SizedBox(width: klp.space.tight),
										KlpText(
											name,
											role: KlpTextRole.code,
											tone: selectedRole == name
													? KlpTextTone.primary
													: KlpTextTone.muted,
										),
									],
								),
							),
					],
				),
			],
		);
	}
}
