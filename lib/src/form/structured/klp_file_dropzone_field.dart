import '../internal/klp_form_dependencies.dart';

/// 檔案附件資料。包含檔名、檔案大小與可選的上傳進度 (0.0~1.0)。
@immutable
class KlpFileAttachment {
	const KlpFileAttachment({
		required this.name,
		required this.size,
		this.progress,
	});

	final String name;
	final String size;
	final double? progress;
}
/// 檔案上傳拖曳區與附件清單元件。
class KlpFileDropzoneField extends StatelessWidget {
	const KlpFileDropzoneField({
		super.key,
		required this.label,
		this.hint,
		this.chooseButtonLabel = 'Choose files',
		required this.files,
		this.onChoose,
		this.onRemove,
	});

	final String label;
	final String? hint;
	final String chooseButtonLabel;
	final List<KlpFileAttachment> files;
	final VoidCallback? onChoose;
	final ValueChanged<int>? onRemove;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final klp = context.klp;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				SizedBox(height: klp.space.tight),
				Container(
					padding: EdgeInsets.all(klp.space.base),
					decoration: BoxDecoration(
						color: tokens.surfaceInset,
						borderRadius: BorderRadius.circular(klp.shape.card),
						border: Border.all(color: tokens.border, width: klp.shape.hairline),
					),
					child: Column(
						children: [
							GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: onChoose,
								child: Container(
									padding: EdgeInsets.symmetric(
										horizontal: klp.space.base,
										vertical: klp.space.controlInset,
									),
									decoration: BoxDecoration(
										color: tokens.component,
										borderRadius: BorderRadius.circular(klp.shape.control),
										border: Border.all(
											color: tokens.border,
											width: klp.shape.hairline,
										),
									),
									child: KlpText(chooseButtonLabel, role: KlpTextRole.caption),
								),
							),
							if (hint != null) ...[
								SizedBox(height: klp.space.tight),
								KlpText(
									hint!,
									role: KlpTextRole.caption,
									tone: KlpTextTone.muted,
								),
							],
						],
					),
				),
				if (files.isNotEmpty) ...[
					SizedBox(height: klp.space.tight),
					for (var index = 0; index < files.length; index++) ...[
						Container(
							padding: EdgeInsets.symmetric(
								horizontal: klp.space.base,
								vertical: klp.space.contentInset,
							),
							decoration: BoxDecoration(
								color: tokens.surfaceInset,
								borderRadius: BorderRadius.circular(klp.shape.control),
							),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									Row(
										children: [
											Expanded(
												child: KlpText(
													files[index].name,
													role: KlpTextRole.code,
												),
											),
											KlpText(
												files[index].size,
												role: KlpTextRole.code,
												tone: KlpTextTone.muted,
											),
											SizedBox(width: klp.space.contentInlineGap),
											GestureDetector(
												behavior: HitTestBehavior.opaque,
												onTap: onRemove == null ? null : () => onRemove!(index),
												child: const KlpText(
													'×',
													role: KlpTextRole.caption,
													tone: KlpTextTone.muted,
												),
											),
										],
									),
									if (files[index].progress != null) ...[
										SizedBox(height: klp.space.tight),
										Row(
											children: [
												Expanded(
													child: ClipRRect(
														borderRadius: BorderRadius.circular(
															klp.shape.control,
														),
														child: Container(
															height: klp.shape.stroke,
															color: tokens.border,
															alignment: Alignment.centerLeft,
															child: FractionallySizedBox(
																widthFactor: files[index].progress,
																child: Container(color: tokens.interaction),
															),
														),
													),
												),
												SizedBox(width: klp.space.contentInlineGap),
												KlpText(
													'${(files[index].progress! * 100).toInt()}%',
													role: KlpTextRole.caption,
													tone: KlpTextTone.muted,
												),
											],
										),
									],
								],
							),
						),
						if (index < files.length - 1) SizedBox(height: klp.space.tight),
					],
				],
			],
		);
	}
}
