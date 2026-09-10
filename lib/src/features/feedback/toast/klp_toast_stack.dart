part of '../klp_toast.dart';

class KlpToastStack extends StatelessWidget {
  const KlpToastStack({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index < children.length - 1)
            const KlpGap.heightSize(KlpSpaceSize.contentStack),
        ],
      ],
    );
  }
}
