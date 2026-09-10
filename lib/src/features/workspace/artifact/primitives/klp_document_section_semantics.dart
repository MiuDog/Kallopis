part of '../klp_artifact_workspace.dart';

class _KlpDocumentSectionSemantics extends StatelessWidget {
  const _KlpDocumentSectionSemantics({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(header: true, container: true, child: child);
  }
}
