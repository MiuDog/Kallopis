part of 'klp_text_widget.dart';

/// 執行文字光學基線位移的 render object。
class _RenderKlpOpticalShift extends RenderShiftedBox {
  _RenderKlpOpticalShift(this._offsetY) : super(null);

  double _offsetY;

  set offsetY(double value) {
    if (_offsetY == value) return;
    _offsetY = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(child!.size);
    (child!.parentData! as BoxParentData).offset = Offset(0, _offsetY);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final distance = child?.getDistanceToActualBaseline(baseline);
    if (distance == null) return null;
    final childOffset = (child!.parentData! as BoxParentData).offset.dy;
    return distance + childOffset;
  }
}
