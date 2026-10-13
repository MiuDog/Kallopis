part of '../klp_accordion.dart';

class _KlpAccordionState extends State<KlpAccordion> {
  late Set<String> _expandedIds;

  @override
  void initState() {
    super.initState();
    _expandedIds = {...widget.initialExpandedIds};
  }

  void _toggle(String id) {
    setState(() {
      final isExpanded = _expandedIds.contains(id);
      if (widget.multiple) {
        if (isExpanded) {
          _expandedIds = {..._expandedIds}..remove(id);
        } else {
          _expandedIds = {..._expandedIds, id};
        }
      } else {
        _expandedIds = isExpanded ? const <String>{} : {id};
      }
    });
    widget.onExpandedChanged?.call(_expandedIds);
  }

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < widget.items.length; index++) ...[
          if (index > 0) const KlpGap.heightSize(KlpSpaceSize.tight),
          _KlpAccordionPanel(
            item: widget.items[index],
            expanded: _expandedIds.contains(widget.items[index].id),
            onToggle: () => _toggle(widget.items[index].id),
          ),
        ],
      ],
    );
  }
}
