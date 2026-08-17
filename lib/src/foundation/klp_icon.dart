import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'klp_metrics.dart';

class KlpIcon extends StatelessWidget {
  const KlpIcon(
    this.asset, {
    super.key,
    this.size = KlpSize.icon,
    this.color,
    this.semanticLabel,
  });

  final String asset;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? DefaultTextStyle.of(context).style.color;

    return SvgPicture.asset(
      asset,
      // 圖示隨 Kallopis 套件散佈，必須指名 package，否則會到使用端 app 的資產路徑找。
      package: 'kallopis',
      width: size,
      height: size,
      semanticsLabel: semanticLabel,
      colorFilter: effectiveColor == null
          ? null
          : ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}
