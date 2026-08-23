import 'package:flutter/widgets.dart';

import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 設定欄位的標題、說明、控制項與 deep-link 定位表面。
class KlpSettingsField extends StatelessWidget {
  const KlpSettingsField({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.highlighted = false,
  });

  final String title;
  final String? description;
  final Widget child;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: highlighted ? KlpSurfaceTone.muted : KlpSurfaceTone.transparent,
      padding: EdgeInsets.all(klp.space.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpText(title, role: KlpTextRole.section),
          if (description != null) ...[
            SizedBox(height: klp.space.tight),
            KlpText(description!, tone: KlpTextTone.muted),
          ],
          SizedBox(height: klp.space.base),
          child,
        ],
      ),
    );
  }
}

/// 固定於設定內容捲動區外的狀態與動作列。
///
/// 此元件只負責呈現；dirty／saving／failure 等狀態機由消費者決定。
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

    return Padding(
      padding: EdgeInsets.fromLTRB(
        klp.space.comfortable,
        klp.space.tight,
        klp.space.comfortable,
        klp.space.comfortable,
      ),
      child: KlpSurface(
        tone: KlpSurfaceTone.overlay,
        padding: EdgeInsets.all(klp.space.compact),
        child: Row(
          children: [
            Expanded(
              child: KlpText(message, role: KlpTextRole.bodyStrong, tone: tone),
            ),
            SizedBox(width: klp.space.compact),
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: klp.space.tight,
                runSpacing: klp.space.tight,
                children: actions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
