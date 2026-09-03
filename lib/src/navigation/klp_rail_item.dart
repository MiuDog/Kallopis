import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../interaction/klp_drag_drop.dart';
import '../overlay/klp_tooltip.dart';
import '../theme/klp_theme.dart';

class KlpRailItem extends StatefulWidget {
  const KlpRailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.badge,
  });

  final KlpIconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;
  final String? badge;

  @override
  State<KlpRailItem> createState() => _KlpRailItemState();
}

/// Workbench 的主要圖示導覽軌。
///
/// 呼叫端只決定項目與順序；32px item、8px 內距與相鄰間距由 Kallopis
/// semantic spacing 統一解析。
class KlpNavigationRail extends StatefulWidget {
	const KlpNavigationRail({
		super.key,
		this.leading = const [],
		required this.children,
		this.onReorder,
	});

	final List<Widget> leading;
	final List<Widget> children;
	final void Function(int oldIndex, int newIndex)? onReorder;

	@override
	State<KlpNavigationRail> createState() => _KlpNavigationRailState();
}

class _KlpNavigationRailState extends State<KlpNavigationRail> {
	int? _dragIndex;
	int? _dropIndex;

	bool _accepts(int sourceIndex) {
		return widget.onReorder != null &&
			sourceIndex >= 0 &&
			sourceIndex < widget.children.length;
	}

	void _startDrag(int index) {
		setState(() {
			_dragIndex = index;
			_dropIndex = index;
		});
	}

	void _showDropIndex(int index) {
		if (_dropIndex == index) return;
		setState(() => _dropIndex = index);
	}

	void _showItemDrop(
		BuildContext targetContext,
		int targetIndex,
		Offset globalPosition,
	) {
		final box = targetContext.findRenderObject() as RenderBox?;
		if (box == null || !box.hasSize) return;
		final localPosition = box.globalToLocal(globalPosition);
		_showDropIndex(
			localPosition.dy < box.size.height / 2
				? targetIndex
				: targetIndex + 1,
		);
	}

	void _finishDrag(int sourceIndex) {
		final insertionIndex = _dropIndex;
		if (insertionIndex != null) {
			var destinationIndex = insertionIndex;
			if (destinationIndex > sourceIndex) destinationIndex -= 1;
			if (destinationIndex != sourceIndex) {
				widget.onReorder?.call(sourceIndex, destinationIndex);
			}
		}
		_clearDrag();
	}

	void _clearDrag() {
		if (!mounted || (_dragIndex == null && _dropIndex == null)) return;
		setState(() {
			_dragIndex = null;
			_dropIndex = null;
		});
	}

	Widget _buildDropSlot(BuildContext context, int index) {
		final gap = context.klp.space.compact;
		final motion = context.klp.motion;
		return DragTarget<int>(
			onWillAcceptWithDetails: (details) => _accepts(details.data),
			onMove: (_) => _showDropIndex(index),
			onAcceptWithDetails: (details) => _finishDrag(details.data),
			builder: (context, candidateData, rejectedData) {
				return SizedBox(
					width: context.klp.space.railItem,
					height: gap,
					child: Center(
						child: AnimatedOpacity(
							opacity: _dragIndex != null && _dropIndex == index
								? 1
								: 0,
							duration: motion.stateTransition,
							curve: motion.standard,
							child: const KlpDropIndicator(thickness: 2),
						),
					),
				);
			},
		);
	}

	Widget _buildDraggableItem(BuildContext context, int index) {
		final child = widget.children[index];
		return Builder(
			builder: (targetContext) {
				return DragTarget<int>(
					onWillAcceptWithDetails: (details) => _accepts(details.data),
					onMove: (details) => _showItemDrop(
						targetContext,
						index,
						details.offset,
					),
					onAcceptWithDetails: (details) => _finishDrag(details.data),
					builder: (context, candidateData, rejectedData) {
						return Draggable<int>(
							data: index,
							axis: Axis.vertical,
							onDragStarted: () => _startDrag(index),
							onDragEnd: (_) => _clearDrag(),
							onDraggableCanceled: (_, _) => _clearDrag(),
							feedback: ExcludeSemantics(
								child: IgnorePointer(
									child: Material(
										type: MaterialType.transparency,
										child: child,
									),
								),
							),
							childWhenDragging: SizedBox.square(
								dimension: context.klp.space.railItem,
							),
							child: child,
						);
					},
				);
			},
		);
	}

	Widget _buildStaticRail(BuildContext context) {
		final gap = context.klp.space.compact;
		final children = [...widget.leading, ...widget.children];
		return Padding(
			padding: EdgeInsets.symmetric(vertical: gap),
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					for (var index = 0; index < children.length; index++) ...[
						children[index],
						if (index < children.length - 1) SizedBox(height: gap),
					],
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		if (widget.onReorder == null) return _buildStaticRail(context);
		final gap = context.klp.space.compact;
		final motion = context.klp.motion;
		final orderKey = widget.children.map((child) => child.key).join('|');
		return Padding(
			padding: EdgeInsets.only(
				top: widget.leading.isEmpty ? 0 : gap,
			),
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					for (var index = 0; index < widget.leading.length; index++) ...[
						widget.leading[index],
						if (index < widget.leading.length - 1) SizedBox(height: gap),
					],
					AnimatedSwitcher(
						duration: motion.stateTransition,
						switchInCurve: motion.standard,
						switchOutCurve: motion.standard,
						child: Column(
							key: ValueKey(orderKey),
							mainAxisSize: MainAxisSize.min,
							children: [
								for (
									var index = 0;
									index < widget.children.length;
									index++
								) ...[
									_buildDropSlot(context, index),
									_buildDraggableItem(context, index),
								],
								_buildDropSlot(context, widget.children.length),
							],
						),
					),
				],
			),
		);
	}
}

class _KlpRailItemState extends State<KlpRailItem> {
  final LayerLink _tooltipLink = LayerLink();
  final OverlayPortalController _tooltipController = OverlayPortalController();
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) {
    setState(() => _hovered = value);
    _syncTooltip(hovered: value);
  }

  void _setFocused(bool value) {
    setState(() => _focused = value);
  }

  void _syncTooltip({required bool hovered}) {
    if (hovered) {
      _tooltipController.show();
    } else {
      _tooltipController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final background = widget.selected
        ? tokens.selectionBackground
        : _hovered || _focused
        ? context.klp.selectionWash
        : tokens.clear;
    final item = Material(
      color: background,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: _setHovered,
        onFocusChange: _setFocused,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: SizedBox.square(
          dimension: context.klp.space.railItem,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: KlpIcon(
                  widget.icon,
                  color: widget.selected
                      ? tokens.selectionForeground
                      : tokens.textMuted,
                ),
              ),
              if (widget.badge != null)
                Positioned(
                  top: context.klp.geometry.optical.railBadgeInset,
                  right: context.klp.geometry.optical.railBadgeInset,
                  child: Container(
                    width: context.klp.space.indicatorDotLarge,
                    height: context.klp.space.indicatorDotLarge,
                    decoration: BoxDecoration(
                      color: tokens.info,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return OverlayPortal(
      controller: _tooltipController,
      overlayChildBuilder: (context) {
        return CompositedTransformFollower(
          link: _tooltipLink,
          targetAnchor: Alignment.centerRight,
          followerAnchor: Alignment.centerLeft,
          offset: Offset(context.klp.space.compact, 0),
          showWhenUnlinked: false,
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: KlpTooltipSurface(
                  message: widget.label,
                  contentKey: ValueKey('rail-hover-label-${widget.label}'),
                ),
              ),
            ),
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _tooltipLink,
        child: Semantics(
          button: true,
          selected: widget.selected,
          label: widget.label,
          child: item,
        ),
      ),
    );
  }
}
