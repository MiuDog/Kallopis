import 'package:flutter/material.dart';

import 'package:kallopis/src/foundation/layout/klp_column.dart';
import 'package:kallopis/src/foundation/layout/klp_expanded.dart';
import 'package:kallopis/src/foundation/surface/klp_surface.dart';

part 'primitives/klp_app_screen_material_root.dart';

/// 應用程式最外層，提供 Material 祖先與 app 背景。
class KlpAppScreen extends StatelessWidget {
  const KlpAppScreen({super.key, required this.child, this.windowHeader});

  final Widget? windowHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) => _KlpAppScreenMaterialRoot(
    child: KlpSurface(
      tone: KlpSurfaceTone.app,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?windowHeader,
          KlpExpanded(child: child),
        ],
      ),
    ),
  );
}
