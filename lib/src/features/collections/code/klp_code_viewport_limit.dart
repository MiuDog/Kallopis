part of 'klp_code_viewer.dart';

/// 程式碼資料元件的型別化可視高度限制。
@immutable
class KlpCodeViewportLimit {
  const KlpCodeViewportLimit.fixed(this._height);

  const KlpCodeViewportLimit.unbounded() : _height = double.infinity;

  final double _height;
}
