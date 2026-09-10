part of '../klp_advanced_data.dart';

class _KlpJsonNodeState extends State<_KlpJsonNode> {
  late bool _expanded;

  bool get _structured => widget.value is Map || widget.value is Iterable;

  @override
  void initState() {
    super.initState();
    _expanded =
        widget.expandedPaths.contains(widget.path) ||
        widget.depth < widget.defaultDepth;
  }

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    if (!_structured) return _buildScalar(context);

    final style = _KlpAdvancedStyle.from(context);
    final entries = _entries();
    final countLabel = widget.value is Map
        ? '{${entries.length}}'
        : '[${entries.length}]';
    final heading = <Widget>[
      _KlpTreeDisclosure(
        expanded: _expanded,
        child: KlpIcon(
          KlpIcons.chevronDown,
          size: style.iconSmall,
          color: style.textMuted,
        ),
      ),
      const KlpGap.tight(),
    ];
    if (widget.name != null) {
      heading.add(KlpText('${widget.name}:', role: KlpTextRole.code));
      heading.add(const KlpGap.tight());
    }
    heading.add(
      KlpText(countLabel, role: KlpTextRole.code, tone: KlpTextTone.muted),
    );

    final children = <Widget>[
      KlpGestureRegion(
        key: ValueKey('pln-json-toggle-${widget.path}'),
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: _KlpAdvancedIndent(
          extent: widget.depth * style.baseSpace,
          child: KlpRow(children: heading),
        ),
      ),
    ];
    if (_expanded) {
      for (final entry in entries) {
        children.add(
          _KlpJsonNode(
            value: entry.value,
            name: entry.key,
            path: '${widget.path}.${entry.key}',
            depth: widget.depth + 1,
            defaultDepth: widget.defaultDepth,
            expandedPaths: widget.expandedPaths,
            onCopyPath: widget.onCopyPath,
          ),
        );
      }
    }

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  List<MapEntry<String, Object?>> _entries() {
    if (widget.value is Map) {
      return (widget.value as Map).entries
          .map((entry) => MapEntry('${entry.key}', entry.value))
          .toList();
    }

    return (widget.value as Iterable)
        .toList()
        .asMap()
        .entries
        .map((entry) => MapEntry('${entry.key}', entry.value))
        .toList();
  }

  Widget _buildScalar(BuildContext context) {
    final style = _KlpAdvancedStyle.from(context);
    final value = switch (widget.value) {
      String value => '"$value"',
      null => 'null',
      _ => '${widget.value}',
    };
    final children = <Widget>[KlpGap.width(style.iconSize + style.tightSpace)];
    if (widget.name != null) {
      children.add(KlpText(widget.name!, role: KlpTextRole.code));
      children.add(const KlpText(':', role: KlpTextRole.code));
      children.add(const KlpGap.tight());
    }
    children.add(
      KlpText(value, role: KlpTextRole.code, tone: KlpTextTone.muted),
    );

    return KlpGestureRegion(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onCopyPath == null
          ? null
          : () => widget.onCopyPath!(widget.path),
      child: _KlpAdvancedIndent(
        extent: widget.depth * style.baseSpace,
        child: KlpRow(children: children),
      ),
    );
  }
}
