import 'package:flutter/material.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/styling/presets/klp_frame_relief_recipe.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

/// App background 上第一層的通用 Workbench 布局根。
final class KlpAppLayout extends StatelessWidget {
	const KlpAppLayout({super.key, required this.child});

	final KlpLayoutNode child;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.all(context.klp.space.space2),
			child: child,
		);
	}
}

/// 可置於 [KlpAppLayout]、[LayoutRow] 或 [LayoutColumn] 的封閉布局節點。
abstract class KlpLayoutNode extends StatelessWidget {
	const KlpLayoutNode({super.key});

	int get flex;
}

/// 水平布局的主軸對齊選項。
enum KlpLayoutMainAlignment { start, end }

/// 線性布局的標準或無間距選項。
enum KlpLayoutSpacing { standard, none }

/// 在主軸上水平排列受控布局節點。
final class LayoutRow extends KlpLayoutNode {
	LayoutRow({
		super.key,
		required List<KlpLayoutNode> children,
		this.flex = 1,
		this.alignment = KlpLayoutMainAlignment.start,
		this.spacing = KlpLayoutSpacing.standard,
	}) : children = List.unmodifiable(children) {
		if (children.isEmpty) throw ArgumentError.value(children, 'children', 'LayoutRow requires at least one child.');
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	final List<KlpLayoutNode> children;

	@override
	final int flex;
	final KlpLayoutMainAlignment alignment;
	final KlpLayoutSpacing spacing;

	@override
	Widget build(BuildContext context) {
		final row = Row(
			mainAxisAlignment: alignment == KlpLayoutMainAlignment.end ? MainAxisAlignment.end : MainAxisAlignment.start,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: _linearChildren(context, Axis.horizontal, children, spacing),
		);
		return flex == 0 ? IntrinsicHeight(child: row) : row;
	}
}

/// 在主軸上垂直排列受控布局節點。
final class LayoutColumn extends KlpLayoutNode {
	LayoutColumn({
		super.key,
		required List<KlpLayoutNode> children,
		this.flex = 1,
		this.spacing = KlpLayoutSpacing.standard,
	}) : children = List.unmodifiable(children) {
		if (children.isEmpty) throw ArgumentError.value(children, 'children', 'LayoutColumn requires at least one child.');
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	final List<KlpLayoutNode> children;

	@override
	final int flex;
	final KlpLayoutSpacing spacing;

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: _linearChildren(context, Axis.vertical, children, spacing),
		);
	}
}

/// 取代相鄰 node 自動 gutter 的固定尺寸槽；不提供 resize 手勢。
final class LayoutResizeHandle extends KlpLayoutNode {
	const LayoutResizeHandle({super.key});

	@override
	int get flex => 0;

	@override
	Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 線性布局中不承載內容的彈性空間。
final class LayoutSpacer extends KlpLayoutNode {
	const LayoutSpacer({super.key, this.flex = 1}) : assert(flex > 0);

	@override
	final int flex;

	@override
	Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 布局 pane 的尺寸角色。
enum KlpLayoutPaneSize { trailing, content, expand }

/// 不帶材質的受控布局 pane。
final class KlpLayoutPane extends KlpLayoutNode {
	KlpLayoutPane({
		super.key,
		required this.child,
		this.size = KlpLayoutPaneSize.trailing,
		int? flex,
	}) : flex = flex ?? (size == KlpLayoutPaneSize.expand ? 1 : 0) {
		if (this.flex < 0) throw ArgumentError.value(this.flex, 'flex', 'Layout flex must not be negative.');
	}

	final Widget child;
	final KlpLayoutPaneSize size;

	@override
	final int flex;

	@override
	Widget build(BuildContext context) {
		if (size != KlpLayoutPaneSize.trailing) return child;
		return SizedBox(width: context.klp.geometry.layout.secondaryPaneWidth, child: child);
	}
}

/// Frame 的內容主次角色，不綁定左右位置。
enum KlpAppFrameRole { content, auxiliary, sidebar, rightSidebar, toolbarControls }

/// Frame 表面選項。
enum KlpAppFrameSurface { flat, raised }

/// App background 第一層具名 frame；內容內距由 child 自己決定。
final class KlpAppFrame extends KlpLayoutNode {
	KlpAppFrame({
		super.key,
		required this.child,
		this.flex = 1,
		this.role = KlpAppFrameRole.content,
		this.surface = KlpAppFrameSurface.flat,
	}) {
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	final Widget child;

	@override
	final int flex;
	final KlpAppFrameRole role;
	final KlpAppFrameSurface surface;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		final bare = role == KlpAppFrameRole.rightSidebar || role == KlpAppFrameRole.toolbarControls;
		final background = role == KlpAppFrameRole.auxiliary || role == KlpAppFrameRole.sidebar ? tokens.surfaceInset : tokens.surface;
		Widget frame = child;

		if (!bare) {
			final radius = BorderRadius.circular(klp.shape.panel);
			final shadows = surface == KlpAppFrameSurface.raised ? _frameRelief(background, klp.surface.overlayShadowColor, klp.space.space1) : null;
			frame = DecoratedBox(
				decoration: BoxDecoration(color: background, borderRadius: radius, boxShadow: shadows),
				child: ClipRRect(
					borderRadius: radius,
					child: KlpTokenOverride(colors: tokens.onBackground(background), child: child),
				),
			);
		}

		final width = switch (role) {
			KlpAppFrameRole.sidebar => klp.geometry.layout.primaryPaneWidth,
			KlpAppFrameRole.rightSidebar => klp.geometry.layout.secondaryPaneWidth,
			KlpAppFrameRole.toolbarControls => klp.space.space8 * 3 + klp.space.space1 * 6,
			_ => null,
		};
		return width == null ? frame : SizedBox(width: width, child: frame);
	}
}

List<Widget> _linearChildren(BuildContext context, Axis axis, List<KlpLayoutNode> nodes, KlpLayoutSpacing spacing) {
	final gap = context.klp.space.space2;
	final children = <Widget>[];
	var previousWasHandle = false;

	// 顯式 handle 自己占據 gutter，前後都不再加入普通間距。
	for (final node in nodes) {
		final isHandle = node is LayoutResizeHandle;
		if (spacing == KlpLayoutSpacing.standard && children.isNotEmpty && !previousWasHandle && !isHandle) {
			children.add(axis == Axis.horizontal ? SizedBox(width: gap) : SizedBox(height: gap));
		}

		if (isHandle) {
			children.add(axis == Axis.horizontal ? SizedBox(width: gap, child: node) : SizedBox(height: gap, child: node));
		}
		else if (node.flex > 0) {
			children.add(Expanded(flex: node.flex, child: node));
		}
		else {
			children.add(node);
		}
		previousWasHandle = isHandle;
	}

	return children;
}

List<BoxShadow> _frameRelief(Color surface, Color shadowSource, double scale) {
	KlpColor channels(Color color) => KlpColor((color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round());
	Color flutterColor(KlpColor color) => Color.fromARGB(color.alpha, color.red, color.green, color.blue);
	final base = channels(surface);
	final factor = KlpFrameReliefRecipe.factor(scale);
	return [
		BoxShadow(
			color: flutterColor(KlpFrameReliefRecipe.shadow(base, channels(shadowSource))),
			offset: Offset(KlpFrameReliefRecipe.offsetX * factor, KlpFrameReliefRecipe.offsetY * factor),
			blurRadius: KlpFrameReliefRecipe.blur * factor,
			spreadRadius: KlpFrameReliefRecipe.spread * factor,
		),
		BoxShadow(
			color: flutterColor(KlpFrameReliefRecipe.highlight(base)),
			offset: Offset(KlpFrameReliefRecipe.highlightOffset * factor, KlpFrameReliefRecipe.highlightOffset * factor),
		),
	];
}
