import 'package:flutter/widgets.dart';

import '../../../styling/legacy_theme/klp_theme.dart';
import '../../../foundation/content/klp_text.dart';
import 'klp_avatar_size.dart';
import 'klp_avatar_tone.dart';

export 'klp_avatar_data.dart';
export 'klp_avatar_group.dart';
export 'klp_avatar_size.dart';
export 'klp_avatar_tone.dart';

part 'primitives/klp_avatar_frame.dart';

/// 以文字或圖片呈現無產品語意的身份識別圖像。
class KlpAvatar extends StatelessWidget {
	const KlpAvatar({
		super.key,
		required this.label,
		this.image,
		this.size = KlpAvatarSize.standard,
		this.semanticLabel,
		this.tone = KlpAvatarTone.neutral,
	});

	final String label;
	final ImageProvider? image;
	final KlpAvatarSize size;
	final String? semanticLabel;
	final KlpAvatarTone tone;

	@override
	Widget build(BuildContext context) {
		return _KlpAvatarFrame(
			label: semanticLabel ?? label,
			image: image,
			size: size,
			tone: tone,
			child: image == null
					? KlpText(
							label,
							role: KlpTextRole.label,
						)
					: null,
		);
	}
}
