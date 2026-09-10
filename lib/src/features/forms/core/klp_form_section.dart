import '../internal/klp_form_dependencies.dart';

/// 表單中的一個可摺疊分組，帶標題、選填說明與一組欄位。
///
/// [collapsed] 與 [onToggle] 由呼叫端持有狀態——這個元件本身不記憶展開與否，
/// 純粹依 [collapsed] 決定要不要畫出 [children]。標題整列可點擊觸發
/// [onToggle]，即使 [onToggle] 為 null 也一樣可安全點擊（等同無反應）。
class KlpFormSection extends StatelessWidget {
  const KlpFormSection({
    super.key,
    required this.title,
    required this.children,
    this.description,
    this.collapsed = false,
    this.onToggle,
  });

  final String title;
  final String? description;
  final List<Widget> children;
  final bool collapsed;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      child: KlpBox(
        paddingSize: KlpSpaceSize.comfortable,
        child: KlpColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpGestureRegion(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: KlpText(title, role: KlpTextRole.section),
            ),
            if (description != null) ...[
              const KlpGap.heightSize(KlpSpaceSize.tight),
              KlpText(
                description!,
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
            ],
            if (!collapsed)
              for (final child in children) ...[
                const KlpGap.heightSize(KlpSpaceSize.base),
                child,
              ],
          ],
        ),
      ),
    );
  }
}
