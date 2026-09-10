part of '../klp_artifact_workspace.dart';

/// 文件的單一語意章節；可選的動作不改變章節資料所有權。
class KlpDocumentSection extends StatelessWidget {
  const KlpDocumentSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.actions = const [],
  });

  final String title;
  final String? description;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return _KlpDocumentSectionSemantics(
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpRow(
            children: [
              KlpExpanded(child: KlpText(title, role: KlpTextRole.bodyStrong)),
              if (actions.isNotEmpty)
                KlpWrap(spacingSize: KlpSpaceSize.tight, children: actions),
            ],
          ),
          if (description case final description?) ...[
            const KlpGap.heightSize(KlpSpaceSize.tight),
            KlpText(
              description,
              role: KlpTextRole.sub,
              tone: KlpTextTone.muted,
            ),
          ],
          const KlpGap.heightSize(KlpSpaceSize.contentStack),
          child,
        ],
      ),
    );
  }
}
