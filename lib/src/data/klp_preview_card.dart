import 'package:flutter/widgets.dart';

import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 預覽內容、標題與中繼資訊的通用卡片。
class KlpPreviewCard extends StatelessWidget {
  const KlpPreviewCard({
    super.key,
    required this.title,
    required this.preview,
    this.metadata = const [],
    this.previewHeight,
  });

  final String title;
  final Widget preview;
  final List<String> metadata;
  final double? previewHeight;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: KlpSurfaceTone.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: previewHeight ?? klp.space.pageLarge * 2,
            child: KlpSurface(
              tone: KlpSurfaceTone.component,
              radius: klp.shape.control,
              child: preview,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              klp.space.compact,
              klp.space.compact,
              klp.space.compact,
              klp.space.itemGap,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpText(title, role: KlpTextRole.body),
                if (metadata.isNotEmpty) ...[
                  SizedBox(height: klp.space.tight),
                  Wrap(
                    spacing: klp.space.compact,
                    runSpacing: klp.space.hairline,
                    children: [
                      for (final item in metadata)
                        KlpText(
                          item,
                          role: KlpTextRole.code,
                          tone: KlpTextTone.faint,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
