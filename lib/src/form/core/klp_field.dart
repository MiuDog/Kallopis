import '../internal/klp_form_dependencies.dart';

import 'klp_field_description.dart';
import 'klp_field_label.dart';

/// 單一表單欄位的完整外框：標籤、選填說明、輸入控制項（[child]），以及
/// 底部的錯誤／狀態／字數提示列。
///
/// [error]、[status]、[counter]、[errorCode] 共用同一列版面：底部提示列只在
/// 四者至少有一個非 null 時才出現；[error] 優先於 [status]（兩者同時給只顯示
/// error），[errorCode]／[counter] 則各自靠右並存，通常放系統層級的診斷代碼
/// （例如後端回傳的驗證錯誤碼）供支援排查用，不是給一般使用者讀的文案。
/// 實際的驗證邏輯、何時算 required 都由呼叫端決定，這個元件只負責排版。
class KlpField extends StatelessWidget {
	const KlpField({
		super.key,
		required this.label,
		required this.child,
		this.description,
		this.error,
		this.errorCode,
		this.requirement,
		this.required = false,
		this.status,
		this.counter,
	});

	final String label;
	final String? description;
	final String? error;
	final String? errorCode;
	final String? requirement;
	final bool required;
	final String? status;
	final String? counter;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Row(
					children: [
						Expanded(
							child: Row(
								children: [
									KlpFieldLabel(label: label),
									if (required) ...[
										SizedBox(width: klp.space.tight),
										const KlpText(
											'*',
											role: KlpTextRole.caption,
											tone: KlpTextTone.danger,
										),
									],
								],
							),
						),
						if (requirement != null)
							KlpText(
								requirement!,
								role: KlpTextRole.caption,
								tone: KlpTextTone.faint,
							),
					],
				),
				if (description != null) ...[
					SizedBox(height: klp.space.tight),
					KlpFieldDescription(description: description!),
				],
				SizedBox(height: klp.space.tight),
				child,
				if (error != null || status != null || counter != null) ...[
					SizedBox(height: klp.space.tight),
					Row(
						children: [
							if (error != null)
								Expanded(
									child: Row(
										children: [
											const KlpText(
												'× ',
												role: KlpTextRole.caption,
												tone: KlpTextTone.danger,
											),
											Expanded(
												child: KlpText(
													error!,
													role: KlpTextRole.caption,
													tone: KlpTextTone.danger,
												),
											),
										],
									),
								)
							else if (status != null)
								Expanded(
									child: KlpText(
										status!,
										role: KlpTextRole.caption,
										tone: KlpTextTone.muted,
									),
								)
							else
								const Spacer(),
							if (errorCode != null) ...[
								SizedBox(width: klp.space.contentInlineGap),
								KlpText(
									errorCode!,
									role: KlpTextRole.code,
									tone: KlpTextTone.danger,
								),
							],
							if (counter != null) ...[
								SizedBox(width: klp.space.contentInlineGap),
								KlpText(
									counter!,
									role: KlpTextRole.code,
									tone: KlpTextTone.faint,
								),
							],
						],
					),
				],
			],
		);
	}
}
