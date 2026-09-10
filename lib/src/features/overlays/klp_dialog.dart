import 'package:flutter/widgets.dart';

import '../actions/button/klp_button.dart';
import '../../foundation/layout/klp_layout.dart';
import '../../foundation/surface/klp_surface.dart';
import '../../foundation/content/klp_text.dart';
import '../../styling/legacy_theme/klp_theme.dart';

/// 對話框內容。**不負責彈出**——呼叫端自行決定用 `showDialog` 或其他方式呈現。
/// `secondaryLabel` 為必填：庫不替產品決定用什麼語言說「取消」。
class KlpDialog extends StatelessWidget {
	const KlpDialog({
		super.key,
		required this.label,
		required this.title,
		required this.child,
		required this.primaryLabel,
		required this.onPrimary,
		required this.secondaryLabel,
		this.onSecondary,
	});

	final String label;
	final String title;
	final Widget child;
	final String primaryLabel;
	final VoidCallback onPrimary;

	/// 次要動作的文字。**沒有預設值是刻意的**——庫不替產品決定用什麼語言說「取消」。
	final String secondaryLabel;
	final VoidCallback? onSecondary;

	@override
	Widget build(BuildContext context) {
		return KlpConstrainedBox(
			constraints: KlpBoxConstraints(
				maxWidth: context.klp.geometry.layout.dialogMaximumWidth,
			),
			child: KlpSurface(
				tone: KlpSurfaceTone.base,
				radius: context.klp.shape.panel,
				child: KlpColumn(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						KlpBox(
							paddingSize: KlpSpaceSize.comfortable,
							child: KlpColumn(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									KlpText(label.toUpperCase(), role: KlpTextRole.label),
									const KlpBox(heightSize: KlpSpaceSize.overlayHeading),
									KlpText(title, role: KlpTextRole.title),
								],
							),
						),
						KlpBox(
							paddingSize: KlpSpaceSize.comfortable,
							child: child,
						),
						KlpBox(
							paddingSize: KlpSpaceSize.base,
							child: KlpWrap(
								alignment: WrapAlignment.end,
								spacingSize: KlpSpaceSize.action,
								runSpacingSize: KlpSpaceSize.action,
								children: [
									KlpButton(
										label: secondaryLabel,
										onPressed: onSecondary,
										tone: KlpButtonTone.ghost,
									),
									KlpButton(
										label: primaryLabel,
										onPressed: onPrimary,
										tone: KlpButtonTone.primary,
									),
								],
							),
						),
					],
				),
			),
		);
	}
}
