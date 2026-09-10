import 'package:flutter/widgets.dart';

import '../../../../foundation/layout/klp_layout.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';
import 'klp_panel_header_drag_region_builder.dart';

export 'klp_panel_header_drag_region_builder.dart';

part 'primitives/klp_panel_header_frame.dart';

/// 面板標題列，集中排列標題、拖曳區、leading 與 actions。
class KlpPanelHeader extends StatelessWidget {
  const KlpPanelHeader({
    super.key,
    this.title,
    this.content,
    this.label,
    this.leading,
    this.actions = const [],
    this.titleRole = KlpTextRole.header,
    this.dragRegionBuilder,
  }) : assert(title != null || content != null);

  /// 標準文字標題；與 [content] 擇一提供。
  final String? title;

  /// Dock tabs 或其他非文字標題的共通內容入口。
  final Widget? content;
  final String? label;
  final Widget? leading;
  final List<Widget> actions;
  final KlpTextRole titleRole;

  /// 只包住標題／內容抓取區，不會包住右側 actions。
  final KlpPanelHeaderDragRegionBuilder? dragRegionBuilder;

  @override
  Widget build(BuildContext context) {
    final titleContent =
        content ??
        KlpColumn(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KlpText(
              title!,
              role: titleRole,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (label != null)
              KlpText(
                label!,
                role: KlpTextRole.label,
                tone: KlpTextTone.faint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        );
    final dragContent = dragRegionBuilder?.call(titleContent) ?? titleContent;

    return _KlpPanelHeaderFrame(
      child: KlpRow(
        children: [
          if (leading != null) ...[
            leading!,
            const KlpGap.widthSize(KlpSpaceSize.chromeToolbar),
          ],
          KlpExpanded(child: dragContent),
          for (final action in actions) ...[
            const KlpGap.widthSize(KlpSpaceSize.tight),
            action,
          ],
        ],
      ),
    );
  }
}
