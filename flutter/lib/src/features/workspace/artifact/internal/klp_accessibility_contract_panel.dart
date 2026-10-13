part of '../klp_artifact_workspace.dart';

/// 元件可及性合約表面，內容由產品的元件定義投影而來。
class KlpAccessibilityContractPanel extends StatelessWidget {
  const KlpAccessibilityContractPanel({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    return KlpBox(
      tone: KlpSurfaceTone.inset,
      paddingSize: KlpSpaceSize.base,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpText(title, role: KlpTextRole.bodyStrong),
          const KlpGap.heightSize(KlpSpaceSize.contentStack),
          for (final item in items.entries) ...[
            KlpRow(
              children: [
                KlpExpanded(child: KlpText(item.key, tone: KlpTextTone.muted)),
                KlpText(item.value, role: KlpTextRole.code),
              ],
            ),
            const KlpGap.heightSize(KlpSpaceSize.tight),
          ],
        ],
      ),
    );
  }
}
