part of '../klp_dock_layout.dart';

class KlpDockLayout extends StatefulWidget implements KlpPanelLayout {
  const KlpDockLayout({
    super.key,
    required this.stage,
    required this.panels,
    required this.layout,
    required this.onLayoutChanged,
    required this.leftConstraints,
    required this.rightConstraints,
    this.bottomConstraints,
  });

  final KlpPanelFrame stage;
  final List<KlpDockPanel> panels;
  final KlpDockLayoutData layout;
  final ValueChanged<KlpDockLayoutData> onLayoutChanged;
  final KlpDockAreaConstraints leftConstraints;
  final KlpDockAreaConstraints rightConstraints;

  /// Bottom 可用時的高度限制；沒有任何 Bottom-capable panel 時可省略。
  final KlpDockAreaConstraints? bottomConstraints;

  @override
  State<KlpDockLayout> createState() => _KlpDockLayoutState();

  @override
  Widget buildPanelLayout(BuildContext context) => this;
}
