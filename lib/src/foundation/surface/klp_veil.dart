import 'package:flutter/widgets.dart';

import '../../styling/legacy_theme/klp_theme.dart';

/// 以目前 surface 語意建立阻擋內容的半透明覆層。
class KlpVeil extends StatelessWidget {
  const KlpVeil({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final opacity = context.klp.surface.veilOpacity;
    final background = context.klp.isDark
        ? tokens.stageSurface
        : tokens.surface;

    return ColoredBox(
      color: background.withValues(alpha: opacity),
      child: child,
    );
  }
}
