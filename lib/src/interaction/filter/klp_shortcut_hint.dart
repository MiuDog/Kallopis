import 'package:flutter/widgets.dart';

import '../../surface/klp_surface.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';

/// 鍵盤快捷鍵提示標籤。
class KlpShortcutHint extends StatelessWidget {
	const KlpShortcutHint({super.key, required this.label});

	final String label;

	@override
	Widget build(BuildContext context) => KlpSurface(
		tone: KlpSurfaceTone.muted,
		radius: context.klp.shape.control,
		padding: EdgeInsets.symmetric(
			horizontal: context.klp.space.tight,
			vertical: context.klp.space.hairline,
		),
		child: KlpText(label, role: KlpTextRole.code, tone: KlpTextTone.muted),
	);
}
