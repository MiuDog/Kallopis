part of '../klp_advanced_data.dart';

class _KlpJsonNode extends StatefulWidget {
  const _KlpJsonNode({
    required this.value,
    required this.path,
    required this.depth,
    required this.defaultDepth,
    required this.expandedPaths,
    required this.onCopyPath,
    this.name,
  });

  final Object? value;
  final String? name;
  final String path;
  final int depth;
  final int defaultDepth;
  final Set<String> expandedPaths;
  final ValueChanged<String>? onCopyPath;

  @override
  State<_KlpJsonNode> createState() => _KlpJsonNodeState();
}
