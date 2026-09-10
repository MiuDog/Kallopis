import 'package:flutter/widgets.dart';

/// 將純裝飾內容排除於語意樹之外。
class KlpExcludeSemantics extends StatelessWidget {
  const KlpExcludeSemantics({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(child: child);
}
