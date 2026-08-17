import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

class KlpStageFrame extends StatelessWidget {
  const KlpStageFrame({
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
        color: context.klpColors.stageSurface,
        borderRadius: BorderRadius.circular(KlpRadius.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KlpRadius.panel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: KlpSize.header, child: header),
            Expanded(child: content),
            if (status != null)
              SizedBox(height: KlpSize.statusBar, child: status!),
          ],
        ),
      ),
    );
  }
}
