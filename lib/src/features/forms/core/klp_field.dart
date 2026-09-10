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
		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpRow(
					children: [
						KlpExpanded(
							child: KlpRow(
								children: [
									KlpFieldLabel(label: label),
									if (required) ...[
										const KlpGap.widthSize(KlpSpaceSize.tight),
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
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpFieldDescription(description: description!),
				],
				const KlpGap.heightSize(KlpSpaceSize.tight),
				child,
				if (error != null || status != null || counter != null) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpRow(
						children: [
							if (error != null)
								KlpExpanded(
									child: KlpRow(
										children: [
											const KlpText(
												'× ',
												role: KlpTextRole.caption,
												tone: KlpTextTone.danger,
											),
											KlpExpanded(
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
								KlpExpanded(
									child: KlpText(
										status!,
										role: KlpTextRole.caption,
										tone: KlpTextTone.muted,
									),
								)
							else
								const KlpSpacer(),
							if (errorCode != null) ...[
								const KlpGap.widthSize(KlpSpaceSize.contentInline),
								KlpText(
									errorCode!,
									role: KlpTextRole.code,
									tone: KlpTextTone.danger,
								),
							],
							if (counter != null) ...[
								const KlpGap.widthSize(KlpSpaceSize.contentInline),
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
