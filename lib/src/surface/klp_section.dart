import 'package:flutter/widgets.dart';

import '../typography/klp_text.dart';
import '../theme/klp_theme.dart';

/// 帶標題的內容分段。`label` 是標題上方的小型分類文字。
class KlpSection extends StatelessWidget {
  const KlpSection({
    super.key,
    required this.title,
    required this.child,
    this.label,
    this.trailing,
  });

  final String title;
  final String? label;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final heading = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: context.klp.space.base,
      runSpacing: context.klp.space.tight,
      children: [
        KlpText(title, role: KlpTextRole.section),
        if (label != null)
          KlpText(label!.toUpperCase(), role: KlpTextRole.label),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: heading),
            if (trailing != null) ...[
              SizedBox(width: context.klp.space.base),
              trailing!,
            ],
          ],
        ),
        SizedBox(height: context.klp.space.comfortable),
        child,
      ],
    );
  }
}
