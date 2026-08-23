import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpAvatar extends StatelessWidget {
  const KlpAvatar({
    super.key,
    required this.label,
    this.image,
    this.size,
    this.semanticLabel,
    this.emphasized = false,
  });

  final String label;
  final ImageProvider? image;

  /// `null` 表示沿用 theme 的大型控制項高度。
  final double? size;
  final String? semanticLabel;

  /// 強調型使用 accent 底色、對比前景與 pill 圓角。
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = context.klpColors;

    return Semantics(
      label: semanticLabel ?? label,
      image: image != null,
      child: Container(
        width: size ?? context.klp.space.controlHeightLarge,
        height: size ?? context.klp.space.controlHeightLarge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: emphasized ? colors.accent : colors.surfaceMuted,
          image: image == null
              ? null
              : DecorationImage(image: image!, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(
            emphasized ? context.klp.shape.pill : context.klp.shape.card,
          ),
        ),
        child: image == null
            ? KlpText(
                label,
                role: KlpTextRole.label,
                color: emphasized ? colors.onStatus : null,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

@immutable
class KlpAvatarData {
  const KlpAvatarData({required this.id, required this.label, this.image});

  final String id;
  final String label;
  final ImageProvider? image;
}

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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final avatar in visible) ...[
          KlpAvatar(
            label: avatar.label,
            image: avatar.image,
            size: context.klp.space.avatarSmall,
          ),
          SizedBox(width: context.klp.space.tight),
        ],
        if (hiddenCount > 0)
          KlpAvatar(
            label: '+$hiddenCount',
            size: context.klp.space.avatarSmall,
          ),
      ],
    );
  }
}
