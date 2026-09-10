import 'package:flutter/widgets.dart';

import '../../../foundation/layout/klp_box.dart';
import '../../../foundation/layout/klp_box_insets.dart';
import '../../../foundation/layout/klp_column.dart';
import '../../../foundation/surface/klp_surface.dart';
import '../../../styling/legacy_theme/klp_theme.dart';
import '../../../foundation/content/klp_text.dart';

export 'klp_settings_action_bar.dart';

/// 設定欄位的標題、說明、控制項與 deep-link 定位表面。
class KlpSettingsField extends StatelessWidget {
	const KlpSettingsField({
		super.key,
		required this.title,
		required this.child,
		this.description,
		this.highlighted = false,
	});

	final String title;
	final String? description;
	final Widget child;
	final bool highlighted;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return KlpSurface(
			tone: highlighted ? KlpSurfaceTone.muted : KlpSurfaceTone.transparent,
			child: KlpBox(
				insets: KlpBoxInsets.uniform(klp.space.tight),
				child: KlpColumn(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						KlpText(title, role: KlpTextRole.section),
						if (description != null) ...[
							KlpBox(height: klp.space.tight),
							KlpText(description!, tone: KlpTextTone.muted),
						],
						KlpBox(height: klp.space.contentStackGap),
						child,
					],
				),
			),
		);
	}
}
