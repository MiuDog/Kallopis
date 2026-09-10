import '../internal/klp_form_dependencies.dart';

/// 表單頂部的錯誤總覽卡片，把所有驗證失敗的欄位集中列成清單。
///
/// [errors] 的 key 是欄位識別碼、value 是要顯示的錯誤文字；點擊某一項會透過
/// [onSelected] 回報該欄位的 key，呼叫端通常用它把焦點捲動或移到對應欄位。
/// 不會反查欄位在畫面上的位置——[KlpForm] 之類的容器也不知道每個欄位的
/// GlobalKey，捲動與聚焦的實作留給呼叫端。
class KlpFormErrorSummary extends StatelessWidget {
  const KlpFormErrorSummary({
    super.key,
    required this.title,
    required this.errors,
    this.onSelected,
  });

  final String title;
  final Map<String, String> errors;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      child: KlpBox(
        paddingSize: KlpSpaceSize.base,
        child: KlpColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpText(
              title,
              role: KlpTextRole.bodyStrong,
              tone: KlpTextTone.danger,
            ),
            const KlpGap.heightSize(KlpSpaceSize.tight),
            for (final error in errors.entries)
              KlpGestureRegion(
                behavior: HitTestBehavior.opaque,
                onTap: onSelected == null ? null : () => onSelected!(error.key),
                child: KlpBox(
                  insets: KlpBoxInsets.directional(
                    top: context.klp.space.tight,
                    bottom: context.klp.space.tight,
                  ),
                  child: KlpText(
                    error.value,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.danger,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
