part of '../klp_status_bar.dart';

/// 狀態列單側項目群組。
class _KlpStatusGroup extends StatelessWidget {
	const _KlpStatusGroup({required this.items, this.expanded = false});

	final List<KlpStatusItemData> items;
	final bool expanded;

	@override
	Widget build(BuildContext context) {
		return KlpRow(
			mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
			children: [
				for (var index = 0; index < items.length; index++) ...[
					if (expanded)
						KlpFlexible(
							child: KlpStatusIndicator(
								data: items[index],
								expanded: true,
							),
						)
					else
						KlpStatusIndicator(data: items[index]),
					if (index < items.length - 1)
						const KlpGap.widthSize(KlpSpaceSize.chromeToolbar),
				],
			],
		);
	}
}
