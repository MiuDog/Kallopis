import 'package:flutter/widgets.dart';

import '../../../feedback/workflow/klp_finite_workflow.dart';
import '../../../../foundation/interaction/primitives/klp_pointer_blocker.dart';
import '../../../../foundation/layout/klp_positioned.dart';
import '../../../../foundation/layout/klp_stack.dart';

/// 長時間操作期間保持預覽內容穩定，並在其上呈現呼叫端提供的具名階段。
class KlpPublicationProgressOverlay extends StatelessWidget {
	const KlpPublicationProgressOverlay({
		super.key,
		required this.child,
		required this.visible,
		required this.progress,
	});

	final Widget child;
	final bool visible;
	final KlpWorkflowProgress progress;

	@override
	Widget build(BuildContext context) => KlpStack(
		children: [
			KlpPointerBlocker(blocking: visible, child: child),
			if (visible) KlpPositioned.fill(child: progress),
		],
	);
}
