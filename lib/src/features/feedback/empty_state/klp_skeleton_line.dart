part of '../klp_empty_state.dart';

class KlpSkeletonLine extends StatelessWidget {
  const KlpSkeletonLine({super.key});

  @override
  Widget build(BuildContext context) {
    return KlpExcludeSemantics(
      child: KlpBox(
        width: double.infinity,
        heightSize: KlpSpaceSize.skeletonLine,
        tone: KlpSurfaceTone.inset,
        radius: context.klp.shape.control,
      ),
    );
  }
}
