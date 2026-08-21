import 'package:flutter/material.dart';

import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpThemeToggle extends StatelessWidget {
  const KlpThemeToggle({
    super.key,
    required this.label,
    required this.dark,
    required this.onChanged,
  });

  final String label;
  final bool dark;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(!dark),
      child: KlpSurface(
        tone: dark ? KlpSurfaceTone.muted : KlpSurfaceTone.inset,
        padding: EdgeInsets.all(context.klp.space.compact),
        child: KlpText(label, role: KlpTextRole.caption),
      ),
    );
  }
}
