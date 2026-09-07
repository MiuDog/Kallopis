import 'package:flutter/widgets.dart';

import '../../controls/button/klp_button.dart';
import '../../controls/button/klp_icon_button.dart';
import '../../data/badge/klp_badge.dart';
import '../../form/klp_form_controls.dart';
import '../../foundation/klp_icons.dart';
import '../../surface/klp_surface.dart';
import '../../theme/klp_theme.dart';

/// 在有限區域內組合可捲動訊息內容與底部 Composer。
class KlpMessageConversation extends StatelessWidget {
	const KlpMessageConversation({super.key, required this.content, required this.composer});

	final Widget content;
	final Widget composer;

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return Padding(
			padding: EdgeInsets.fromLTRB(space.contentInset, space.contentInset, space.contentInset, 0),
			child: LayoutBuilder(
				builder: (context, constraints) {
					return Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							Expanded(child: content),
							ConstrainedBox(
								constraints: BoxConstraints(maxHeight: constraints.maxHeight),
								child: Padding(
									padding: EdgeInsets.fromLTRB(
										space.space0_5,
										space.space0_5,
										space.space0_5,
										space.space1,
									),
									child: composer,
								),
							),
						],
					);
				},
			),
		);
	}
}

/// 帶有範圍標籤、附件動作與提交動作的多行訊息輸入器。
class KlpMessageComposer extends StatelessWidget {
	const KlpMessageComposer({
		super.key,
		required this.placeholder,
		required this.sendLabel,
		required this.attachLabel,
		required this.onSend,
		required this.onAttach,
		this.tags = const [],
		this.value,
		this.onChanged,
		this.dense = false,
		this.inlineActions = false,
		this.outlined = false,
		this.minLines = 1,
		this.maxLines = 5,
	});

	final String placeholder;
	final String sendLabel;
	final String attachLabel;
	final VoidCallback? onSend;
	final VoidCallback? onAttach;
	final List<String> tags;
	final String? value;
	final ValueChanged<String>? onChanged;
	final bool dense;
	final bool inlineActions;
	final bool outlined;
	final int minLines;
	final int? maxLines;

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		final padding = dense ? space.contentInset : space.base;

		return KlpSurface(
			tone: KlpSurfaceTone.muted,
			padding: EdgeInsets.all(padding),
			child: LayoutBuilder(
				builder: (context, constraints) {
					final inputAndActions = inlineActions ? _buildInlineInput(context) : _buildStackedInput(context);
					return Column(
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							if (tags.isNotEmpty) ...[
								Wrap(
									spacing: space.contentInlineGap,
									runSpacing: space.tight,
									children: [for (final tag in tags) KlpBadge(label: tag)],
								),
								SizedBox(height: space.contentStackGap),
							],
							if (constraints.hasBoundedHeight)
								Flexible(child: inputAndActions)
							else
								inputAndActions,
						],
					);
				},
			),
		);
	}

	Widget _buildInlineInput(BuildContext context) {
		final gap = context.klp.space.contentInlineGap;
		return Row(
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				KlpIconButton(icon: KlpIcons.folderPlus, label: attachLabel, onPressed: onAttach),
				SizedBox(width: gap),
				Expanded(child: _buildTextArea()),
				SizedBox(width: gap),
				KlpButton(label: sendLabel, compact: true, onPressed: onSend),
			],
		);
	}

	Widget _buildStackedInput(BuildContext context) {
		final gap = context.klp.space.contentStackGap;
		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				_buildTextArea(),
				SizedBox(height: gap),
				Row(
					children: [
						KlpIconButton(icon: KlpIcons.folderPlus, label: attachLabel, onPressed: onAttach),
						const Spacer(),
						KlpButton(label: sendLabel, compact: true, onPressed: onSend),
					],
				),
			],
		);
	}

	Widget _buildTextArea() {
		return KlpTextArea(
			value: value,
			placeholder: placeholder,
			onChanged: onChanged,
			minLines: minLines,
			maxLines: maxLines,
			unboundedLines: maxLines == null,
			outlined: outlined,
		);
	}
}
