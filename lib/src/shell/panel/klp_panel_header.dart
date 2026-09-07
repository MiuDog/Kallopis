import 'package:flutter/widgets.dart';

import '../../typography/klp_text.dart';
import '../../theme/klp_theme.dart';

typedef KlpPanelHeaderDragRegionBuilder = Widget Function(Widget child);

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
        Column(
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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.chromePanelInset,
        vertical: context.klp.space.tight,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: context.klp.space.chromeToolbarGap),
          ],
          Expanded(child: dragContent),
          for (final action in actions) ...[
            SizedBox(width: context.klp.space.tight),
            action,
          ],
        ],
      ),
    );
  }
}
