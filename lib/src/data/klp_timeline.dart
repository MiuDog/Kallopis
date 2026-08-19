import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 時間軸上的一個事件。
///
/// [marker] 為 `null` 時使用預設圓點；需要客製標記（例如放圖示）時提供這個 slot，
/// 而不是加一堆布林參數去描述「這是哪一種標記」。[highlighted] 只改變預設圓點的
/// 顏色深淺，不表達產品語意（不是「成功」或「危險」那種狀態）。
@immutable
class KlpTimelineItemData {
  const KlpTimelineItemData({
    required this.title,
    this.time,
    this.content,
    this.marker,
    this.highlighted = false,
  });

  final String title;
  final String? time;
  final Widget? content;
  final Widget? marker;
  final bool highlighted;
}

/// 時間軸：事件依序排列，每項有標記、標題、時間、可選內容。
///
/// 只負責排版與標記／連接線的視覺語言；事件的先後順序、時間格式與內容完全由
/// 呼叫端的 [items] 決定，這裡不做排序也不解讀時間字串。
class KlpTimeline extends StatelessWidget {
  const KlpTimeline({super.key, required this.items});

  final List<KlpTimelineItemData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++)
          _KlpTimelineRow(item: items[i], isLast: i == items.length - 1),
      ],
    );
  }
}

class _KlpTimelineRow extends StatelessWidget {
  const _KlpTimelineRow({required this.item, required this.isLast});

  final KlpTimelineItemData item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final markerSize = klp.space.indicatorDotLarge;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                width: markerSize,
                height: markerSize,
                child:
                    item.marker ??
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.highlighted
                            ? tokens.text
                            : tokens.textFaint,
                      ),
                    ),
              ),
              if (!isLast)
                Expanded(
                  child: SizedBox(
                    width: klp.shape.hairline,
                    child: ColoredBox(color: tokens.divider),
                  ),
                ),
            ],
          ),
          SizedBox(width: klp.space.compact),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: klp.space.comfortable),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: KlpText(
                          item.title,
                          role: KlpTextRole.bodyStrong,
                        ),
                      ),
                      if (item.time != null) ...[
                        SizedBox(width: klp.space.compact),
                        KlpText(
                          item.time!,
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ],
                    ],
                  ),
                  if (item.content != null) ...[
                    SizedBox(height: klp.space.tight),
                    item.content!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
