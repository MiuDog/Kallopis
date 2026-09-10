/// Kallopis 專案模組。
library;

import 'package:flutter/material.dart';

import '../../../../foundation/layout/klp_box.dart';
import '../../../../foundation/layout/klp_center.dart';
import '../../../../foundation/layout/klp_fit.dart';
import '../../../../foundation/layout/klp_fit_mode.dart';

/// 以視窗按鈕尺寸包裝消費端圖示，圖形本身維持 App icon 語意尺寸。
class KlpWindowAppIcon extends StatelessWidget {
	const KlpWindowAppIcon({
		super.key,
		required this.controlExtent,
		required this.iconExtent,
		required this.child,
	});

	final double controlExtent;
	final double iconExtent;
	final Widget child;

  @override
	Widget build(BuildContext context) {
		return KlpBox(
			width: controlExtent,
			height: controlExtent,
			child: KlpCenter(
				child: KlpBox(
					width: iconExtent,
					height: iconExtent,
					child: IconTheme.merge(
						data: IconThemeData(size: iconExtent),
						child: KlpFit(mode: KlpFitMode.contain, child: child),
					),
				),
			),
		);
	}
}
