import 'package:flutter/widgets.dart';

/// 重疊排列排版原語。取代 Stack。
class KlpStack extends StatelessWidget {
  const KlpStack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.fit = StackFit.loose,
		this.clipBehavior = Clip.hardEdge,
    this.children = const <Widget>[],
  });

  final AlignmentGeometry alignment;
  final StackFit fit;
	final Clip clipBehavior;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      fit: fit,
		clipBehavior: clipBehavior,
      children: children,
    );
  }
}
