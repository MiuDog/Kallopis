import 'package:flutter/widgets.dart';

import '../../theme/klp_theme.dart';
import '../panel/klp_panel_frame.dart';

/// 側邊欄：由側邊欄自己決定內容與 footer 的內距，再交給無內距的 PanelFrame
/// 提供背景、圓角與外側 dock margin。
class KlpSidebarFrame extends StatelessWidget {
  const KlpSidebarFrame({
		super.key,
		required this.content,
		this.footer,
		this.padding,
	});

	final Widget content;
	final Widget? footer;
	final EdgeInsetsGeometry? padding;

	@override
	Widget build(BuildContext context) {
		final resolvedPadding = (padding ??
				EdgeInsets.symmetric(horizontal: context.klp.space.chromePanelInset))
			.resolve(Directionality.of(context));
		return KlpPanelFrame(
			footer: footer,
			background: context.klpColors.surface,
			content: Padding(padding: resolvedPadding, child: content),
		);
	}
}
