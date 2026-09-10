part of '../klp_file_explorer.dart';

class _KlpFileExplorerState extends State<KlpFileExplorer> {
	late Set<String> _internalExpandedSections;
	late Set<String> _internalExpandedItems;
	String? _internalSelectedId;

	@override
	void initState() {
		super.initState();
		final effectiveSections = widget.sections.isEmpty
				? widget.emptyStateSections
				: widget.sections;
		_internalExpandedSections = {
			for (final s in effectiveSections)
				if (s.expanded) s.id,
		};
		_internalExpandedItems = {};
		_collectExpandedItems(effectiveSections, _internalExpandedItems);
		_internalSelectedId = widget.selectedId;
	}

	void _collectExpandedItems(
		List<KlpFileExplorerSection> sections,
		Set<String> target,
	) {
		void traverse(List<KlpFileExplorerItem> items) {
			for (final item in items) {
				if (item.expanded) {
					target.add(item.id);
				}
				if (item.children.isNotEmpty) {
					traverse(item.children);
				}
			}
		}

		for (final s in sections) {
			traverse(s.items);
		}
	}

	void _toggleSection(String id) {
		if (widget.onSectionToggle != null) {
			widget.onSectionToggle!(id);
		} else {
			setState(() {
				if (_internalExpandedSections.contains(id)) {
					_internalExpandedSections.remove(id);
				} else {
					_internalExpandedSections.add(id);
				}
			});
		}
	}

	void _toggleItem(String id) {
		if (widget.onItemToggle != null) {
			widget.onItemToggle!(id);
		} else {
			setState(() {
				if (_internalExpandedItems.contains(id)) {
					_internalExpandedItems.remove(id);
				} else {
					_internalExpandedItems.add(id);
				}
			});
		}
	}

	void _selectItem(String id) {
		if (widget.onItemSelected != null) {
			widget.onItemSelected!(id);
		} else {
			setState(() {
				_internalSelectedId = id;
			});
		}
	}

	String? _firstSelectedItemId(List<KlpFileExplorerSection> sections) {
		String? selectedId;

		void traverse(List<KlpFileExplorerItem> items) {
			for (final item in items) {
				if (selectedId != null) return;
				if (item.selected) {
					selectedId = item.id;
					return;
				}
				traverse(item.children);
			}
		}

		for (final section in sections) {
			traverse(section.items);
			if (selectedId != null) break;
		}
		return selectedId;
	}

	@override
	Widget build(BuildContext context) {
		final effectiveExpandedSections =
				widget.expandedSectionIds ?? _internalExpandedSections;
		final effectiveExpandedItems =
				widget.expandedItemIds ?? _internalExpandedItems;
		final effectiveSections = widget.sections.isEmpty
				? widget.emptyStateSections
				: widget.sections;
		final effectiveSelectedId =
				widget.selectedId ??
				_internalSelectedId ??
				_firstSelectedItemId(effectiveSections);

		return _KlpFileExplorerListViewport(
			controller: widget.scrollController,
			children: [
				for (final section in effectiveSections)
					KlpFileExplorerSection._render(
						section: section,
						child: KlpFileExplorerSectionView(
							section: section,
							isExpanded: effectiveExpandedSections.contains(section.id),
							expandedItemIds: effectiveExpandedItems,
							selectedId: effectiveSelectedId,
							onToggle: () => _toggleSection(section.id),
							onItemToggle: _toggleItem,
							onItemSelected: _selectItem,
							spacing: widget.spacing,
						),
					),
			],
		);
	}
}
