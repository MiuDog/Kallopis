part of '../klp_split_layout.dart';

/// 分割版面內部的固定間距或虛線分隔框架。
class _KlpSplitDividerFrame extends StatelessWidget {
	const _KlpSplitDividerFrame({
		required this.gapSize,
		required this.showDashedDivider,
	});

	final KlpSpaceSize gapSize;
	final bool showDashedDivider;

	@override
	Widget build(BuildContext context) {
		final gap = KlpGap.resolveSpace(context, gapSize);

		if (!showDashedDivider) {
			return SizedBox(width: gap);
		}

		return Padding(
			padding: EdgeInsets.symmetric(horizontal: gap / 2),
			child: const KlpDashedDivider(vertical: true),
		);
	}
}
