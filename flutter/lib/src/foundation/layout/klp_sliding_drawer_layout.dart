import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

import 'klp_stack.dart';

/// 讓側欄與舞台維持同層，並由受控進度推動舞台的抽屜布局。
class KlpSlidingDrawerLayout extends StatelessWidget {

	const KlpSlidingDrawerLayout({
		super.key,
		required this.progress,
		required this.tracking,
		required this.drawerExtent,
		required this.stage,
		required this.drawer,
	}) : assert(drawerExtent > 0);

	final ValueListenable<double> progress;
	final bool tracking;
	final double drawerExtent;
	final Widget stage;
	final Widget drawer;

	@override
	Widget build(BuildContext context) {
		final duration = tracking ? Duration.zero : context.klp.motion.overlayEnter;

		return AnimatedBuilder(
			animation: progress,
			builder: (context, _) {
				final value = progress.value.clamp(0.0, 1.0);

				return LayoutBuilder(
					builder: (context, constraints) {
						final width = constraints.maxWidth == 0 ? 1.0 : constraints.maxWidth;

						return KlpStack(
							fit: StackFit.expand,
							children: [
								IgnorePointer(
									ignoring: value > 0,
									child: AnimatedSlide(
										offset: Offset(value * drawerExtent / width, 0),
										duration: duration,
										curve: context.klp.motion.standard,
										child: stage,
									),
								),
								AnimatedSlide(
									offset: Offset(value - 1, 0),
									duration: duration,
									curve: context.klp.motion.standard,
									child: SizedBox(width: drawerExtent, child: drawer),
								),
							],
						);
					},
				);
			},
		);
	}
}
