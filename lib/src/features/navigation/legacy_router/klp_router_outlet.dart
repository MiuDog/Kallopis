part of 'klp_router.dart';

/// 渲染目前目的地，不替產品決定轉場。
class KlpRouterOutlet extends StatelessWidget implements KlpPanelLayout {
  const KlpRouterOutlet({super.key});

  @override
  Widget build(BuildContext context) =>
      KlpRouterScope.of(context).current.builder(context);

  @override
  Widget buildPanelLayout(BuildContext context) => build(context);
}
