import '../internal/klp_form_dependencies.dart';

/// 單獨呈現的欄位錯誤文字，包了 Kallopis live region，讓螢幕
/// 報讀器在錯誤出現時主動唸出來，不需要使用者手動聚焦。
///
/// [KlpField] 的內建錯誤列沒有這層 live region 包裝；需要非同步驗證結果
/// 出現時立即被報讀器感知，才需要在 [KlpField] 之外單獨用它。
class KlpFieldError extends StatelessWidget {
  const KlpFieldError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return KlpLiveRegion.fromDescendants(
      child: KlpText(
        error,
        role: KlpTextRole.caption,
        tone: KlpTextTone.danger,
      ),
    );
  }
}
