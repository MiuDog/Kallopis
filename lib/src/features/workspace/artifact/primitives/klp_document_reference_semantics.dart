part of '../klp_artifact_workspace.dart';

class _KlpDocumentReferenceSemantics extends StatelessWidget {
  const _KlpDocumentReferenceSemantics({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(link: true, button: true, child: child);
  }
}
