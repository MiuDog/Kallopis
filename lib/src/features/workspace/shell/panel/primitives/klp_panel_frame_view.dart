part of '../klp_panel_frame.dart';

/// Panel 對 Flutter 裝飾、裁切、彈性排版與 scrollbar 的 primitive 邊界。
class _KlpPanelFrameView extends StatelessWidget {
  const _KlpPanelFrameView({
    required this.header,
    required this.content,
    required this.footer,
    required this.headerSize,
    required this.tone,
    required this.contentScrollController,
  });

  final Widget? header;
  final Widget content;
  final Widget? footer;
  final KlpPanelHeaderSize headerSize;
  final KlpPanelTone tone;
  final ScrollController? contentScrollController;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final background = switch (tone) {
      KlpPanelTone.surface => tokens.surface,
      KlpPanelTone.stage => tokens.stageSurface,
    };
    final headerHeight = switch (headerSize) {
      KlpPanelHeaderSize.standard => klp.space.chromeHeader,
      KlpPanelHeaderSize.dock => klp.space.chromeTab,
    };
    Widget contentRegion = content;
    final controller = contentScrollController;

    if (controller != null) {
      final scrollBehavior = ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false);
      contentRegion = ScrollbarTheme(
        data: Theme.of(context).scrollbarTheme,
        child: Scrollbar(
          controller: controller,
          child: ScrollConfiguration(behavior: scrollBehavior, child: content),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(klp.space.dockMargin),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(klp.shape.card),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            klp.shape.card - klp.shape.stroke,
          ),
          child: KlpTokenOverride(
            colors: tokens.onBackground(background),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null)
                  SizedBox(height: headerHeight, child: header),
                Expanded(child: contentRegion),
                if (footer != null)
                  SizedBox(
                    height: klp.space.chromeStatusBar,
                    child: KlpPanelFooter(child: footer!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
