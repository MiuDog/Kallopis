import 'package:flutter/material.dart';

import '../../../../foundation/surface/klp_surface.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';

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
        padding: EdgeInsets.all(context.klp.space.controlInset),
        child: KlpText(label, role: KlpTextRole.caption),
      ),
    );
  }
}
