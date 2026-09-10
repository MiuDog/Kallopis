part of '../klp_tag_input_field.dart';

/// 保留標籤新增動作表面與邊框的底層繪製責任。
class _KlpTagInputActionFrame extends StatelessWidget {
  const _KlpTagInputActionFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.controlInset,
        vertical: context.klp.space.tight,
      ),
      decoration: BoxDecoration(
        color: context.klpColors.surfaceInset,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        border: Border.all(
          color: context.klpColors.border,
          width: context.klp.shape.hairline,
        ),
      ),
      child: child,
    );
  }
}
