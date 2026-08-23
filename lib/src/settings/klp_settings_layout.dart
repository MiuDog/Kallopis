import 'package:flutter/widgets.dart';

import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 設定頁的自適應雙 pane 版面。
///
/// 只安排 navigation 與 content；route、Popup 與設定狀態由產品層負責。
class KlpSettingsPage extends StatelessWidget {
  const KlpSettingsPage({
    super.key,
    required this.navigation,
    required this.content,
    this.navigationWidth,
    this.twoColumnBreakpoint,
  });

  final Widget navigation;
  final Widget content;

  /// `null` 時使用 theme 的 primary pane 寬度。
  final double? navigationWidth;

  /// `null` 時使用 theme 的 primary pane content breakpoint。
  final double? twoColumnBreakpoint;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >=
            (twoColumnBreakpoint ??
                klp.geometry.layout.primaryPaneContentBreakpoint);
        if (wide) {
          return Row(
            key: const ValueKey('klp-settings-two-column'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: navigationWidth ?? klp.geometry.layout.primaryPaneWidth,
                child: navigation,
              ),
              SizedBox(width: klp.space.base),
              Expanded(child: content),
            ],
          );
        }

        return Column(
          key: const ValueKey('klp-settings-single-column'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(flex: 2, child: navigation),
            SizedBox(height: klp.space.base),
            Expanded(flex: 3, child: content),
          ],
        );
      },
    );
  }
}

/// 設定導覽 pane 的預設表面、內距與捲動行為。
class KlpSettingsNavigationPane extends StatelessWidget {
  const KlpSettingsNavigationPane({
    super.key,
    required this.children,
    this.header,
    this.controller,
  });

  final Widget? header;
  final List<Widget> children;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: KlpSurfaceTone.base,
      radius: klp.shape.panel,
      child: SingleChildScrollView(
        controller: controller,
        padding: EdgeInsets.all(klp.space.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) ...[
              header!,
              SizedBox(height: klp.space.compact),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.all(klp.space.comfortable),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: klp.geometry.layout.settingsContentMaximumWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: KlpText(title, role: KlpTextRole.title),
                          ),
                          if (trailing != null) ...[
                            SizedBox(width: klp.space.base),
                            trailing!,
                          ],
                        ],
                      ),
                      if (description != null) ...[
                        SizedBox(height: klp.space.tight),
                        KlpText(description!, tone: KlpTextTone.muted),
                      ],
                      SizedBox(height: klp.space.comfortable),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
          ?footer,
        ],
      ),
    );
  }
}
