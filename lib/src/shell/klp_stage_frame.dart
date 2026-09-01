import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import 'klp_stage_header.dart';
import 'klp_status_bar.dart';

/// 舞台區：選用的頂部 header、中央 content、底部選用的 status 列。
class KlpStageFrame extends StatelessWidget {
  const KlpStageFrame({
    super.key,
    this.header,
    required this.content,
    this.status,
  });

  /// 建立具備 Kallopis 標準識別列與狀態列的工作舞台。
  ///
  /// 產品只提供語意資料與主要內容；header、status 的元件選擇、排列、間距與
  /// 響應式行為都留在 Kallopis。若提供狀態文字，leading 與 trailing 必須成對。
  factory KlpStageFrame.workbench({
    Key? key,
    required String projectName,
    required String sectionLabel,
    required String title,
    required String typeLabel,
    required Widget content,
    String? statusLeading,
    String? statusTrailing,
    bool statusActive = true,
  }) {
    assert(
      (statusLeading == null) == (statusTrailing == null),
      'statusLeading and statusTrailing must be provided together.',
    );
    return KlpStageFrame(
      key: key,
      header: KlpStageHeader(
        projectName: projectName,
        sectionLabel: sectionLabel,
        title: title,
        typeLabel: typeLabel,
      ),
      content: content,
      status: statusLeading == null
          ? null
          : KlpStatusBar(
              leading: statusLeading,
              trailing: statusTrailing!,
              active: statusActive,
            ),
    );
  }

  final Widget? header;
  final Widget content;
  final Widget? status;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final background = tokens.stageSurface;
    final surfaceTokens = tokens.onBackground(background);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
        child: KlpTokenOverride(
          colors: surfaceTokens,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.klp.space.compact,
            ),
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
                if (status != null)
                  SizedBox(
                    height: context.klp.space.chromeStatusBar,
                    child: status!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
