import 'package:flutter/material.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';

part 'primitives/klp_stage_tab_frame.dart';

/// 顯示目前 Stage 項目的單一檔案分頁。
class KlpStageTab extends StatelessWidget {
  const KlpStageTab({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _KlpStageTabFrame(
      child: KlpText(
        label,
        role: KlpTextRole.header,
        decoration: TextDecoration.none,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
