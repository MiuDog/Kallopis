part of '../klp_app_layout.dart';

/// 尺寸設定與 Widget 身分分離，只在呈現期參與分配。
final class _KlpLinearSpec {
	const _KlpLinearSpec({required this.bounds, required this.flex, this.isGutter = false});
	final KlpLayoutBounds bounds;
	final int flex;
	final bool isGutter;
}

Widget _linearLayout(
	BuildContext context,
	Axis axis,
	List<KlpLayoutNode> nodes,
	KlpLayoutSpacing spacing,
	KlpLayoutMainAlignment alignment,
) {
	final children = <Widget>[];
	final specs = <_KlpLinearSpec>[];
	var previousGutter = false;
	for (final node in nodes) {
		final isGutter = node is KlpLayoutDivider || node is LayoutResizeHandle;
		if (spacing == KlpLayoutSpacing.standard && children.isNotEmpty && !previousGutter && !isGutter) {
			children.add(const SizedBox.shrink());
			specs.add(const _KlpLinearSpec(bounds: KlpLayoutBounds(), flex: 0, isGutter: true));
		}
		Widget content = node;
		if (node is LayoutResizeHandle && node.onResize != null) {
			content = MouseRegion(
				cursor: axis == Axis.horizontal ? SystemMouseCursors.resizeLeftRight : SystemMouseCursors.resizeUpDown,
				child: GestureDetector(
					behavior: HitTestBehavior.opaque,
					onHorizontalDragUpdate: axis == Axis.horizontal ? (details) => node.onResize!(details.globalPosition) : null,
					onVerticalDragUpdate: axis == Axis.vertical ? (details) => node.onResize!(details.globalPosition) : null,
					child: node,
				),
			);
		}
		// 外層使用值鍵保持排序；原始 GlobalKey 只屬於 consumer 節點。
		children.add(ClipRect(key: node.key == null ? null : ValueKey<Key>(node.key!), child: content));
		specs.add(_KlpLinearSpec(bounds: node.bounds, flex: node.flex, isGutter: isGutter));
		previousGutter = isGutter;
	}
	return _KlpLinearHost(
		axis: axis,
		gap: context.klp.space.space2,
		alignment: alignment,
		specs: specs,
		children: children,
	);
}

final class _KlpLinearHost extends MultiChildRenderObjectWidget {
	const _KlpLinearHost({
		required this.axis,
		required this.gap,
		required this.alignment,
		required this.specs,
		required super.children,
	});
	final Axis axis;
	final double gap;
	final KlpLayoutMainAlignment alignment;
	final List<_KlpLinearSpec> specs;

	@override
	_RenderKlpLinearHost createRenderObject(BuildContext context) => _RenderKlpLinearHost(
		axis,
		gap,
		alignment,
		specs,
	);
	@override
	void updateRenderObject(BuildContext context, _RenderKlpLinearHost renderObject) => renderObject.update(
		axis,
		gap,
		alignment,
		specs,
	);
}

/// 只解析本 compound 的直接槽，不持有產品狀態或驗證完整 Widget tree。
final class _RenderKlpLinearHost extends RenderBox with ContainerRenderObjectMixin<RenderBox, FlexParentData>, RenderBoxContainerDefaultsMixin<RenderBox, FlexParentData> {
	_RenderKlpLinearHost(
		this._axis,
		this._gap,
		this._alignment,
		this._specs,
	);
	// 當前語意設定由 host 更新；不得跨 scope 共用。
	Axis _axis;
	double _gap;
	KlpLayoutMainAlignment _alignment;
	List<_KlpLinearSpec> _specs;

	void update(
		Axis axis,
		double gap,
		KlpLayoutMainAlignment alignment,
		List<_KlpLinearSpec> specs,
	) {
		_axis = axis;
		_gap = gap;
		_alignment = alignment;
		_specs = specs;
		markNeedsLayout();
	}

	@override
	void setupParentData(RenderBox child) {
		if (child.parentData is! FlexParentData) child.parentData = FlexParentData();
	}

	double _main(Size value) => _axis == Axis.horizontal ? value.width : value.height;
	double _cross(Size value) => _axis == Axis.horizontal ? value.height : value.width;
	Size _size(double main, double cross) => _axis == Axis.horizontal ? Size(main, cross) : Size(cross, main);
	BoxConstraints _constraints(double main, double cross, {bool tightMain = false}) {
		final value = _size(main, cross);
		final minimum = _size(tightMain ? main : 0, cross.isFinite ? cross : 0);
		return BoxConstraints(minWidth: minimum.width, maxWidth: value.width, minHeight: minimum.height, maxHeight: value.height);
	}

	@override
	void performLayout() {
		final maxMain = _axis == Axis.horizontal ? constraints.maxWidth : constraints.maxHeight;
		final maxCross = _axis == Axis.horizontal ? constraints.maxHeight : constraints.maxWidth;
		final finiteMain = maxMain.isFinite;
		final items = <KlpLinearItem>[];
		var cross = maxCross.isFinite ? maxCross : 0.0;
		var gutterCount = 0;
		var child = firstChild;
		for (final spec in _specs) {
			final current = child!;
			final data = current.parentData! as FlexParentData;
			child = data.nextSibling;
			if (spec.isGutter) {
				gutterCount++;
				continue;
			}
			var measured = 0.0;
			if (!finiteMain || !maxCross.isFinite || (spec.flex == 0 && spec.bounds.preferred == null)) {
				current.layout(_constraints(double.infinity, maxCross), parentUsesSize: true);
				measured = _main(current.size);
				if (!measured.isFinite || !_cross(current.size).isFinite) throw FlutterError('Kallopis 自然布局需要有限的內容尺寸。');
				if (!maxCross.isFinite) cross = math.max(cross, _cross(current.size));
			}
			final preferred = spec.bounds.preferred ?? ((!finiteMain || spec.flex == 0) ? measured : spec.bounds.minimum);
			items.add(KlpLinearItem(
				minimum: spec.bounds.minimum,
				maximum: spec.bounds.maximum,
				preferred: preferred,
				flex: finiteMain ? spec.flex.toDouble() : 0,
			));
		}
		var extent = maxMain;
		if (!finiteMain) {
			// 無上限主軸使用有限自然 budget；bounds 的範圍仍由公開解析器驗證。
			extent = _gap * gutterCount;
			for (final item in items) {
				extent += math.max(item.minimum, math.min(item.preferred, item.maximum ?? double.infinity));
			}
			if (!extent.isFinite || !cross.isFinite) throw FlutterError('Kallopis 自然布局尺寸總和必須有限。');
		}
		size = constraints.constrain(_size(extent, cross));
		final result = resolveKlpLinearLayout(
			extent: _main(size),
			gutter: _gap,
			gutterCount: gutterCount,
			items: items,
		);
		cross = _cross(size);
		var position = _alignment == KlpLayoutMainAlignment.end ? result.unused : 0.0;
		var itemIndex = 0;
		child = firstChild;
		for (final spec in _specs) {
			final current = child!;
			final data = current.parentData! as FlexParentData;
			final slot = spec.isGutter ? result.gutter : result.extents[itemIndex++];
			current.layout(_constraints(slot, cross, tightMain: true), parentUsesSize: true);
			data.offset = _axis == Axis.horizontal ? Offset(position, 0) : Offset(0, position);
			position += slot;
			child = data.nextSibling;
		}
	}

	@override
	void paint(PaintingContext context, Offset offset) => defaultPaint(context, offset);
	@override
	bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => defaultHitTestChildren(result, position: position);
}
