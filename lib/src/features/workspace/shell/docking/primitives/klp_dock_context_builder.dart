part of '../klp_dock_header.dart';

class _KlpDockContextBuilder extends StatelessWidget {
  const _KlpDockContextBuilder({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => Builder(builder: builder);
}
