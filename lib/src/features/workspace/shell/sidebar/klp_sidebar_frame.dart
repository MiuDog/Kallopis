import 'package:flutter/widgets.dart';

import '../../../../foundation/layout/klp_box.dart';
import '../panel/klp_panel_frame.dart';
import 'klp_sidebar_inset.dart';

export 'klp_sidebar_inset.dart';

/// 側邊欄：由側邊欄自己決定內容與 footer 的內距，再交給無內距的 PanelFrame
/// 提供背景、圓角與外側 dock margin。
class KlpSidebarFrame extends StatelessWidget {
	const KlpSidebarFrame({
		super.key,
		required this.content,
		this.footer,
		this.inset = KlpSidebarInset.chromePanel,
	});

	final Widget content;
	final Widget? footer;
	final KlpSidebarInset inset;

	@override
	Widget build(BuildContext context) {
		return KlpPanelFrame(
			footer: footer,
			content: KlpBox(insets: inset.resolve(context), child: content),
		);
	}
}
