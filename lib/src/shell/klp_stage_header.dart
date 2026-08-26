import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

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
    this.wrapTitle = false,
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space.base),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: KlpText(
                        projectName,
                        role: KlpTextRole.code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: space.tight),
                    const KlpText(
                      '/',
                      role: KlpTextRole.code,
                      tone: KlpTextTone.faint,
                    ),
                    SizedBox(width: space.tight),
                    KlpText(sectionLabel, role: KlpTextRole.code),
                  ],
                ),
                SizedBox(height: space.hairline),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: KlpText(
                              title,
                              role: KlpTextRole.bodyStrong,
                              maxLines: wrapTitle ? null : 1,
                              overflow: wrapTitle
                                  ? TextOverflow.clip
                                  : TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: space.compact),
                          KlpText(
                            typeLabel,
                            role: KlpTextRole.code,
                            tone: KlpTextTone.faint,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    // Actions 屬於**標題列**，不是整個 header。
                    //
                    // 放在 header 最外層 Row 時，它們會對齊「路徑列＋標題列」的整體中線，
                    // 因而佔用上方路徑列的空間，且標題換行時會跟著往下飄
                    // ——按鈕位置變成取決於標題有多長。
                    for (final action in actions) ...[
                      SizedBox(width: space.tight),
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
