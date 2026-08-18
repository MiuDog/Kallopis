import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

class KlpDivider extends StatelessWidget {
  const KlpDivider({super.key, this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: vertical ? context.klp.shape.stroke : double.infinity,
      height: vertical ? double.infinity : context.klp.shape.stroke,
      child: ColoredBox(color: context.klpColors.divider),
    );
  }
}
