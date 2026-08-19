import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';

class KlpSegmentedProgress extends StatelessWidget {
  const KlpSegmentedProgress({
    super.key,
    required this.value,
    required this.segments,
  });

  final double value;
  final int segments;

  @override
  Widget build(BuildContext context) {
    final completed = (value.clamp(0, 1) * segments).ceil();

    return Row(
      children: [
        for (var index = 0; index < segments; index++) ...[
          Expanded(
            child: Container(
              height: context.klp.space.compact,
              decoration: BoxDecoration(
                color: index < completed
                    ? context.klpColors.info
                    : context.klpColors.surfaceInset,
                borderRadius: BorderRadius.circular(context.klp.shape.control),
              ),
            ),
          ),
          if (index < segments - 1) SizedBox(width: context.klp.space.tight),
        ],
      ],
    );
  }
}
