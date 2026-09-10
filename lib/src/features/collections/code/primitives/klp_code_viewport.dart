part of '../klp_code_viewer.dart';

class _KlpCodeViewport extends StatelessWidget {
	const _KlpCodeViewport({
		required this.kind,
		required this.style,
		required this.child,
		this.limit,
		this.collapsed = false,
	});

	final _KlpCodeViewportKind kind;
	final _KlpCodeStyle style;
	final Widget child;
	final KlpCodeViewportLimit? limit;
	final bool collapsed;

	@override
	Widget build(BuildContext context) {
		if (kind == _KlpCodeViewportKind.horizontal) {
			return SingleChildScrollView(
				scrollDirection: Axis.horizontal,
				child: child,
			);
		}

		final fallback = kind == _KlpCodeViewportKind.viewer
				? style.maximumHeight
				: double.infinity;
		final maxHeight = collapsed
				? style.collapsedHeight
				: limit?._height ?? fallback;
		final padding = switch (kind) {
			_KlpCodeViewportKind.viewer => EdgeInsets.symmetric(
				horizontal: style.bodyPaddingX,
				vertical: style.bodyPaddingY,
			),
			_KlpCodeViewportKind.diff => EdgeInsets.symmetric(
				vertical: style.bodyPaddingY,
			),
			_KlpCodeViewportKind.terminal => EdgeInsets.all(style.bodyPaddingX),
			_KlpCodeViewportKind.horizontal => EdgeInsets.zero,
		};

		return ConstrainedBox(
			constraints: BoxConstraints(maxHeight: maxHeight),
			child: SingleChildScrollView(padding: padding, child: child),
		);
	}
}
