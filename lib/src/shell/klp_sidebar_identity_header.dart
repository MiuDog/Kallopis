import 'package:flutter/widgets.dart';

import '../data/klp_avatar.dart';
import '../foundation/klp_icon.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// Primary Sidebar 頂部的 workspace identity。
///
/// 呼叫端提供圖示、名稱與選填尾端內容；Kallopis 統一負責圖示底面、文字層級、
/// 間距與截斷行為。
class KlpSidebarIdentityHeader extends StatelessWidget {
  const KlpSidebarIdentityHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.avatarLabel,
    this.avatarSemanticLabel,
    this.avatarImage,
  }) : assert(trailing == null || avatarLabel == null);

  final String icon;
  final String title;
  final Widget? trailing;

  /// 尾端識別標記；尺寸由 Primary Sidebar 的預設密度決定。
  final String? avatarLabel;
  final String? avatarSemanticLabel;
  final ImageProvider? avatarImage;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final effectiveTrailing = avatarLabel == null
        ? trailing
        : KlpAvatar(
            label: avatarLabel!,
            semanticLabel: avatarSemanticLabel,
            image: avatarImage,
            size: klp.space.avatarSmall,
            emphasized: true,
          );

    return Row(
      children: [
        KlpSurface(
          tone: KlpSurfaceTone.accentSoft,
          radius: klp.shape.control,
          padding: EdgeInsets.zero,
          child: SizedBox.square(
            dimension: klp.space.avatarSmall,
            child: Center(
              child: KlpIcon(icon, size: klp.space.iconSmall + klp.space.tight),
            ),
          ),
        ),
        SizedBox(width: klp.space.itemGap),
        Expanded(
          child: KlpText(
            title,
            role: KlpTextRole.bodyStrong,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (effectiveTrailing != null) ...[
          SizedBox(width: klp.space.itemGap),
          effectiveTrailing,
        ],
      ],
    );
  }
}
