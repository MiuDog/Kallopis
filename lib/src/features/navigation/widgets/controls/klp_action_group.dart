import 'package:flutter/widgets.dart';

import '../../../../foundation/layout/klp_space_size.dart';
import '../../../../foundation/layout/klp_wrap.dart';

/// 一組動作按鈕的容器，寬度不足時自動換行。
class KlpActionGroup extends StatelessWidget {
  const KlpActionGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return KlpWrap(
      spacingSize: KlpSpaceSize.tight,
      runSpacingSize: KlpSpaceSize.tight,
      children: children,
    );
  }
}
