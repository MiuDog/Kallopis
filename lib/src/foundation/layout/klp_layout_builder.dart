import 'package:flutter/widgets.dart';

/// 將 Flutter constraint 建構邊界集中於排版原語層。
class KlpLayoutBuilder extends StatelessWidget {
  const KlpLayoutBuilder({super.key, required this.builder});

  final LayoutWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: builder);
  }
}
