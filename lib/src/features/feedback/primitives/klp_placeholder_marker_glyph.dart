part of '../klp_region_placeholder.dart';

/// 將 Placeholder 菱形狀態字形限制在 feedback 基礎原語邊界。
class _KlpPlaceholderMarkerGlyph extends StatelessWidget {
  const _KlpPlaceholderMarkerGlyph({required this.pending});

  final bool pending;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Transform.rotate(
      angle: math.pi / 4,
      child: SizedBox.square(
        dimension: context.klp.space.indicatorDot,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: pending ? tokens.info : null,
            // 這是狀態字形，不是元件或 Surface 的可見框線。
            border: pending
                ? null
                : Border.fromBorderSide(
                    BorderSide(
                      color: tokens.textFaint,
                      width: context.klp.shape.hairline,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
