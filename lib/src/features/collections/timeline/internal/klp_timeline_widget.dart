part of '../klp_timeline.dart';

/// 時間軸：事件依序排列，每項有標記、標題、時間、可選內容。
///
/// 只負責排版與標記／連接線的視覺語言；事件的先後順序、時間格式與內容完全由
/// 呼叫端的 [items] 決定，這裡不做排序也不解讀時間字串。
class KlpTimeline extends StatelessWidget {
	const KlpTimeline({super.key, required this.items});

	final List<KlpTimelineItemData> items;

	@override
	Widget build(BuildContext context) {
		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.start,
			mainAxisSize: MainAxisSize.min,
			children: [
				for (var index = 0; index < items.length; index++)
					_KlpTimelineRow(
						item: items[index],
						isFirst: index == 0,
						isLast: index == items.length - 1,
					),
			],
		);
	}
}
