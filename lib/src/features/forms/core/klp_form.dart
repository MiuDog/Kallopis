import '../internal/klp_form_dependencies.dart';

/// 整份表單的最外層版面：錯誤總覽、各個區塊（[sections]）與底部動作列
/// 依序排列，各區塊之間插入固定間距。
///
/// 不管理欄位資料或驗證邏輯——[sections] 由呼叫端組好（通常是多個
/// [KlpFormSection]），[errorSummary] 通常放 [KlpFormErrorSummary]，
/// [actions] 通常放 [KlpFormActions]。三者皆為可選，缺席時不佔版位。
class KlpForm extends StatelessWidget {
	const KlpForm({
		super.key,
		required this.sections,
		this.errorSummary,
		this.actions,
	});

	final List<Widget> sections;
	final Widget? errorSummary;
	final Widget? actions;

	@override
	Widget build(BuildContext context) {
		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				if (errorSummary != null) ...[
					errorSummary!,
					const KlpGap.heightSize(KlpSpaceSize.base),
				],
				for (var index = 0; index < sections.length; index++) ...[
					sections[index],
					if (index < sections.length - 1)
						const KlpGap.heightSize(KlpSpaceSize.comfortable),
				],
				if (actions != null) ...[
					const KlpGap.heightSize(KlpSpaceSize.comfortable),
					actions!,
				],
			],
		);
	}
}
