import 'package:flutter/widgets.dart';

import '../../../foundation/layout/klp_space_size.dart';
import '../../../foundation/layout/klp_wrap.dart';
import '../shell/theme/klp_theme_preview_tile.dart';
import 'klp_theme_mode_option.dart';

export 'klp_theme_mode_option.dart';

/// 以 Kallopis 預覽磚排列受控的顏色模式選項。
class KlpThemeModePicker extends StatelessWidget {
	const KlpThemeModePicker({
		super.key,
		required this.options,
		required this.selected,
		required this.onSelected,
	});

	final List<KlpThemeModeOption> options;
	final KlpThemePreviewMode selected;
	final ValueChanged<KlpThemePreviewMode> onSelected;

	@override
	Widget build(BuildContext context) {
		return KlpWrap(
			spacingSize: KlpSpaceSize.base,
			runSpacingSize: KlpSpaceSize.comfortable,
			children: [
				for (final option in options)
					KlpThemePreviewTile(
						mode: option.mode,
						label: option.label,
						description: option.description,
						selected: option.mode == selected,
						enabled: option.enabled,
						onSelected: option.enabled
								? () => onSelected(option.mode)
								: null,
					),
			],
		);
	}
}
