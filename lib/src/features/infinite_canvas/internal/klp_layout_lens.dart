part of '../klp_canvas_workspace.dart';

/// 顯示 layout、size、padding、gap 與 parent 關係，不推導文件狀態。
class KlpLayoutLens extends StatelessWidget {
  const KlpLayoutLens({
    super.key,
    required this.label,
    required this.diagnostics,
  });

  final String label;
  final List<KlpLayoutDiagnosticData> diagnostics;

  @override
  Widget build(BuildContext context) {
    return _KlpLayoutLensSemantics(
      label: label,
      child: KlpBox(
        tone: KlpSurfaceTone.raised,
        paddingSize: KlpSpaceSize.contentInset,
        child: KlpColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in diagnostics) ...[
              KlpRow(
                children: [
                  KlpExpanded(
                    child: KlpText(
                      item.label,
                      role: KlpTextRole.code,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                  KlpBadge(label: item.value, tone: item.tone),
                ],
              ),
              const KlpGap.heightSize(KlpSpaceSize.tight),
            ],
          ],
        ),
      ),
    );
  }
}
