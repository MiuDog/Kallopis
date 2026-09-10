part of '../klp_file_field.dart';

/// 簡易的檔案選擇欄位：一排已選檔案的預覽卡片，加一顆選擇檔案按鈕。
///
/// 不處理實際的檔案選取或上傳邏輯——[onChoose] 只是回報「使用者按了選擇」，
/// 開檔案對話框、讀取內容、上傳進度都由呼叫端接手；需要顯示上傳進度時請改用
/// [KlpFileDropzoneField]。
class KlpFileField extends StatelessWidget {
	const KlpFileField({
		super.key,
		required this.label,
		required this.files,
		required this.chooseLabel,
		this.onChoose,
		this.onRemove,
	});

	final String label;
	final List<KlpFileValue> files;
	final String chooseLabel;
	final VoidCallback? onChoose;
	final ValueChanged<String>? onRemove;

	@override
	Widget build(BuildContext context) {
		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				const KlpGap.heightSize(KlpSpaceSize.tight),
				KlpWrap(
					spacingSize: KlpSpaceSize.tight,
					runSpacingSize: KlpSpaceSize.tight,
					children: [
						for (final file in files)
							KlpFilePreview(
								name: file.name,
								metadata: file.metadata ?? '',
								onPressed: onRemove == null ? null : () => onRemove!(file.id),
							),
						KlpButton(label: chooseLabel, onPressed: onChoose),
					],
				),
			],
		);
	}
}
