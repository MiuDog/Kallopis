import 'package:flutter/widgets.dart';

import 'klp_key_binding_controller.dart';

/// 宣告一個可成為快捷鍵 active scope 的畫面區域。
class KlpKeyBindingRegion extends StatelessWidget {
  const KlpKeyBindingRegion({
    super.key,
    required this.controller,
    required this.regionId,
    required this.child,
    this.pageId,
    this.focusNode,
    this.autofocus = false,
  });

  final KlpKeyBindingController controller;
  final String regionId;
  final String? pageId;
  final Widget child;
  final FocusNode? focusNode;
  final bool autofocus;

  void _activate() =>
      controller.activateRegion(regionId: regionId, pageId: pageId);

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (_) => _activate(),
    child: Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: (focused) {
        if (focused) _activate();
      },
      child: child,
    ),
  );
}
