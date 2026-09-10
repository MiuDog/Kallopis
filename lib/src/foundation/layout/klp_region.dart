import 'package:flutter/widgets.dart';

import '../surface/klp_surface.dart';
import '../../styling/legacy_theme/klp_theme.dart';

/// 區域容器。包裝標題、主要內容與頁尾。
class KlpRegion extends StatelessWidget {
  const KlpRegion({
    super.key,
    required this.content,
    this.header,
    this.footer,
    this.tone = KlpSurfaceTone.base,
    this.padding,
  });

  final Widget? header;
  final Widget content;
  final Widget? footer;
  final KlpSurfaceTone tone;

  /// `null` 表示沿用 theme 的面板內距。內容不應該貼著面板邊緣——
  /// 傳 [EdgeInsets.zero] 才是刻意讓內容自己貼邊（例如內部自帶捲動區）。
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return KlpSurface(
      tone: tone,
      radius: klp.shape.panel,
      padding: padding ?? EdgeInsets.all(klp.space.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?header,
          Expanded(child: content),
          ?footer,
        ],
      ),
    );
  }
}
