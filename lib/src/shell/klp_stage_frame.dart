import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

/// 舞台區：頂部 header、中央 content、底部選用的 status 列。
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
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.klp.shape.panel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: context.klp.space.chromeHeader, child: header),
            Expanded(child: content),
            if (status != null)
              SizedBox(
                height: context.klp.space.chromeStatusBar,
                child: status!,
              ),
          ],
        ),
      ),
    );
  }
}
