import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_feedback_tone.dart';

class KlpInlineNotice extends StatelessWidget {
	const KlpInlineNotice({
		super.key,
		required this.title,
		this.message,
		this.tone = KlpFeedbackTone.info,
		this.action,
	});

	final String title;
	final String? message;
	final KlpFeedbackTone tone;
	final Widget? action;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final toneColor = tone.color(tokens);
		final iconSize = KlpTextStyles.definitionOf(KlpTextRole.body, context.klp.type).fontSize;

		return LayoutBuilder(
			builder: (context, constraints) {
				final isCompact = constraints.maxWidth < context.klp.geometry.layout.inlineNoticeBreakpoint;
				final content = Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							key: const ValueKey('pln-inline-notice-header'),
							crossAxisAlignment: CrossAxisAlignment.baseline,
							textBaseline: TextBaseline.alphabetic,
							children: [
								KlpIcon(tone.icon, size: iconSize, color: toneColor),
								SizedBox(width: context.klp.space.compact),
								KlpText(tone.label, role: KlpTextRole.label, tone: KlpTextTone.muted),
								SizedBox(width: context.klp.space.compact),
								Flexible(child: KlpText(title, role: KlpTextRole.body)),
							],
						),
						if (message != null) ...[
							SizedBox(height: context.klp.space.tight),
							KlpText(message!, role: KlpTextRole.body, tone: KlpTextTone.muted),
						],
					],
				);
				late final Widget layout;
				if (isCompact && action != null) {
					layout = Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							content,
							SizedBox(height: context.klp.space.base),
							Align(alignment: Alignment.centerRight, child: action),
						],
					);
				}
				else {
					layout = Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(child: content),
							if (action != null) ...[
								SizedBox(width: context.klp.space.base),
								action!,
							],
						],
					);
				}

				return KlpSurface(
					tone: KlpSurfaceTone.component,
					radius: context.klp.shape.control,
					padding: EdgeInsets.all(context.klp.space.base),
					child: layout,
				);
			},
		);
	}
}
