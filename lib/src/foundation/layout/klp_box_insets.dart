import 'package:flutter/widgets.dart';

/// 封裝已由 theme 解析的方向感知內距，避免高階元件傳遞 Flutter 樣式物件。
class KlpBoxInsets {
  const KlpBoxInsets.uniform(double value)
    : start = value,
      top = value,
      end = value,
      bottom = value;

  const KlpBoxInsets.directional({
    this.start = 0,
    this.top = 0,
    this.end = 0,
    this.bottom = 0,
  });

  final double start;
  final double top;
  final double end;
  final double bottom;

  EdgeInsetsDirectional get edgeInsets =>
      EdgeInsetsDirectional.fromSTEB(start, top, end, bottom);
}
