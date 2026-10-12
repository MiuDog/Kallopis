part of '../klp_navigator.dart';

class _KlpNavigatorState extends State<KlpNavigator> {
  late final Set<String> _expandedCategoryIds = _initialExpandedCategories();
  late final Set<String> _expandedElementIds = _initialExpandedElements();
  String? _selectedElementId;

  @override
  void initState() {
    super.initState();
    _selectedElementId = widget.selectedElementId ?? _initialSelectedElement();
  }

  Set<String> _initialExpandedCategories() {
    final result = <String>{};

    void collect(List<KlpNavigatorItem> items) {
      for (final item in items) {
        if (item case KlpNavigatorCategory(
          :final id,
          :final expanded,
          :final items,
        )) {
          if (expanded) result.add(id);
          collect(items);
        }
      }
    }

    collect(widget.items);
    return result;
  }

  Set<String> _initialExpandedElements() {
    final result = <String>{};

    void collectElements(List<KlpNavigatorElement> elements) {
      for (final element in elements) {
        if (element.expanded) result.add(element.id);
        collectElements(element.children);
      }
    }

    void collectItems(List<KlpNavigatorItem> items) {
      for (final item in items) {
        switch (item) {
          case KlpNavigatorCategory(:final items):
            collectItems(items);
          case KlpNavigatorElement():
            collectElements([item]);
          case KlpNavigatorComponent():
            break;
        }
      }
    }

    collectItems(widget.items);
    return result;
  }

  String? _initialSelectedElement() {
    String? result;

    void collectElements(List<KlpNavigatorElement> elements) {
      for (final element in elements) {
        if (result != null) return;
        if (element.selected) result = element.id;
        collectElements(element.children);
      }
    }

    void collectItems(List<KlpNavigatorItem> items) {
      for (final item in items) {
        if (result != null) return;
        switch (item) {
          case KlpNavigatorCategory(:final items):
            collectItems(items);
          case KlpNavigatorElement():
            collectElements([item]);
          case KlpNavigatorComponent():
            break;
        }
      }
    }

    collectItems(widget.items);
    return result;
  }

  void _toggleCategory(String id) {
    if (widget.onCategoryToggle != null) {
      widget.onCategoryToggle!(id);
      return;
    }

    setState(() {
      if (!_expandedCategoryIds.remove(id)) _expandedCategoryIds.add(id);
    });
  }

  void _toggleElement(String id) {
    if (widget.onElementToggle != null) {
      widget.onElementToggle!(id);
      return;
    }

    setState(() {
      if (!_expandedElementIds.remove(id)) _expandedElementIds.add(id);
    });
  }

  void _selectElement(String id) {
    if (widget.onElementSelected != null) {
      widget.onElementSelected!(id);
      return;
    }

    setState(() => _selectedElementId = id);
  }

  @override
  Widget build(BuildContext context) {
    final expandedCategoryIds =
        widget.expandedCategoryIds ?? _expandedCategoryIds;
    final expandedElementIds = widget.expandedElementIds ?? _expandedElementIds;
    final selectedElementId = widget.selectedElementId ?? _selectedElementId;

    return KlpSurface(
      tone: widget.surfaceTone,
      child: _KlpNavigatorScope(
        expandedCategoryIds: Set.unmodifiable(expandedCategoryIds),
        expandedElementIds: Set.unmodifiable(expandedElementIds),
        selectedElementId: selectedElementId,
        onCategoryToggle: _toggleCategory,
        onElementToggle: _toggleElement,
        onElementSelected: _selectElement,
        child: _KlpNavigatorListViewport(
          key: widget.scrollKey,
          controller: widget.scrollController,
          children: [
            for (final item in widget.items)
              _KlpNavigatorItemView(item: item, level: 0),
          ],
        ),
      ),
    );
  }
}
