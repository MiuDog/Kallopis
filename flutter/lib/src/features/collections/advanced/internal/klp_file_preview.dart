part of '../klp_advanced_data.dart';

/// 檔案預覽卡片，呈現檔名、中繼資料、預覽內容與外部操作。
class KlpFilePreview extends StatelessWidget {
  const KlpFilePreview({
    super.key,
    required this.name,
    required this.metadata,
    this.icon = KlpIcons.box,
    this.preview,
    this.onPressed,
    this.state = KlpFilePreviewState.ready,
    this.size = KlpFilePreviewSize.standard,
    this.textContent,
    this.onOpenExternal,
    this.onDownload,
  });

  final String name;
  final String metadata;
  final KlpIconData icon;
  final Widget? preview;
  final VoidCallback? onPressed;
  final KlpFilePreviewState state;
  final KlpFilePreviewSize size;
  final String? textContent;
  final VoidCallback? onOpenExternal;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final style = _KlpAdvancedStyle.from(context);
    final labels = KlpLocalizations.of(context);
    final children = <Widget>[
      _KlpFilePreviewSection(
        style: style,
        header: true,
        child: KlpRow(
          children: [
            KlpExpanded(
              child: KlpText(
                name,
                role: KlpTextRole.code,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            KlpText(metadata, role: KlpTextRole.code, tone: KlpTextTone.muted),
          ],
        ),
      ),
      const KlpDashedDivider(),
      _KlpFilePreviewViewport(
        style: style,
        size: size,
        child: _KlpFilePreviewBody(
          state: state,
          extension: _extension,
          preview: preview,
          textContent: textContent,
          labels: labels,
        ),
      ),
    ];

    if (onOpenExternal != null || onDownload != null) {
      children.add(const KlpDashedDivider());
      children.add(
        _KlpFilePreviewSection(
          style: style,
          header: false,
          child: KlpRow(children: _actionChildren(labels)),
        ),
      );
    }

    return _KlpFilePreviewFrame(
      style: style,
      onPressed: onPressed,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  String get _extension =>
      name.contains('.') ? name.split('.').last.toUpperCase() : 'FILE';

  List<Widget> _actionChildren(KlpLocalizations labels) {
    final children = <Widget>[];
    if (onOpenExternal != null) {
      children.add(
        KlpGestureRegion(
          behavior: HitTestBehavior.opaque,
          onTap: onOpenExternal,
          child: KlpText(
            labels.filePreviewOpenExternalLabel,
            role: KlpTextRole.code,
            tone: KlpTextTone.muted,
          ),
        ),
      );
    }
    if (onOpenExternal != null && onDownload != null) {
      children.add(const KlpGap.comfortable());
    }
    if (onDownload != null) {
      children.add(
        KlpGestureRegion(
          behavior: HitTestBehavior.opaque,
          onTap: onDownload,
          child: KlpText(
            labels.filePreviewDownloadLabel,
            role: KlpTextRole.code,
            tone: KlpTextTone.muted,
          ),
        ),
      );
    }

    return children;
  }
}
