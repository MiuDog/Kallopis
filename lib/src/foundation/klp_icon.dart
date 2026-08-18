import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/klp_theme.dart';

class KlpIcon extends StatelessWidget {
  const KlpIcon(
    this.asset, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final String asset;

  /// `null` 表示沿用 theme 的圖示尺寸。
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? DefaultTextStyle.of(context).style.color;
    final effectiveSize = size ?? context.klp.space.icon;

    return SvgPicture.asset(
      asset,
      // 圖示隨 Kallopis 套件散佈，必須指名 package，否則會到使用端 app 的資產路徑找。
      package: 'kallopis',
      width: effectiveSize,
      height: effectiveSize,
      semanticsLabel: semanticLabel,
      colorFilter: effectiveColor == null
          ? null
          : ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}
