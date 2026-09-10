import 'package:flutter/widgets.dart';

import '../../../foundation/layout/klp_gap.dart';
import '../../../foundation/layout/klp_row.dart';
import '../../../foundation/layout/klp_space_size.dart';
import 'klp_avatar.dart';

/// 以緊密水平排列呈現多個 Avatar，超出上限時顯示剩餘數量。
class KlpAvatarGroup extends StatelessWidget {
	const KlpAvatarGroup({
		super.key,
		required this.avatars,
		this.maximumVisible = 4,
	});

	final List<KlpAvatarData> avatars;
	final int maximumVisible;

	@override
	Widget build(BuildContext context) {
		final visible = avatars.take(maximumVisible).toList();
		final hiddenCount = avatars.length - visible.length;

		return KlpRow(
			mainAxisSize: MainAxisSize.min,
			children: [
				for (final avatar in visible) ...[
					KlpAvatar(
						label: avatar.label,
						image: avatar.image,
						size: KlpAvatarSize.small,
					),
					const KlpGap.widthSize(KlpSpaceSize.tight),
				],
				if (hiddenCount > 0)
					KlpAvatar(
						label: '+$hiddenCount',
						size: KlpAvatarSize.small,
					),
			],
		);
	}
}
