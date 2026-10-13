part of '../klp_sidebar_navigation_button.dart';

/// Sidebar 導覽按鈕的 hover 與 focus 狀態。
class _KlpSidebarNavigationButtonState
    extends State<KlpSidebarNavigationButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return _KlpSidebarNavigationButtonFrame(
      icon: widget.icon,
      label: widget.label,
      onPressed: widget.onPressed,
      selected: widget.selected,
      hovered: _hovered,
      focused: _focused,
      onHover: (value) => setState(() => _hovered = value),
      onFocusChange: (value) => setState(() => _focused = value),
    );
  }
}
