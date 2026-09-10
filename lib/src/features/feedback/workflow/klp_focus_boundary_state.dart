part of 'klp_finite_workflow.dart';

class _KlpFocusBoundaryState extends State<KlpFocusBoundary> {
  final FocusNode _node = FocusNode();

  void requestFocus() => _node.requestFocus();

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KlpFocusRegion(
      focusNode: _node,
      autofocus: widget.autofocus,
      child: widget.child,
    );
  }
}
