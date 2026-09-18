import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/src/styling/presets/klp_frame_relief_recipe.dart';
import 'klp_flutter_header_drag_region.dart';

import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import '../klp_flutter_renderer.dart';
import 'klp_flutter_values.dart';

/// 封閉 app layout renderer；消費端不能直接取得 Flutter child 或 layout callback。
final class KlpFlutterAppLayout extends StatelessWidget {

	final KlpBoundAppLayout content;

	const KlpFlutterAppLayout({required this.content, super.key});

	@override
	Widget build(BuildContext context) {
		switch (content.kind) {
			case 0:
				final body = Padding(padding: EdgeInsets.all(content.inset.value), child: KlpFlutterRenderer(content: content.children.first));
				final workspace = content.children.length == 1 ? body : _FloatingWorkspace(content: content, child: body);
				return content.onHeaderDrag == null ? workspace : KlpFlutterHeaderDragRegion(extent: content.inset.value * 2 + content.headerExtent!.value, onDrag: content.onHeaderDrag!, child: workspace);
			case 1:
				final row = Row(mainAxisAlignment: content.alignment == 1 ? MainAxisAlignment.end : MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: _linearChildren(Axis.horizontal));
				return content.flex == 0 ? IntrinsicHeight(child: row) : row;
			case 2:
				return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _linearChildren(Axis.vertical));
			case 3:
				return Center(child: SizedBox(width: content.inset.value, child: const DecoratedBox(decoration: BoxDecoration())));
			case 4:
				final radius = BorderRadius.circular(content.radius.value);
				final frame = content.bare ? KlpFlutterRenderer(content: content.children.single) : ClipRRect(borderRadius: radius, child: DecoratedBox(decoration: BoxDecoration(color: klpFlutterColor(content.background), borderRadius: radius), child: KlpFlutterRenderer(content: content.children.single)));
				final surface = _withRelief(frame, radius);
				return content.laneExtent == null ? surface : SizedBox(width: content.laneExtent!.value, child: surface);
			case 5:
				return const SizedBox.shrink();
			case 6:
				final pane = KlpFlutterRenderer(content: content.children.single);
				return content.laneExtent == null ? pane : SizedBox(width: content.laneExtent!.value, child: pane);
			default:
				throw StateError('Unknown app layout bound kind: ${content.kind}.');
		}
	}

	Widget _withRelief(Widget frame, BorderRadius radius) {
		final shadow = content.reliefShadow;
		final highlight = content.reliefHighlight;
		final scale = content.reliefScale;
		if (content.bare || shadow == null || highlight == null || scale == null) return frame;

		// 在裁切之外繪製陰影與左上亮邊，不增加內容內距或命中範圍。
		final factor = KlpFrameReliefRecipe.factor(scale.value);
		final shadows = [
			BoxShadow(
				color: klpFlutterColor(shadow),
				offset: Offset(KlpFrameReliefRecipe.offsetX * factor, KlpFrameReliefRecipe.offsetY * factor),
				blurRadius: KlpFrameReliefRecipe.blur * factor,
				spreadRadius: KlpFrameReliefRecipe.spread * factor,
			),
			BoxShadow(color: klpFlutterColor(highlight), offset: Offset(KlpFrameReliefRecipe.highlightOffset * factor, KlpFrameReliefRecipe.highlightOffset * factor)),
		];
		return DecoratedBox(decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows), child: frame);
	}

	List<Widget> _linearChildren(Axis axis) {
		final children = <Widget>[];
		var previousWasHandle = false;
		// 顯式 handle 自己占據 gutter，前後都不再加入普通間距。
		for (final child in content.children) {
			final layout = switch (child) {
				KlpBoundPlacement(:final content) when content is KlpBoundAppLayout => content,
				KlpBoundAppLayout value => value,
				_ => null,
			};
			final isHandle = layout?.kind == 3;
			if (!content.gapless && children.isNotEmpty && !previousWasHandle && !isHandle) children.add(SizedBox(width: axis == Axis.horizontal ? content.inset.value : null, height: axis == Axis.vertical ? content.inset.value : null));
			final built = KlpFlutterRenderer(content: child);
			if (isHandle) {
				children.add(axis == Axis.horizontal ? SizedBox(width: content.inset.value, child: built) : SizedBox(height: content.inset.value, child: built));
			}
			else if (layout != null && layout.flex > 0) {
				children.add(Expanded(flex: layout.flex, child: built));
			}
			else {
				children.add(built);
			}
			previousWasHandle = isHandle;
		}
		return children;
	}
}

/// 浮動位置是呈現狀態；點擊沿用 action，拖曳只移動按鈕而不執行操作。
final class _FloatingWorkspace extends StatefulWidget {
	final KlpBoundAppLayout content;
	final Widget child;
	const _FloatingWorkspace({required this.content, required this.child});
	@override
	State<_FloatingWorkspace> createState() => _FloatingWorkspaceState();
}

final class _FloatingWorkspaceState extends State<_FloatingWorkspace> {
	final _buttonKey = GlobalKey();
	final _areaKey = GlobalKey();
	Offset? _position;

	@override
	Widget build(BuildContext context) {
		final content = widget.content;
		KlpBoundWorkspaceBlock action(KlpBoundTemplate value) => switch (value) {
			KlpBoundPlacement(:final content) => action(content),
			KlpBoundWorkspaceBlock value => value,
			_ => throw StateError('Floating content must be an action.'),
		};
		final style = action(content.children.last);
		return Stack(key: _areaKey, fit: StackFit.expand, children: [
			widget.child,
			CustomSingleChildLayout(
				delegate: _FloatingPosition(_position, content.inset.value, content.headerExtent!.value),
				child: GestureDetector(
					key: _buttonKey,
					onPanStart: (_) {
						final area = _areaKey.currentContext!.findRenderObject()! as RenderBox;
						final button = _buttonKey.currentContext!.findRenderObject()! as RenderBox;
						_position = button.localToGlobal(Offset.zero, ancestor: area);
					},
					onPanUpdate: (details) => setState(() => _position = _position! + details.delta),
					child: IntrinsicWidth(child: DecoratedBox(
						decoration: BoxDecoration(color: klpFlutterColor(content.background), borderRadius: BorderRadius.circular(content.radius.value), boxShadow: style.shadowed ? [BoxShadow(color: klpFlutterColor(style.shadowColor), offset: Offset(0, style.shadowOffset.value), blurRadius: style.shadowBlur.value)] : const []),
						child: Padding(padding: EdgeInsets.all(content.inset.value), child: KlpFlutterRenderer(content: content.children.last)),
					)),
				),
			),
		]);
	}
}

final class _FloatingPosition extends SingleChildLayoutDelegate {
	final Offset? position;
	final double inset;
	final double headerExtent;
	const _FloatingPosition(this.position, this.inset, this.headerExtent);
	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints.loosen().deflate(EdgeInsets.all(inset));
	@override
	Offset getPositionForChild(Size size, Size childSize) {
		final right = (size.width - childSize.width - inset).clamp(0.0, size.width);
		final bottom = (size.height - childSize.height - inset).clamp(0.0, size.height);
		final left = inset.clamp(0.0, right);
		final top = (headerExtent + inset * 2).clamp(0.0, bottom);
		return Offset((position?.dx ?? right).clamp(left, right), (position?.dy ?? bottom).clamp(top, bottom));
	}
	@override
	bool shouldRelayout(_FloatingPosition oldDelegate) => position != oldDelegate.position || inset != oldDelegate.inset || headerExtent != oldDelegate.headerExtent;
}
