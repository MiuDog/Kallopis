import '../internal/klp_form_dependencies.dart';

/// 欄位標籤文字，統一使用 [KlpTextRole.caption] 樣式。
///
/// [KlpField] 內部就是用它畫標籤——需要在 [KlpField] 版面之外單獨放一個
/// 樣式一致的欄位標籤時（例如自訂版面）才需要直接用它。
class KlpFieldLabel extends StatelessWidget {
	const KlpFieldLabel({super.key, required this.label});

	final String label;

	@override
	Widget build(BuildContext context) {
		return KlpText(label, role: KlpTextRole.caption);
	}
}
