import '../internal/klp_form_dependencies.dart';

/// 欄位輔助說明文字，統一使用低對比（[KlpTextTone.muted]）的
/// [KlpTextRole.caption] 樣式。
///
/// [KlpField] 內部就是用它畫 `description`——需要在 [KlpField] 版面之外
/// 單獨放一段樣式一致的欄位說明時才需要直接用它。
class KlpFieldDescription extends StatelessWidget {
  const KlpFieldDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return KlpText(
      description,
      role: KlpTextRole.caption,
      tone: KlpTextTone.muted,
    );
  }
}
