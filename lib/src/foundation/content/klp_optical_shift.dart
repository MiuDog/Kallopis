part of 'klp_text_widget.dart';

/// 套用文字光學基線位移，維持原始 baseline 計算。
class _KlpOpticalShift extends SingleChildRenderObjectWidget {
  const _KlpOpticalShift({required this.offsetY, required super.child});

  final double offsetY;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderKlpOpticalShift(offsetY);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderKlpOpticalShift renderObject,
  ) {
    renderObject.offsetY = offsetY;
  }
}
