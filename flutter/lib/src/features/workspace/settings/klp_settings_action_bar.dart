import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/layout/klp_box.dart';
import 'package:kallopis/src/foundation/layout/klp_box_insets.dart';
import 'package:kallopis/src/foundation/layout/klp_expanded.dart';
import 'package:kallopis/src/foundation/layout/klp_flexible.dart';
import 'package:kallopis/src/foundation/layout/klp_row.dart';
import 'package:kallopis/src/foundation/layout/klp_space_size.dart';
import 'package:kallopis/src/foundation/layout/klp_wrap.dart';
import 'package:kallopis/src/foundation/surface/klp_surface.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';

/// 固定於設定內容捲動區外的狀態與動作列。
class KlpSettingsActionBar extends StatelessWidget {
  const KlpSettingsActionBar({
    super.key,
    required this.message,
    required this.actions,
    this.tone = KlpTextTone.muted,
  });

  final String message;
  final KlpTextTone tone;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpBox(
      insets: KlpBoxInsets.directional(
        start: klp.space.comfortable,
        top: klp.space.tight,
        end: klp.space.comfortable,
        bottom: klp.space.comfortable,
      ),
      child: KlpSurface(
        tone: KlpSurfaceTone.overlay,
        child: KlpBox(
          insets: KlpBoxInsets.uniform(klp.space.contentInset),
          child: KlpRow(
            children: [
              KlpExpanded(
                child: KlpText(
                  message,
                  role: KlpTextRole.bodyStrong,
                  tone: tone,
                ),
              ),
              KlpBox(width: klp.space.actionGap),
              KlpFlexible(
                child: KlpWrap(
                  alignment: WrapAlignment.end,
                  spacingSize: KlpSpaceSize.tight,
                  runSpacingSize: KlpSpaceSize.tight,
                  children: actions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
