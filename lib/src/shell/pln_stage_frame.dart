import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

class PlnStageFrame extends StatelessWidget {
  const PlnStageFrame({
    super.key,
    required this.header,
    required this.content,
    this.status,
  });

  final Widget header;
  final Widget content;
  final Widget? status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.plnTheme.stageSurface,
        borderRadius: BorderRadius.circular(PlnRadius.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PlnRadius.panel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: PlnSize.header, child: header),
            Expanded(child: content),
            if (status != null)
              SizedBox(height: PlnSize.statusBar, child: status!),
          ],
        ),
      ),
    );
  }
}
