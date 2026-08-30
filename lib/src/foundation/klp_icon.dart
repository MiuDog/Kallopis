import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

@immutable
final class KlpIconData {
  const KlpIconData(this.codePoint);

  final int codePoint;
}

class KlpIcon extends StatelessWidget {
  const KlpIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final KlpIconData icon;

  /// `null` 表示沿用 theme 的圖示尺寸。
  final double? size;
  final Color? color;
  final String? semanticLabel;

  /// Flaticon UIcons 在 Flutter asset manifest 中登記的 family 名稱。
  static const fontFamily = 'Flaticon UIcons Regular Rounded';

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? DefaultTextStyle.of(context).style.color;
    final effectiveSize = size ?? context.klp.space.icon;

    return Icon(
      IconData(
        // UIcons 整套字型就是散佈單位；字碼由 KlpIcons 的常數清單控制。
        // ignore: non_const_argument_for_const_parameter
        icon.codePoint,
        fontFamily: fontFamily,
        fontPackage: 'kallopis',
      ),
      size: effectiveSize,
      color: effectiveColor,
      semanticLabel: semanticLabel,
    );
  }
}
