part of '../klp_status_role_swatches.dart';

/// 狀態角色的固定色票 primitive。
class _KlpStatusRoleSwatchFrame extends StatelessWidget {
	const _KlpStatusRoleSwatchFrame({required this.role});

	final KlpStatusRole role;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final color = switch (role) {
			KlpStatusRole.success => klp.color.success,
			KlpStatusRole.danger => klp.color.danger,
			KlpStatusRole.warning => klp.color.warning,
			KlpStatusRole.info => klp.color.info,
		};

		return Container(
			width: klp.geometry.control.swatchExtent,
			height: klp.geometry.control.swatchExtent,
			decoration: BoxDecoration(
				color: color,
				borderRadius: BorderRadius.circular(klp.shape.control / 2),
			),
		);
	}
}
