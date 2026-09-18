import 'package:flutter/material.dart';

import 'package:kallopis/src/foundation/layout/klp_layout.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/features/workspace/shell/panel/klp_panel_footer.dart';

part 'primitives/klp_stage_header_slot.dart';
part 'primitives/klp_stage_status_slot.dart';
part 'primitives/klp_stage_surface.dart';

/// 舞台區：選用的頂部 header、中央 content、底部選用的 status 列。
class KlpStageFrame extends StatelessWidget {
  const KlpStageFrame({
    super.key,
    this.header,
    required this.content,
    this.status,
  });

  final Widget? header;
  final Widget content;
  final Widget? status;

  @override
  Widget build(BuildContext context) {
    return _KlpStageSurface(
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpExpanded(
            child: KlpColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) _KlpStageHeaderSlot(child: header!),
                KlpExpanded(child: content),
              ],
            ),
          ),
          if (status != null)
            _KlpStageStatusSlot(child: KlpPanelFooter(child: status!)),
        ],
      ),
    );
  }
}
