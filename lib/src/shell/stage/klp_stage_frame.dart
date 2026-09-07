import 'package:flutter/material.dart';

import '../../theme/klp_theme.dart';

import '../panel/klp_panel_footer.dart';
import '../status/klp_status_bar.dart';
import '../status/klp_status_data.dart';
import 'klp_stage_header.dart';

/// 舞台區：選用的頂部 header、中央 content、底部選用的 status 列。
class KlpStageFrame extends StatelessWidget {
  const KlpStageFrame({
    super.key,
    this.header,
    required this.content,
    this.status,
    this.padding,
  });

  /// 建立具備 Kallopis 標準識別列與狀態列的工作舞台。
  ///
  /// 產品只提供語意資料與主要內容；header、status 的元件選擇、排列、間距與
  /// 響應式行為都留在 Kallopis。
  factory KlpStageFrame.workbench({
    Key? key,
    required String projectName,
    required String sectionLabel,
    required String title,
    required String typeLabel,
    required Widget content,
    KlpStatusBarData? status,
  }) {
    return KlpStageFrame(
      key: key,
      header: KlpStageHeader(
        projectName: projectName,
        sectionLabel: sectionLabel,
        title: title,
        typeLabel: typeLabel,
      ),
      content: content,
      status: status == null ? null : KlpStatusBar(data: status),
    );
  }

  final Widget? header;
  final Widget content;
  final Widget? status;

  /// 內容與舞台區之間的內距。預設為 `context.klp.space.base`。
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final background = tokens.stageSurface;
    final surfaceTokens = tokens.onBackground(background);

    return ColoredBox(
      color: background,
      child: KlpTokenOverride(
        colors: surfaceTokens,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (header != null)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: context.klp.space.chromeHeader,
                      ),
                      child: header,
                    ),
                  Expanded(child: content),
                ],
              ),
            ),
            if (status != null)
              SizedBox(
                height: context.klp.space.chromeStatusBar,
                child: KlpPanelFooter(child: status!),
              ),
          ],
        ),
      ),
    );
  }
}
