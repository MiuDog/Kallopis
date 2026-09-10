part of '../klp_message_composer.dart';

class _KlpMessageComposerInlineLayout extends StatelessWidget {
	const _KlpMessageComposerInlineLayout({
		required this.textArea,
		required this.attachLabel,
		required this.sendLabel,
		required this.onAttach,
		required this.onSend,
	});

	final Widget textArea;
	final String attachLabel;
	final String sendLabel;
	final VoidCallback? onAttach;
	final VoidCallback? onSend;

	@override
	Widget build(BuildContext context) {
		return KlpRow(
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				KlpIconButton(
					icon: KlpIcons.folderPlus,
					label: attachLabel,
					onPressed: onAttach,
				),
				const KlpGap.widthSize(KlpSpaceSize.contentInline),
				KlpExpanded(child: textArea),
				const KlpGap.widthSize(KlpSpaceSize.contentInline),
				KlpButton(
					label: sendLabel,
					compact: true,
					onPressed: onSend,
				),
			],
		);
	}
}
