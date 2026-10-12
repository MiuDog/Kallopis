import 'package:flutter/widgets.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

/// Panel 底列的語意內距；背景與裁切由父 PanelFrame 擁有。
class KlpPanelFooter extends StatelessWidget {
	const KlpPanelFooter({super.key, required this.child, this.padding});

	/// 產品底列內容及可選內距；directional 值依宿主方向解析。
	final Widget child;
	final EdgeInsetsGeometry? padding;

	@override
	Widget build(BuildContext context) {
		final resolved = (padding ?? EdgeInsets.symmetric(
			horizontal: context.klp.space.chromePanelInset,
		)).resolve(Directionality.of(context));
		return LayoutBuilder(builder: (context, constraints) {
			// 同軸兩端以共同倍率縮小，保留非對稱及 RTL 的比例。
			final horizontalScale = constraints.hasBoundedWidth && resolved.horizontal > constraints.maxWidth
					? constraints.maxWidth / resolved.horizontal : 1.0;
			final verticalScale = constraints.hasBoundedHeight && resolved.vertical > constraints.maxHeight
					? constraints.maxHeight / resolved.vertical : 1.0;
			return ClipRect(child: Padding(
				padding: EdgeInsets.fromLTRB(
					resolved.left * horizontalScale,
					resolved.top * verticalScale,
					resolved.right * horizontalScale,
					resolved.bottom * verticalScale,
				),
				child: child,
			));
		});
	}
}
