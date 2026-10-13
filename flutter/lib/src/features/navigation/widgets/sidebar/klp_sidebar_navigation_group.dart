import 'package:flutter/widgets.dart';

/// Primary Sidebar 的全寬導覽列群組。
///
/// 呼叫端只決定項目順序；相鄰列緊密排列，不插入額外間距或分隔線。
class KlpSidebarNavigationGroup extends StatelessWidget {
  const KlpSidebarNavigationGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
