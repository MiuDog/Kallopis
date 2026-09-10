import 'package:flutter/widgets.dart';

import '../../../../foundation/klp_icon.dart';
import '../../../../foundation/interaction/klp_gesture_region.dart';
import '../../../../foundation/layout/klp_gap.dart';
import '../../../../foundation/layout/klp_row.dart';
import '../../../../foundation/layout/klp_space_size.dart';
import '../../../../foundation/surface/klp_surface.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';
import 'klp_view_option.dart';

part 'internal/klp_view_choice.dart';
part 'primitives/klp_view_choice_frame.dart';
part 'primitives/klp_view_switcher_frame.dart';

/// 以輕量分段表面呈現同層級檢視的受控切換器。
class KlpViewSwitcher extends StatelessWidget {
  const KlpViewSwitcher({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final List<KlpViewOption> options;
  final String selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return _KlpViewSwitcherFrame(
      child: KlpRow(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < options.length; index++) ...[
            _KlpViewChoice(
              option: options[index],
              selected: options[index].id == selectedId,
              onPressed: onSelected == null
                  ? null
                  : () => onSelected!(options[index].id),
            ),
            if (index < options.length - 1)
              const KlpGap.widthSize(KlpSpaceSize.hairline),
          ],
        ],
      ),
    );
  }
}
