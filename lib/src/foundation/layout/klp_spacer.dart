import 'package:flutter/widgets.dart';

/// 彈性留白排版原語。取代 Spacer。
class KlpSpacer extends StatelessWidget {
  const KlpSpacer({
    super.key,
    this.flex = 1,
  });

  final int flex;

  @override
  Widget build(BuildContext context) {
    return Spacer(flex: flex);
  }
}
