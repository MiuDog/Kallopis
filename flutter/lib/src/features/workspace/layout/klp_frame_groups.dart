import 'package:flutter/material.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

/// 在 Frame 內排列一個以上內容群組，並可固定一個底部操作群組。
final class KlpFrameGroups extends StatelessWidget {
	KlpFrameGroups({
		super.key,
		required List<KlpFrameGroup> groups,
		this.footer,
		this.scrollController,
	}) : groups = List.unmodifiable(groups) {
		if (groups.isEmpty) throw ArgumentError.value(groups, 'groups', 'KlpFrameGroups requires at least one group.');
	}

	final List<KlpFrameGroup> groups;
	final KlpFrameGroup? footer;
	final ScrollController? scrollController;

	@override
	Widget build(BuildContext context) {
		final mainGroups = Column(
			mainAxisSize: footer == null ? MainAxisSize.min : MainAxisSize.max,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: groups,
		);
		if (footer == null) return mainGroups;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Expanded(
					child: SingleChildScrollView(
						controller: scrollController,
						child: mainGroups,
					),
				),
				Center(child: IntrinsicWidth(child: footer)),
			],
		);
	}
}

/// Frame 中一段內容；水平內距、內容節奏與前置分隔由 [style] 決定。
final class KlpFrameGroup extends StatelessWidget {
	KlpFrameGroup({
		super.key,
		required List<Widget> content,
		this.style = KlpFrameGroupStyle.defaultHorizontal,
	}) : content = List.unmodifiable(content) {
		if (content.isEmpty) throw ArgumentError.value(content, 'content', 'KlpFrameGroup requires at least one content widget.');
	}

	final List<Widget> content;
	final KlpFrameGroupStyle style;

	@override
	Widget build(BuildContext context) {
		final gap = context.klp.space.space2;
		final body = Padding(
			padding: EdgeInsets.symmetric(
				horizontal: style.padding == KlpFrameGroupPadding.standard ? gap : 0,
			),
			child: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: _contentWithSpacing(gap),
			),
		);

		return Column(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				..._divider(context, gap),
				body,
			],
		);
	}

	List<Widget> _contentWithSpacing(double gap) {
		if (style.contentSpacing == KlpFrameGroupContentSpacing.none) return content;
		return [
			for (final (index, child) in content.indexed) ...[
				if (index > 0) SizedBox(height: gap),
				child,
			],
		];
	}

	List<Widget> _divider(BuildContext context, double gap) => switch (style.divider) {
		KlpFrameGroupDivider.invisible => const [],
		KlpFrameGroupDivider.transparentGap || KlpFrameGroupDivider.sectionGap => [SizedBox(height: gap)],
		KlpFrameGroupDivider.solid => [_FrameGroupDivider(dashed: false)],
		KlpFrameGroupDivider.dashed => [
			SizedBox(height: gap),
			const _FrameGroupDivider(dashed: true),
			SizedBox(height: gap),
		],
	};
}

/// Frame 中用來建立功能分群與水平內距的公開元件。
typedef KlpPadding = KlpFrameGroup;

/// 群組內容可使用的水平內距。
enum KlpFrameGroupPadding { none, standard }

/// [KlpPadding] 可選用的水平內距樣式。
typedef KlpPaddingHorizontal = KlpFrameGroupPadding;

/// 群組前的分隔方式。
enum KlpFrameGroupDivider { invisible, dashed, solid, transparentGap, sectionGap }

/// 群組內容之間的標準或無間距選項。
enum KlpFrameGroupContentSpacing { none, standard }

/// [KlpPadding] 在群組前可選用的分隔線樣式。
typedef KlpPaddingDivider = KlpFrameGroupDivider;

/// Frame 內容群組的封閉樣式；不接受原始色彩、距離或 Flutter padding。
final class KlpFrameGroupStyle {
	const KlpFrameGroupStyle({
		this.padding = KlpFrameGroupPadding.standard,
		this.divider = KlpFrameGroupDivider.invisible,
		this.contentSpacing = KlpFrameGroupContentSpacing.none,
	});

	static const defaultHorizontal = KlpFrameGroupStyle();
	static const noHorizontalPadding = KlpFrameGroupStyle(padding: KlpFrameGroupPadding.none);

	final KlpFrameGroupPadding padding;
	final KlpFrameGroupDivider divider;
	final KlpFrameGroupContentSpacing contentSpacing;

	KlpFrameGroupStyle copyWith({
		KlpFrameGroupPadding? padding,
		KlpFrameGroupDivider? divider,
		KlpFrameGroupContentSpacing? contentSpacing,
	}) => KlpFrameGroupStyle(
		padding: padding ?? this.padding,
		divider: divider ?? this.divider,
		contentSpacing: contentSpacing ?? this.contentSpacing,
	);
}

/// [KlpPadding] 的封閉樣式；不開放原始 padding 或分隔線色彩。
typedef KlpPaddingStyle = KlpFrameGroupStyle;

final class _FrameGroupDivider extends StatelessWidget {
	const _FrameGroupDivider({required this.dashed});

	final bool dashed;

	@override
	Widget build(BuildContext context) {
		final shape = context.klp.shape;
		final stroke = shape.hairline;
		return ExcludeSemantics(
			child: SizedBox(
				height: stroke,
				child: dashed
					? CustomPaint(
						painter: _DashedDividerPainter(
							color: context.klpColors.divider,
							stroke: stroke,
							dashLength: shape.dashedLength,
							gapLength: shape.dashedGap,
						),
					)
					: ColoredBox(color: context.klpColors.divider),
			),
		);
	}
}

final class _DashedDividerPainter extends CustomPainter {
	const _DashedDividerPainter({
		required this.color,
		required this.stroke,
		required this.dashLength,
		required this.gapLength,
	});

	final Color color;
	final double stroke;
	final double dashLength;
	final double gapLength;

	@override
	void paint(Canvas canvas, Size size) {
		final paint = Paint()
			..color = color
			..strokeWidth = stroke;
		for (var start = 0.0; start < size.width; start += dashLength + gapLength) {
			final end = (start + dashLength).clamp(0.0, size.width).toDouble();
			canvas.drawLine(Offset(start, stroke / 2), Offset(end, stroke / 2), paint);
		}
	}

	@override
	bool shouldRepaint(covariant _DashedDividerPainter oldDelegate) =>
		oldDelegate.color != color ||
		oldDelegate.stroke != stroke ||
		oldDelegate.dashLength != dashLength ||
		oldDelegate.gapLength != gapLength;
}
