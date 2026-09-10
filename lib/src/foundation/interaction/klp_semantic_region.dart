import 'package:flutter/widgets.dart';

/// 將一般內容群組的可及性語意限制在基礎互動原語。
class KlpSemanticRegion extends StatelessWidget {
  const KlpSemanticRegion({
    super.key,
    required this.label,
    required this.child,
    this.value,
    this.enabled,
    this.focusable,
    this.container = true,
    this.explicitChildNodes = false,
  });

  final String label;
  final Widget child;
  final String? value;
  final bool? enabled;
  final bool? focusable;
  final bool container;
  final bool explicitChildNodes;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: container,
      explicitChildNodes: explicitChildNodes,
      label: label,
      value: value,
      enabled: enabled,
      focusable: focusable,
      child: child,
    );
  }
}
