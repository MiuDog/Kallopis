import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

class KlpDivider extends StatelessWidget {
  const KlpDivider({super.key, this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: vertical ? KlpLine.width : double.infinity,
      height: vertical ? double.infinity : KlpLine.width,
      child: ColoredBox(color: context.plnTheme.divider),
    );
  }
}
