import 'package:flutter/material.dart';

import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';

class KlpPopover extends StatelessWidget {
  const KlpPopover({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: padding ?? EdgeInsets.all(context.klp.space.compact),
      child: child,
    );
  }
}
