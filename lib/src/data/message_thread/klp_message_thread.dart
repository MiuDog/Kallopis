import 'package:flutter/widgets.dart';

import '../../controls/button/klp_button.dart';
import '../../surface/klp_surface.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';

enum KlpMessageAlignment { leading, trailing }

/// 訊息作者、時間與內容的通用呈現單元。
class KlpMessageBubble extends StatelessWidget {
	const KlpMessageBubble({
		super.key,
		required this.author,
		required this.timestamp,
		required this.child,
		this.emphasized = false,
		this.alignment = KlpMessageAlignment.leading,
		this.background,
		this.dense = false,
	});

	final String author;
	final String timestamp;
	final Widget child;
	final bool emphasized;
	final KlpMessageAlignment alignment;
	final bool? background;
	final bool dense;

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final trailing = alignment == KlpMessageAlignment.trailing;
		final effectiveBackground = background ?? emphasized;
		Widget bubble = child;
		if (effectiveBackground) {
			bubble = KlpSurface(
				tone: KlpSurfaceTone.muted,
				padding: EdgeInsets.all(dense ? space.contentInset : space.base),
				child: child,
			);
		}

		return Align(
			alignment: trailing ? Alignment.centerRight : Alignment.centerLeft,
			child: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: trailing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
				children: [
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							KlpText(author, role: KlpTextRole.code),
							SizedBox(width: space.contentInlineGap),
							KlpText(timestamp, role: KlpTextRole.code, tone: KlpTextTone.faint),
						],
					),
					SizedBox(height: space.contentStackGap),
					bubble,
				],
			),
		);
	}
}

/// 可載入較早內容的訊息串版面。
class KlpMessageThread extends StatelessWidget {
	const KlpMessageThread({
		super.key,
		required this.messages,
		this.loadOlderLabel,
		this.onLoadOlder,
		this.dense = false,
	});

	final List<Widget> messages;
	final String? loadOlderLabel;
	final VoidCallback? onLoadOlder;
	final bool dense;

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final messageGap = dense ? space.contentStackGap : space.comfortable;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				if (loadOlderLabel != null) ...[
					Align(
						child: KlpButton(
							label: loadOlderLabel!,
							tone: KlpButtonTone.ghost,
							compact: true,
							onPressed: onLoadOlder,
						),
					),
					SizedBox(height: space.base),
				],
				for (var index = 0; index < messages.length; index++) ...[
					messages[index],
					if (index < messages.length - 1) SizedBox(height: messageGap),
				],
			],
		);
	}
}
