part of '../klp_dock_layout.dart';

/// 同一份 root 配額供原生槽、邊緣把手與 resize 使用，不持有保存 state。
final class _KlpDockGeometry {
	const _KlpDockGeometry({
		required this.left,
		required this.right,
		required this.bottom,
		required this.header,
		required this.stage,
		required this.leftHandle,
		required this.rightHandle,
		required this.bottomHandle,
		required this.maximumLeft,
		required this.maximumRight,
		required this.maximumBottom,
	});

	/// 可見且非空的區域才配置正文槽；頂列仍跨中央與右區。
	final Rect? left;
	final Rect? right;
	final Rect? bottom;
	final Rect? header;
	final Rect stage;
	/// Hidden reopen 把手不預留正文空間，但仍受宿主邊界限制。
	final Rect leftHandle;
	final Rect rightHandle;
	final Rect bottomHandle;
	/// Pointer 提交不能侵入另一區及實際把手的預算。
	final double maximumLeft;
	final double maximumRight;
	final double maximumBottom;
}

/// 舊 maxExtent=Infinity 是無邏輯上限；純 resolver 用 null 表示。
KlpLinearItem _dockAreaItem(KlpDockAreaData area, KlpDockAreaConstraints limits) => KlpLinearItem(
	minimum: limits.minExtent,
	maximum: limits.maxExtent == double.infinity ? null : limits.maxExtent,
	preferred: area.extent,
	flex: 0,
);

_KlpDockGeometry _resolveDockGeometry({
	required Size size,
	required KlpDockLayoutData layout,
	required KlpDockAreaConstraints leftConstraints,
	required KlpDockAreaConstraints rightConstraints,
	required KlpDockAreaConstraints? bottomConstraints,
	required double handleExtent,
	required double? headerExtent,
}) {
	if (!size.width.isFinite || !size.height.isFinite || size.width < 0 || size.height < 0) {
		throw ArgumentError.value(size, 'size', 'Dock requires finite nonnegative width and height.');
	}
	if (headerExtent != null && (!headerExtent.isFinite || headerExtent < 0)) {
		throw ArgumentError.value(headerExtent, 'headerExtent', 'Expected finite nonnegative height.');
	}
	final showLeft = layout.left.isVisible && layout.left.groups.isNotEmpty;
	final showRight = layout.right.isVisible && layout.right.groups.isNotEmpty;
	final showBottom = layout.bottom.isVisible && layout.bottom.groups.isNotEmpty;
	final horizontal = resolveKlpLinearLayout(
		extent: size.width,
		gutter: handleExtent,
		gutterCount: (showLeft ? 1 : 0) + (showRight ? 1 : 0),
		items: [
			if (showLeft) _dockAreaItem(layout.left, leftConstraints),
			const KlpLinearItem(),
			if (showRight) _dockAreaItem(layout.right, rightConstraints),
		],
	);
	final leftWidth = showLeft ? horizontal.extents.first : 0.0;
	final rightWidth = showRight ? horizontal.extents.last : 0.0;
	final sideGutter = horizontal.gutter;
	final centerLeft = showLeft ? leftWidth + sideGutter : 0.0;
	final centerWidth = horizontal.extents[showLeft ? 1 : 0];
	final headerHeight = math.min(headerExtent ?? 0.0, size.height);
	final bodyHeight = math.max(0.0, size.height - headerHeight);
	final vertical = resolveKlpLinearLayout(
		extent: bodyHeight,
		gutter: handleExtent,
		gutterCount: showBottom ? 1 : 0,
		items: [
			const KlpLinearItem(),
			if (showBottom) _dockAreaItem(layout.bottom, bottomConstraints!),
		],
	);
	final bottomHeight = showBottom ? vertical.extents.last : 0.0;
	final leftHandleWidth = showLeft ? sideGutter : math.min(handleExtent, size.width);
	final rightHandleWidth = showRight ? sideGutter : math.min(handleExtent, size.width);
	final bottomHandleHeight = showBottom ? vertical.gutter : math.min(handleExtent, bodyHeight);

	return _KlpDockGeometry(
		left: showLeft ? Offset.zero & Size(leftWidth, size.height) : null,
		right: showRight ? Offset(size.width - rightWidth, headerHeight) & Size(rightWidth, bodyHeight) : null,
		bottom: showBottom ? Offset(centerLeft, size.height - bottomHeight) & Size(centerWidth, bottomHeight) : null,
		header: headerExtent == null ? null : Offset(centerLeft, 0) & Size(math.max(0.0, size.width - centerLeft), headerHeight),
		stage: Offset(centerLeft, headerHeight) & Size(centerWidth, vertical.extents.first),
		leftHandle: Offset(leftWidth, 0) & Size(leftHandleWidth, size.height),
		rightHandle: Offset(size.width - rightWidth - rightHandleWidth, headerHeight) & Size(rightHandleWidth, bodyHeight),
		bottomHandle: Offset(centerLeft, size.height - bottomHeight - bottomHandleHeight) & Size(centerWidth, bottomHandleHeight),
		maximumLeft: math.max(0.0, size.width - rightWidth - (showRight ? sideGutter : 0.0) - leftHandleWidth),
		maximumRight: math.max(0.0, size.width - leftWidth - (showLeft ? sideGutter : 0.0) - rightHandleWidth),
		maximumBottom: math.max(0.0, bodyHeight - bottomHandleHeight),
	);
}
