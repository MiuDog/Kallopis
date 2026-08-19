import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import 'klp_surface.dart';

class KlpBlock extends StatelessWidget {
  const KlpBlock({
    super.key,
    required this.child,
    this.selected = false,
    this.padding,
  });

  final Widget child;
  final bool selected;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      border: selected ? Border.all(color: context.klpColors.textMuted) : null,
      radius: context.klp.shape.control,
      padding: padding ?? EdgeInsets.all(context.klp.space.base),
      child: child,
    );
  }
}

class KlpBlockCanvas extends StatelessWidget {
  const KlpBlockCanvas({
    super.key,
    required this.children,
    this.constrained = false,
  });

  final List<Widget> children;
  final bool constrained;

  @override
  Widget build(BuildContext context) {
    final canvas = KlpSurface(
      tone: KlpSurfaceTone.inset,
      child: Stack(children: children),
    );

    return constrained ? canvas : InteractiveViewer(child: canvas);
  }
}
