import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

/// 行內程式碼片段。帶有圓角背景與等寬字體，適合在段落文字中呈現指令、變數或路徑。
class KlpInlineCode extends StatelessWidget {
  const KlpInlineCode(
    this.text, {
    super.key,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.radius,
  });

  /// 程式碼文字內容。
  final String text;

  /// 文字顏色。預設為 `context.klp.color.text`。
  final Color? color;

  /// 背景填色。預設為 `context.klp.color.surfaceInset`。
  final Color? backgroundColor;

  /// 字體大小。預設為 `context.klp.type.sub` (14px)。
  final double? fontSize;

  /// 圓角半徑。預設為 `context.klp.shape.control`。
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final effectiveRadius = radius ?? klp.shape.control;
    final effectiveFontSize = fontSize ?? klp.type.sub;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: klp.space.tight,
        vertical: klp.space.hairline,
      ),
      margin: EdgeInsets.symmetric(horizontal: klp.space.hairline),
      decoration: BoxDecoration(
        color: backgroundColor ?? klp.color.surfaceInset,
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: klp.type.codeFamily,
          fontFamilyFallback: klp.type.fallbackFor(klp.type.codeFamily),
          fontSize: effectiveFontSize,
          color: color ?? klp.color.text,
          height: klp.type.codeLeading,
        ),
      ),
    );
  }
}
