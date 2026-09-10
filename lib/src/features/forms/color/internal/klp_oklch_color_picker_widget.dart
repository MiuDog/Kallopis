part of '../klp_oklch_color_picker.dart';

/// 以三個二維色彩平面與四軸控制編輯 [KlpOklchColor]。
///
/// 元件不持有產品狀態；呼叫端以 [value] 與 [onChanged] 控制目前色彩。
class KlpOklchColorPicker extends StatelessWidget {
  const KlpOklchColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.chromaRange = KlpOklchChromaRange.standard,
  });

  final KlpOklchColor value;
  final ValueChanged<KlpOklchColor>? onChanged;

  /// Chroma 平面與控制項的編輯範圍，不限制 [KlpOklchColor] 可表達的值。
  final KlpOklchChromaRange chromaRange;

  @override
  Widget build(BuildContext context) {
    return KlpLayoutBuilder(
      builder: (context, constraints) {
        return _KlpOklchColorPickerContent(
          value: value,
          onChanged: onChanged,
          chromaRange: chromaRange,
          style: _KlpOklchColorPickerStyle.resolve(context.klp, constraints),
        );
      },
    );
  }
}
