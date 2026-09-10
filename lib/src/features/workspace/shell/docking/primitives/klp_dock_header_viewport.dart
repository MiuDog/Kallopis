part of '../klp_dock_header.dart';

class _KlpDockHeaderViewport extends StatelessWidget {
  const _KlpDockHeaderViewport({
    required this.controller,
    required this.onPointerSignal,
    required this.child,
  });

  final ScrollController controller;
  final void Function(PointerSignalEvent) onPointerSignal;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: onPointerSignal,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    );
  }
}
