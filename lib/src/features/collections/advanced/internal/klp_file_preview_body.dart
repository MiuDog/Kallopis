part of '../klp_advanced_data.dart';

class _KlpFilePreviewBody extends StatelessWidget {
  const _KlpFilePreviewBody({
    required this.state,
    required this.extension,
    required this.preview,
    required this.textContent,
    required this.labels,
  });

  final KlpFilePreviewState state;
  final String extension;
  final Widget? preview;
  final String? textContent;
  final KlpLocalizations labels;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      KlpFilePreviewState.loading => KlpColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          const KlpGeometricSpinner(),
          const KlpGap.base(),
          KlpText(
            labels.filePreviewLoadingLabel,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
        ],
      ),
      KlpFilePreviewState.error => KlpText(
        labels.filePreviewErrorLabel,
        role: KlpTextRole.caption,
        tone: KlpTextTone.danger,
      ),
      KlpFilePreviewState.unsupported => KlpColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(extension, role: KlpTextRole.title),
          const KlpGap.tight(),
          KlpText(
            labels.filePreviewUnsupportedLabel,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
        ],
      ),
      KlpFilePreviewState.ready => _readyBody(),
    };
  }

  Widget _readyBody() {
    if (preview != null) return preview!;
    if (textContent == null) {
      return KlpText(
        labels.filePreviewEmptyLabel,
        role: KlpTextRole.caption,
        tone: KlpTextTone.muted,
      );
    }

    return KlpBox(
      paddingSize: KlpSpaceSize.base,
      child: KlpAlign(
        alignment: Alignment.topLeft,
        child: KlpText(textContent!, role: KlpTextRole.code),
      ),
    );
  }
}
