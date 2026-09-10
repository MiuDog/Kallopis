part of '../klp_advanced_data.dart';

class _KlpTreeNodeView extends StatelessWidget {
	const _KlpTreeNodeView({
		required this.node,
		required this.onSelected,
		this.expandedIds,
		this.selectedId,
		this.onExpanded,
	});

	final KlpTreeNode node;
	final Set<String>? expandedIds;
	final String? selectedId;
	final ValueChanged<String>? onSelected;
	final ValueChanged<String>? onExpanded;

	@override
	Widget build(BuildContext context) {
		final style = _KlpAdvancedStyle.from(context);
		final selected = selectedId == null ? node.selected : selectedId == node.id;
		final expanded = expandedIds == null
				? node.expanded
				: expandedIds!.contains(node.id);
		final expandable = node.hasChildren || node.children.isNotEmpty;
		final statusColor = _statusColor(style);
		final opacity = selected
				? style.statusRowSelectedOpacity
				: style.statusRowOpacity;
		final background = statusColor?.withValues(alpha: opacity);

		Widget rowContent = _KlpTreeNodeFrame(
			style: style,
			background: background,
			child: KlpRow(
				children: _rowChildren(
					style,
					selected,
					expanded,
					expandable,
					statusColor,
				),
			),
		);

		if (selected && statusColor == null) {
			rowContent = KlpStateHighlight(
				state: KlpHighlightState.selected,
				borderRadius: BorderRadius.circular(style.controlRadius),
				child: rowContent,
			);
		}

		final children = <Widget>[
			KlpGestureRegion(
				behavior: HitTestBehavior.opaque,
				onTap: onSelected == null ? null : () => onSelected!(node.id),
				child: rowContent,
			),
		];
		if (expanded) {
			for (final child in node.children) {
				children.add(
					_KlpTreeNodeView(
						node: child,
						expandedIds: expandedIds,
						selectedId: selectedId,
						onSelected: onSelected,
						onExpanded: onExpanded,
					),
				);
			}
		}

		return _KlpAdvancedIndent(
			extent: style.treeLeadingGap,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: children,
			),
		);
	}

	List<Widget> _rowChildren(
		_KlpAdvancedStyle style,
		bool selected,
		bool expanded,
		bool expandable,
		Color? statusColor,
	) {
		final children = <Widget>[];
		if (expandable) {
			children.add(
				KlpGestureRegion(
					key: ValueKey('pln-tree-expand-${node.id}'),
					behavior: HitTestBehavior.opaque,
					onTap: onExpanded == null ? null : () => onExpanded!(node.id),
					child: KlpBox.square(
						dimension: style.iconSize,
						child: KlpCenter(
							child: _KlpTreeDisclosure(
								expanded: expanded,
								child: KlpIcon(
									KlpIcons.chevronDown,
									size: style.iconSmall,
									color: style.textMuted,
								),
							),
						),
					),
				),
			);
			children.add(const KlpGap.tight());
		} else {
			children.add(KlpGap.width(style.iconSize + style.tightSpace));
		}

		if (node.icon != null) {
			final iconColor =
					statusColor ??
					(selected ? style.selectionForeground : style.textMuted);
			children.add(
				KlpIcon(node.icon!, size: style.iconSmall, color: iconColor),
			);
			children.add(KlpGap.width(style.inlineGap));
		}

		children.add(
			KlpExpanded(
				child: KlpText(
					node.label,
					color: _labelColor(style, selected, statusColor),
					decoration: node.deleted ? TextDecoration.lineThrough : null,
					maxLines: 1,
					overflow: TextOverflow.ellipsis,
					ellipsisText: '...',
				),
			),
		);

		if (node.badge != null) {
			final badgeColor =
					statusColor ??
					(selected ? style.selectionForeground : style.textMuted);
			children.add(KlpGap.width(style.inlineGap));
			children.add(
				KlpText(node.badge!, role: KlpTextRole.label, color: badgeColor),
			);
		}

		return children;
	}

	Color? _statusColor(_KlpAdvancedStyle style) {
		return switch (node.tone) {
			KlpFeedbackTone.warning => style.warning,
			KlpFeedbackTone.info => style.info,
			KlpFeedbackTone.success => style.success,
			KlpFeedbackTone.danger => style.danger,
			KlpFeedbackTone.neutral || null => null,
		};
	}

	Color _labelColor(
		_KlpAdvancedStyle style,
		bool selected,
		Color? statusColor,
	) {
		if (node.deleted) return style.textFaint;
		if (statusColor != null) return style.text;
		return selected ? style.selectionForeground : style.textMuted;
	}
}
