import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../layout/klp_layout.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// Settings modal 的桌面框架；尺寸、置中與透明 Dialog chrome 全由 Kallopis 管理。
class KlpSettingsDialog extends StatelessWidget {
  const KlpSettingsDialog({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final screen = MediaQuery.sizeOf(context);
    final inset = klp.space.section;
    final width = math.min(
      klp.geometry.layout.settingsDialogMaximumWidth,
      math.max(0.0, screen.width - inset * 2),
    );
    final height = math.min(
      klp.geometry.layout.settingsDialogMaximumHeight,
      math.max(0.0, screen.height - inset * 2),
    );

    return Dialog(
      backgroundColor: klp.color.clear,
      shadowColor: klp.color.clear,
      elevation: 0,
      insetPadding: EdgeInsets.all(inset),
      child: SizedBox(
        key: const ValueKey('klp-settings-dialog-frame'),
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}

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
    this.onNavigationWidthChanged,
    this.navigationResizeLabel,
  });

  final Widget navigation;
  final Widget content;

  /// `null` 時使用 theme 的 settings navigation 寬度。
  final double? navigationWidth;

  /// `null` 時使用 theme 的 primary pane content breakpoint。
  final double? twoColumnBreakpoint;

  /// 非 `null` 時寬版導覽欄可拖曳調整；寬度狀態由消費者持有。
  final ValueChanged<double>? onNavigationWidthChanged;

  /// 導覽欄拖曳把手的無障礙標籤。
  final String? navigationResizeLabel;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    final layout = klp.geometry.layout;
    final effectiveNavigationWidth =
        (navigationWidth ?? layout.settingsNavigationWidth)
            .clamp(
              layout.settingsNavigationMinimumWidth,
              layout.settingsNavigationMaximumWidth,
            )
            .toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >=
            (twoColumnBreakpoint ?? layout.primaryPaneContentBreakpoint);
        if (wide) {
          return Row(
            key: const ValueKey('klp-settings-two-column'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: effectiveNavigationWidth, child: navigation),
              if (onNavigationWidthChanged != null)
                SizedBox(
                  width: layout.settingsPaneGap,
                  child: KlpResizeHandle(
                    width: layout.settingsPaneGap,
                    semanticLabel: navigationResizeLabel,
                    onDelta: (delta) {
                      onNavigationWidthChanged!(
                        (effectiveNavigationWidth + delta)
                            .clamp(
                              layout.settingsNavigationMinimumWidth,
                              layout.settingsNavigationMaximumWidth,
                            )
                            .toDouble(),
                      );
                    },
                  ),
                )
              else
                SizedBox(width: layout.settingsPaneGap),
              Expanded(child: content),
            ],
          );
        }

        return Column(
          key: const ValueKey('klp-settings-single-column'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(flex: 2, child: navigation),
            SizedBox(height: layout.settingsPaneGap),
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
		final tone = klp.byBrightness(light: KlpSurfaceTone.base, dark: KlpSurfaceTone.component);

    return KlpSurface(
			tone: tone,
      radius: klp.shape.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null)
            Padding(padding: EdgeInsets.all(klp.space.tight), child: header!),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.fromLTRB(
                klp.space.tight,
                header == null ? klp.space.tight : 0,
                klp.space.tight,
                klp.space.tight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.fromLTRB(
                    klp.space.comfortable,
                    klp.space.sectionLarge,
                    klp.space.comfortable,
                    klp.space.section,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            klp.geometry.layout.settingsContentMaximumWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          KlpSettingsContentHeader(
                            title: title,
                            description: description,
                          ),
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
          if (trailing != null)
            PositionedDirectional(
              top: klp.space.tight,
              end: klp.space.compact,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

/// Settings 右欄的固定標題組合，可單獨用於自訂內容 pane。
class KlpSettingsContentHeader extends StatelessWidget {
  const KlpSettingsContentHeader({
    super.key,
    required this.title,
    this.description,
    this.trailing,
  });

  final String title;
  final String? description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: KlpText(title, role: KlpTextRole.h1)),
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
      ],
    );
  }
}
