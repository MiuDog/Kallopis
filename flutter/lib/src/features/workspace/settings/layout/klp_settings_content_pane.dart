part of '../klp_settings_layout.dart';

/// 設定內容 pane；內容可捲動，footer 固定於捲動區外。
class KlpSettingsContentPane extends StatelessWidget {
  const KlpSettingsContentPane({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.trailing,
    this.footer,
    this.controller,
  });

  final String title;
  final String? description;
  final Widget child;
  final Widget? trailing;
  final Widget? footer;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: KlpSurfaceTone.raised,
      radius: klp.shape.panel,
      child: KlpStack(
        fit: StackFit.expand,
        children: [
          KlpColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KlpExpanded(
                child: KlpScrollViewport(
                  controller: controller,
                  child: KlpBox(
                    insets: KlpBoxInsets.directional(
                      start: klp.space.comfortable,
                      top: klp.space.sectionLarge,
                      end: klp.space.comfortable,
                      bottom: klp.space.section,
                    ),
                    child: KlpCenter(
                      child: KlpConstrainedBox(
                        constraints: KlpBoxConstraints(
                          maxWidth:
                              klp.geometry.layout.settingsContentMaximumWidth,
                        ),
                        child: KlpColumn(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            KlpSettingsContentHeader(
                              title: title,
                              description: description,
                            ),
                            KlpBox(height: klp.space.comfortable),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ?footer,
            ],
          ),
          if (trailing != null)
            KlpDirectionalPositioned(
              position: KlpDirectionalPosition(
                top: klp.space.tight,
                end: klp.space.contentInset,
              ),
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
