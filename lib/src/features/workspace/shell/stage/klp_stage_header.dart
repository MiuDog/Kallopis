import 'package:flutter/widgets.dart';

import '../../../../foundation/layout/klp_layout.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';

/// Stage 頂部的兩行識別標頭。
///
/// 第一行顯示專案與區域，第二行顯示目前項目與類型；呼叫端只提供語意資料，
/// 排版、間距與文字層級一律由 Kallopis theme 決定。
class KlpStageHeader extends StatelessWidget {
  const KlpStageHeader({
    super.key,
    required this.projectName,
    required this.sectionLabel,
    required this.title,
    required this.typeLabel,
    this.actions = const [],
    this.wrapTitle = true,
  });

  final String projectName;
  final String sectionLabel;
  final String title;
  final String typeLabel;
  final List<Widget> actions;
  final bool wrapTitle;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return KlpBox(
      insets: KlpBoxInsets.directional(
        top: space.chromePanelInset,
        bottom: space.chromePanelInset,
      ),
      child: KlpRow(
        children: [
          KlpExpanded(
            child: KlpColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpRow(
                  children: [
                    KlpFlexible(
                      child: KlpText(
                        projectName,
                        role: KlpTextRole.code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const KlpGap.tight(),
                    const KlpText(
                      '/',
                      role: KlpTextRole.code,
                      tone: KlpTextTone.faint,
                    ),
                    const KlpGap.tight(),
                    KlpText(sectionLabel, role: KlpTextRole.code),
                  ],
                ),
                KlpRow(
                  children: [
                    KlpExpanded(
                      child: KlpRow(
                        children: [
                          KlpFlexible(
                            child: KlpText(
                              title,
                              role: KlpTextRole.header,
                              maxLines: wrapTitle ? null : 1,
                              overflow: wrapTitle
                                  ? TextOverflow.clip
                                  : TextOverflow.ellipsis,
                            ),
                          ),
                          const KlpGap.widthSize(KlpSpaceSize.chromeToolbar),
                          KlpText(
                            typeLabel,
                            role: KlpTextRole.code,
                            tone: KlpTextTone.faint,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    // Actions 對齊標題列，不佔用上方路徑列空間。
                    for (final action in actions) ...[
                      const KlpGap.tight(),
                      action,
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
