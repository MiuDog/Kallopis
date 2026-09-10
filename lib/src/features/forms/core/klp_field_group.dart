import '../internal/klp_form_dependencies.dart';

import 'klp_field.dart';

/// 把多個相關輸入（例如一組 checkbox）當成單一 [KlpField] 呈現，用
/// [legend] 取代單一欄位的 `label`。
///
/// 內部直接委派給 [KlpField]，因此標籤／錯誤的排版與單一欄位完全一致；
/// 差別只在 `child` 換成 [children] 這組垂直排列的子項目。
class KlpFieldGroup extends StatelessWidget {
  const KlpFieldGroup({
    super.key,
    required this.legend,
    required this.children,
    this.error,
  });

  final String legend;
  final List<Widget> children;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return KlpField(
      label: legend,
      error: error,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
