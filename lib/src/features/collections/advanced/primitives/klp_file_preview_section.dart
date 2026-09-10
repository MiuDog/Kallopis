part of '../klp_advanced_data.dart';

class _KlpFilePreviewSection extends StatelessWidget {
  const _KlpFilePreviewSection({
    required this.style,
    required this.header,
    required this.child,
  });

  final _KlpAdvancedStyle style;
  final bool header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: style.surfaceInset,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: style.baseSpace,
          vertical: header ? style.contentInset : style.tightSpace,
        ),
        child: child,
      ),
    );
  }
}
