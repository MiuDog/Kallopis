import 'package:flutter/widgets.dart';

import '../../foundation/layout/klp_box.dart';

part 'primitives/klp_live_region_frame.dart';

/// 控制重複公告的可及性 live region。
class KlpLiveRegion extends StatelessWidget {
	const KlpLiveRegion({super.key, required this.message, this.child = const KlpBox.shrink()});

	const KlpLiveRegion.fromDescendants({super.key, required this.child}) : message = null;

	final String? message;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return _KlpLiveRegionFrame(message: message, child: child);
	}
}
