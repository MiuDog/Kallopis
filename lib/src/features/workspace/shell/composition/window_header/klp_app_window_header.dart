import 'package:flutter/material.dart';

import '../../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../../foundation/content/klp_text.dart';
import '../../panel/klp_panel_header.dart';

/// 組合 App 視窗標題列的通用配方。
class KlpAppWindowHeader extends StatelessWidget {
  const KlpAppWindowHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.klp.space.chromeHeader,
      child: KlpPanelHeader(
        title: title,
        titleRole: KlpTextRole.appTitle,
        leading: leading,
        actions: actions,
      ),
    );
  }
}
