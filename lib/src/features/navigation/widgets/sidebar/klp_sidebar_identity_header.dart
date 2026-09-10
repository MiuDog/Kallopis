import 'package:flutter/widgets.dart';

import '../../../collections/avatar/klp_avatar.dart';
import '../../../../foundation/klp_icon.dart';
import '../../../../foundation/layout/klp_expanded.dart';
import '../../../../foundation/layout/klp_gap.dart';
import '../../../../foundation/layout/klp_layout_builder.dart';
import '../../../../foundation/layout/klp_row.dart';
import '../../../../foundation/layout/klp_space_size.dart';
import '../../../../foundation/surface/klp_surface.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';

part 'primitives/klp_sidebar_identity_icon_frame.dart';

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

  final KlpIconData icon;
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
            size: KlpAvatarSize.small,
            tone: KlpAvatarTone.emphasized,
          );

    return KlpLayoutBuilder(
      builder: (context, constraints) {
        final showTitle =
            constraints.maxWidth >=
            klp.space.avatarSmall * 2 + klp.space.itemGap;
        final showTrailing =
            effectiveTrailing != null &&
            constraints.maxWidth >=
                klp.space.avatarSmall * 3 + klp.space.itemGap * 2;

        return KlpRow(
          children: [
            _KlpSidebarIdentityIconFrame(icon: icon),
            if (showTitle) ...[
              const KlpGap.widthSize(KlpSpaceSize.item),
              KlpExpanded(
                child: KlpText(
                  title,
                  role: KlpTextRole.header,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (showTrailing) ...[
              const KlpGap.widthSize(KlpSpaceSize.item),
              effectiveTrailing,
            ],
          ],
        );
      },
    );
  }
}
