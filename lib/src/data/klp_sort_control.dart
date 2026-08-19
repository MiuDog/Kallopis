import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpSortControl extends StatelessWidget {
  const KlpSortControl({
    super.key,
    required this.label,
    required this.ascending,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool ascending;
  final VoidCallback? onPressed;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(label, role: KlpTextRole.caption),
          if (icon != null) ...[
            SizedBox(width: context.klp.space.tight),
            KlpIcon(icon!, size: context.klp.space.iconSmall),
          ],
        ],
      ),
    );
  }
}
