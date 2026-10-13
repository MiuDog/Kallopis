part of '../klp_file_dropzone_field.dart';

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
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        KlpStructuredFrame(
          style: KlpStructuredFrameStyle.dropzone(context),
          child: KlpColumn(
            children: [
              KlpGestureRegion(
                behavior: HitTestBehavior.opaque,
                onTap: onChoose,
                child: KlpStructuredFrame(
                  style: KlpStructuredFrameStyle.fileChoose(context),
                  child: KlpText(chooseButtonLabel, role: KlpTextRole.caption),
                ),
              ),
              if (hint != null) ...[
                const KlpGap.heightSize(KlpSpaceSize.tight),
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
          const KlpGap.heightSize(KlpSpaceSize.tight),
          for (var index = 0; index < files.length; index++) ...[
            KlpStructuredFrame(
              style: KlpStructuredFrameStyle.fileAttachment(context),
              child: KlpColumn(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KlpRow(
                    children: [
                      KlpExpanded(
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
                      const KlpGap.widthSize(KlpSpaceSize.contentInline),
                      KlpGestureRegion(
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
                    const KlpGap.heightSize(KlpSpaceSize.tight),
                    KlpRow(
                      children: [
                        KlpExpanded(
                          child: _KlpFileProgressTrack(
                            value: files[index].progress!,
                          ),
                        ),
                        const KlpGap.widthSize(KlpSpaceSize.contentInline),
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
            if (index < files.length - 1)
              const KlpGap.heightSize(KlpSpaceSize.tight),
          ],
        ],
      ],
    );
  }
}
