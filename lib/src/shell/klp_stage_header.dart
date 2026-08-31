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
  });

  final String projectName;
  final String sectionLabel;
  final String title;
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;
    final compact = space.compact;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact),
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
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: KlpText(title, role: KlpTextRole.bodyStrong),
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
