part of '../klp_text_field.dart';

class _KlpTextFieldActionFrame extends StatelessWidget {
  const _KlpTextFieldActionFrame({
    required this.child,
    required this.onTap,
    this.height,
    this.horizontalInset,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double? height;
  final double? horizontalInset;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (horizontalInset != null) {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalInset!),
        child: content,
      );
    }
    if (height != null) content = SizedBox(height: height, child: content);

    final action = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
    if (semanticLabel == null) return action;

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: action,
    );
  }
}
