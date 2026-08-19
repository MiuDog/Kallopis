import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import '../surface/klp_stroke.dart';
import '../surface/klp_surface.dart';

class KlpDropTarget extends StatelessWidget {
  const KlpDropTarget({super.key, required this.child, required this.active});

  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final content = KlpSurface(
      tone: active ? KlpSurfaceTone.muted : KlpSurfaceTone.transparent,
      child: child,
    );

    return active
        ? KlpStrokeFrame(role: KlpStrokeRole.latent, child: content)
        : content;
  }
}

class KlpDragPreview extends StatelessWidget {
  const KlpDragPreview({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.82,
      child: KlpSurface(
        tone: KlpSurfaceTone.component,
        padding: EdgeInsets.all(context.klp.space.compact),
        child: child,
      ),
    );
  }
}

class KlpDropIndicator extends StatelessWidget {
  const KlpDropIndicator({super.key, this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? context.klp.shape.stroke : double.infinity,
      height: vertical ? double.infinity : context.klp.shape.stroke,
      decoration: BoxDecoration(
        color: context.klpColors.interaction,
        borderRadius: BorderRadius.circular(context.klp.shape.pill),
      ),
    );
  }
}
