part of '../klp_page_chrome.dart';

/// 頁面頂部的識別區塊：麵包屑導覽、選填的狀態文字與協作者標記，以及頁面
/// 大標題。
///
/// [breadcrumb] 以 `/` 串接顯示，不提供逐段可點擊的導覽——需要可點擊麵包屑
/// 請改用 [KlpBreadcrumb]。[status] 與 [collaborator] 都是單一文字，若要顯示
/// 多位協作者或多筆狀態，需自行組合字串或改用其他元件。
class KlpPageChrome extends StatelessWidget {
  const KlpPageChrome({
    super.key,
    required this.breadcrumb,
    required this.title,
    this.status,
    this.collaborator,
  });

  final List<String> breadcrumb;
  final String title;
  final String? status;
  final String? collaborator;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return KlpBox(
      tone: KlpSurfaceTone.component,
      paddingSize: KlpSpaceSize.comfortable,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpWrap(
            spacingSize: KlpSpaceSize.tight,
            runSpacingSize: KlpSpaceSize.tight,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              KlpText(
                breadcrumb.join(' / '),
                role: KlpTextRole.code,
                tone: KlpTextTone.muted,
              ),
              if (status != null) ...[
                KlpText('•', color: tokens.text),
                KlpText(
                  status!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ],
              if (collaborator != null) KlpBadge(label: collaborator!),
            ],
          ),
          const KlpGap.base(),
          KlpText(title, role: KlpTextRole.display),
        ],
      ),
    );
  }
}
