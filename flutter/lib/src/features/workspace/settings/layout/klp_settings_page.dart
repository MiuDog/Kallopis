part of '../klp_settings_layout.dart';

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
    final layout = context.klp.geometry.layout;
    final effectiveNavigationWidth =
        (navigationWidth ?? layout.settingsNavigationWidth)
            .clamp(
              layout.settingsNavigationMinimumWidth,
              layout.settingsNavigationMaximumWidth,
            )
            .toDouble();

    return KlpLayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >=
            (twoColumnBreakpoint ?? layout.primaryPaneContentBreakpoint);
        if (wide) {
          return KlpRow(
            key: const ValueKey('klp-settings-two-column'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KlpBox(width: effectiveNavigationWidth, child: navigation),
              if (onNavigationWidthChanged != null)
                KlpBox(
                  width: layout.settingsPaneGap,
                  child: KlpResizeHandle(
                    axis: Axis.horizontal,
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
                KlpBox(width: layout.settingsPaneGap),
              KlpExpanded(child: content),
            ],
          );
        }

        return KlpColumn(
          key: const ValueKey('klp-settings-single-column'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpFlexible(flex: 2, child: navigation),
            KlpBox(height: layout.settingsPaneGap),
            KlpExpanded(flex: 3, child: content),
          ],
        );
      },
    );
  }
}
