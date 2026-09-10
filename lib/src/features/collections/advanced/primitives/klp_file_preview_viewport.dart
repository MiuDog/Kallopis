part of '../klp_advanced_data.dart';

class _KlpFilePreviewViewport extends StatelessWidget {
  const _KlpFilePreviewViewport({
    required this.style,
    required this.size,
    required this.child,
  });

  final _KlpAdvancedStyle style;
  final KlpFilePreviewSize size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      KlpFilePreviewSize.standard => style.filePreviewHeight,
    };

    return SizedBox(
      height: height,
      child: ColoredBox(
        color: style.component,
        child: Center(child: child),
      ),
    );
  }
}
