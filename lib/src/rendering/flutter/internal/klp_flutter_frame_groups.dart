import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';

import '../klp_flutter_renderer.dart';
import 'klp_flutter_values.dart';

/// 封閉呈現 Frame 內容群組；Frame 本身仍不擁有 padding。
final class KlpFlutterFrameGroups extends StatelessWidget {

	final KlpBoundFrameGroups content;

	const KlpFlutterFrameGroups({required this.content, super.key});

	@override
	Widget build(BuildContext context) {
		if (content.hasFooter) {
			return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
			Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final child in content.children.take(content.children.length - 1)) KlpFlutterRenderer(content: child)]))),
			Center(child: IntrinsicWidth(child: KlpFlutterRenderer(content: content.children.last))),
			]);
		}
		final expandsContent = content.children.length == 1 && _containsExpandingContent(content.children.single);
		return Column(
			mainAxisSize: expandsContent ? MainAxisSize.max : MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [for (final child in content.children) expandsContent ? Expanded(child: KlpFlutterRenderer(content: child)) : KlpFlutterRenderer(content: child)],
		);
	}

	bool _containsExpandingContent(KlpBoundTemplate value) => switch (value) {
		KlpBoundPlacement(:final content) => _containsExpandingContent(content),
		KlpBoundFrameGroup(:final children) => children.length == 1 && _isExpandingContent(children.single),
		_ => false,
	};

	bool _isExpandingContent(KlpBoundTemplate value) => switch (value) {
		KlpBoundPlacement(:final content) => _isExpandingContent(content),
		KlpBoundWorkspaceBlock(:final kind) => kind == 2,
		KlpBoundBlockNoteEditing() || KlpBoundCanvaEditing() => true,
		_ => false,
	};
}

/// 封閉呈現單一群組的前置分隔線與水平內容內距。
final class KlpFlutterFrameGroup extends StatelessWidget {

	final KlpBoundFrameGroup content;

	const KlpFlutterFrameGroup({required this.content, super.key});

	@override
	Widget build(BuildContext context) {
		final expandsContent = content.children.length == 1 && _isExpandingContent(content.children.single);
		final body = Padding(
			padding: EdgeInsets.symmetric(horizontal: content.horizontalInset.value),
			child: Column(
				mainAxisSize: expandsContent ? MainAxisSize.max : MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [for (final (index, child) in content.children.indexed) ...[if (index > 0 && content.contentGap.value > 0) SizedBox(height: content.contentGap.value), expandsContent ? Expanded(child: KlpFlutterRenderer(content: child)) : KlpFlutterRenderer(content: child)]],
			),
		);
		final children = <Widget>[
			if (content.divider >= 3 || content.divider == 1) SizedBox(height: content.groupGap.value),
			if (content.divider != 0) _FrameGroupDivider(content: content),
			if (content.divider == 1) SizedBox(height: content.groupGap.value),
			expandsContent ? Expanded(child: body) : body,
		];

		return Column(mainAxisSize: expandsContent ? MainAxisSize.max : MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
	}

	bool _isExpandingContent(KlpBoundTemplate value) => switch (value) {
		KlpBoundPlacement(:final content) => _isExpandingContent(content),
		KlpBoundWorkspaceBlock(:final kind) => kind == 2,
		KlpBoundBlockNoteEditing() || KlpBoundCanvaEditing() => true,
		_ => false,
	};
}

final class _FrameGroupDivider extends StatelessWidget {

	final KlpBoundFrameGroup content;

	const _FrameGroupDivider({required this.content});

	@override
	Widget build(BuildContext context) {
		if (content.divider >= 3) return const SizedBox.shrink();
		final color = klpFlutterColor(content.dividerColor);
		final stroke = content.dividerStroke.value;
		if (content.divider == 2) return ExcludeSemantics(child: SizedBox(height: stroke, child: ColoredBox(color: color)));

		return ExcludeSemantics(child: SizedBox(height: stroke, child: CustomPaint(painter: _DashedDividerPainter(color, stroke))));
	}
}

final class _DashedDividerPainter extends CustomPainter {

	final Color color;
	final double stroke;

	const _DashedDividerPainter(this.color, this.stroke);

	@override
	void paint(Canvas canvas, Size size) {
		final paint = Paint()..color = color..strokeWidth = stroke;
		final dash = stroke * 3;
		final gap = stroke * 2;
		for (var start = 0.0; start < size.width; start += dash + gap) {
			final end = (start + dash).clamp(0.0, size.width).toDouble();
			canvas.drawLine(Offset(start, stroke / 2), Offset(end, stroke / 2), paint);
		}
	}

	@override
	bool shouldRepaint(_DashedDividerPainter oldDelegate) => oldDelegate.color != color || oldDelegate.stroke != stroke;
}
