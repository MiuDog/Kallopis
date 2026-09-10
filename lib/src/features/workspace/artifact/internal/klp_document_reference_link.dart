part of '../klp_artifact_workspace.dart';

/// 指向另一個 canonical artifact 的可及性連結。
class KlpDocumentReferenceLink extends StatelessWidget {
  const KlpDocumentReferenceLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.detail,
  });

  final String label;
  final String? detail;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _KlpDocumentReferenceSemantics(
      child: KlpButton(
        label: detail == null ? label : '$label · $detail',
        tone: KlpButtonTone.ghost,
        compact: true,
        onPressed: onPressed,
      ),
    );
  }
}
