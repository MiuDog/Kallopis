import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'klp_linear_layout.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/styling/presets/klp_frame_relief_recipe.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/foundation/surface/klp_surface.dart';

part 'internal/klp_linear_render.dart';

/// App background 上第一層的通用 Workbench 布局根。
enum KlpAppLayoutInset {
	/// 套用 App frame 之間的標準外距。
	standard,

	/// 讓單一端點的內容貼齊可用範圍。
	none,
}

final class KlpAppLayout extends StatelessWidget {
	const KlpAppLayout({
		super.key,
		required this.child,
		this.floatingAction,
		this.inset = KlpAppLayoutInset.standard,
	});

	final KlpLayoutNode child;
	final Widget? floatingAction;
	final KlpAppLayoutInset inset;

	@override
	Widget build(BuildContext context) {
		final gap = context.klp.space.space2;
		final body = LayoutBuilder(builder: (context, constraints) {
			final horizontal = constraints.hasBoundedWidth ? math.min(gap, constraints.maxWidth / 2) : gap;
			final vertical = constraints.hasBoundedHeight ? math.min(gap, constraints.maxHeight / 2) : gap;
			return ClipRect(child: Padding(
				padding: inset == KlpAppLayoutInset.none ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
				child: child,
			));
		});
		final action = floatingAction;
		if (action == null) return body;

		return _KlpFloatingWorkspace(action: action, child: body);
	}
}

/// 一般布局節點的主軸尺寸限制；空間不足由共通演算法退化。
final class KlpLayoutBounds {
	const KlpLayoutBounds({this.minimum = 0, this.maximum, this.preferred});

	/// 正常空間下的最小值與可選上限。
	final double minimum;
	final double? maximum;
	/// 未指定時保留正 flex 擴展、零 flex 自然量測語意。
	final double? preferred;
}

/// 可置於 [KlpAppLayout]、[LayoutRow] 或 [LayoutColumn] 的封閉布局節點。
abstract class KlpLayoutNode extends StatelessWidget {
	const KlpLayoutNode({super.key});

	int get flex;
	KlpLayoutBounds get bounds => const KlpLayoutBounds();
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
		this.bounds = const KlpLayoutBounds(),
		this.alignment = KlpLayoutMainAlignment.start,
		this.spacing = KlpLayoutSpacing.standard,
	}) : children = List.unmodifiable(children) {
		if (children.isEmpty) throw ArgumentError.value(children, 'children', 'LayoutRow requires at least one child.');
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	final List<KlpLayoutNode> children;

	@override
	final int flex;
	@override
	final KlpLayoutBounds bounds;
	final KlpLayoutMainAlignment alignment;
	final KlpLayoutSpacing spacing;

	@override
	Widget build(BuildContext context) => _linearLayout(
		context,
		Axis.horizontal,
		children,
		spacing,
		alignment,
	);
}

/// 在主軸上垂直排列受控布局節點。
final class LayoutColumn extends KlpLayoutNode {
	LayoutColumn({
		super.key,
		required List<KlpLayoutNode> children,
		this.flex = 1,
		this.bounds = const KlpLayoutBounds(),
		this.alignment = KlpLayoutMainAlignment.start,
		this.spacing = KlpLayoutSpacing.standard,
	}) : children = List.unmodifiable(children) {
		if (children.isEmpty) throw ArgumentError.value(children, 'children', 'LayoutColumn requires at least one child.');
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	final List<KlpLayoutNode> children;

	@override
	final int flex;
	@override
	final KlpLayoutBounds bounds;
	final KlpLayoutMainAlignment alignment;
	final KlpLayoutSpacing spacing;

	@override
	Widget build(BuildContext context) => _linearLayout(
		context,
		Axis.vertical,
		children,
		spacing,
		alignment,
	);
}

/// 不含拖曳手勢的顯式間距槽。
final class KlpLayoutDivider extends KlpLayoutNode {
	const KlpLayoutDivider({super.key});
	@override
	int get flex => 0;
	@override
	Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 取代相鄰 node 自動 gutter，回報全域位置供 consumer 調整布局。
final class LayoutResizeHandle extends KlpLayoutNode {
	const LayoutResizeHandle({super.key, this.onResize});

	final ValueChanged<Offset>? onResize;

	@override
	int get flex => 0;

	@override
	Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 線性布局中不承載內容的彈性空間。
final class LayoutSpacer extends KlpLayoutNode {
	const LayoutSpacer({super.key, this.flex = 1, this.bounds = const KlpLayoutBounds()}) : assert(flex > 0);

	@override
	final int flex;
	@override
	final KlpLayoutBounds bounds;

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
		this.bounds = const KlpLayoutBounds(),
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
	final KlpLayoutBounds bounds;

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
		this.bounds = const KlpLayoutBounds(),
		this.role = KlpAppFrameRole.content,
		this.surface = KlpAppFrameSurface.flat,
		this.width,
	}) {
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
		if (width != null && (!width!.isFinite || width! <= 0)) throw ArgumentError.value(width, 'width');
	}

	final Widget child;

	@override
	final int flex;
	@override
	final KlpLayoutBounds bounds;
	final KlpAppFrameRole role;
	final KlpAppFrameSurface surface;
	final double? width;

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

		final width = this.width ?? switch (role) {
			KlpAppFrameRole.sidebar => klp.geometry.layout.primaryPaneWidth,
			KlpAppFrameRole.rightSidebar => klp.geometry.layout.secondaryPaneWidth,
			KlpAppFrameRole.toolbarControls => klp.space.space8 * 3 + klp.space.space1 * 6,
			_ => null,
		};
		return width == null ? frame : SizedBox(width: width, child: frame);
	}
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

/// 浮動位置只屬呈現期；拖曳由外層取得，child tap 仍由 action 自己處理。
final class _KlpFloatingWorkspace extends StatefulWidget {
	const _KlpFloatingWorkspace({required this.action, required this.child});

	final Widget action;
	final Widget child;

	@override
	State<_KlpFloatingWorkspace> createState() => _KlpFloatingWorkspaceState();
}

final class _KlpFloatingWorkspaceState extends State<_KlpFloatingWorkspace> {
	final GlobalKey _actionKey = GlobalKey();
	final GlobalKey _areaKey = GlobalKey();
	Offset? _position;

	void _startDrag(DragStartDetails details) {
		final area = _areaKey.currentContext!.findRenderObject()! as RenderBox;
		final action = _actionKey.currentContext!.findRenderObject()! as RenderBox;
		_position = action.localToGlobal(Offset.zero, ancestor: area);
	}

	void _updateDrag(DragUpdateDetails details) {
		setState(() => _position = _position! + details.delta);
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final inset = klp.space.space2;
		return Stack(
			key: _areaKey,
			fit: StackFit.expand,
			children: [
				widget.child,
				CustomSingleChildLayout(
					delegate: _KlpFloatingPosition(
						position: _position,
						inset: inset,
						headerExtent: klp.space.chromeHeader,
					),
					child: GestureDetector(
						key: _actionKey,
						behavior: HitTestBehavior.translucent,
						onPanStart: _startDrag,
						onPanUpdate: _updateDrag,
						child: IntrinsicWidth(
							child: KlpSurface(
								tone: KlpSurfaceTone.raised,
								radius: klp.shape.panel,
								padding: EdgeInsets.all(inset),
								shadows: [
									BoxShadow(
										color: klp.surface.overlayShadowColor,
										offset: Offset(0, klp.surface.overlayOffsetY),
										blurRadius: klp.surface.overlayBlur,
									),
								],
								child: widget.action,
							),
						),
					),
				),
			],
		);
	}
}

final class _KlpFloatingPosition extends SingleChildLayoutDelegate {
	const _KlpFloatingPosition({required this.position, required this.inset, required this.headerExtent});

	final Offset? position;
	final double inset;
	final double headerExtent;

	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
		return constraints.loosen().deflate(EdgeInsets.all(inset));
	}

	@override
	Offset getPositionForChild(Size size, Size childSize) {
		final right = (size.width - childSize.width - inset).clamp(0.0, size.width);
		final bottom = (size.height - childSize.height - inset).clamp(0.0, size.height);
		final left = inset.clamp(0.0, right);
		final top = (headerExtent + inset).clamp(0.0, bottom);
		return Offset(
			(position?.dx ?? right).clamp(left, right),
			(position?.dy ?? bottom).clamp(top, bottom),
		);
	}

	@override
	bool shouldRelayout(covariant _KlpFloatingPosition oldDelegate) {
		return oldDelegate.position != position || oldDelegate.inset != inset || oldDelegate.headerExtent != headerExtent;
	}
}
