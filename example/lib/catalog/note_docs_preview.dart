part of 'note_docs_demo.dart';

class _DocsBlockPreview extends StatefulWidget {
  const _DocsBlockPreview({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.child,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final Widget child;

  @override
  State<_DocsBlockPreview> createState() => _DocsBlockPreviewState();
}

class _DocsBlockPreviewState extends State<_DocsBlockPreview> {
  final _menuController = KlpContextMenuController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.klp.space.itemGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpText(
            widget.label,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
          SizedBox(height: context.klp.space.tight),
          KlpContextMenu(
            controller: _menuController,
            label: 'Block actions',
            items: [
              KlpMenuItemData(
                label: 'Duplicate',
                icon: KlpIcons.clipboard,
                onPressed: widget.onPressed,
              ),
              KlpMenuItemData(
                label: 'Turn into',
                icon: KlpIcons.switchVertical,
                onPressed: widget.onPressed,
              ),
              KlpMenuItemData(
                label: 'Delete',
                icon: KlpIcons.trash,
                danger: true,
                separatedBefore: true,
                onPressed: widget.onPressed,
              ),
            ],
            child: KlpBlock(
              selected: widget.selected,
              semanticLabel: widget.label,
              handleLabel: '${widget.label} actions',
              onHandlePressed: _menuController.openAt,
              onPressed: widget.onPressed,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
