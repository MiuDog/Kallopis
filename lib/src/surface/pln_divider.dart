import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

class PlnDivider extends StatelessWidget {
  const PlnDivider({super.key, this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: vertical ? PlnLine.width : double.infinity,
      height: vertical ? double.infinity : PlnLine.width,
      child: ColoredBox(color: context.plnTheme.divider),
    );
  }
}
