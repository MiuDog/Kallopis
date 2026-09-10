part of '../klp_code_viewer.dart';

abstract final class _KlpCodeMenuPresenter {
  static Future<int?> show(
    BuildContext context, {
    required String label,
    required List<KlpMenuItemData> items,
    required String barrierLabel,
  }) async {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;

    final anchor = renderObject.localToGlobal(
      Offset(0, renderObject.size.height),
    );
    final position = KlpMenuLayout.resolvePosition(
      anchor: anchor,
      viewport: MediaQuery.sizeOf(context),
      context: context,
      itemCount: items.length,
    );
    return showGeneralDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierLabel: barrierLabel,
      barrierColor: context.klpColors.clear,
      transitionDuration: context.klp.motion.overlayEnter,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Material(
                type: MaterialType.transparency,
                child: KlpMenu(
                  label: label,
                  items: [
                    for (var index = 0; index < items.length; index++)
                      KlpMenuItemData(
                        key: items[index].key,
                        label: items[index].label,
                        icon: items[index].icon,
                        shortcut: items[index].shortcut,
                        toggleValue: items[index].toggleValue,
                        selected: items[index].selected,
                        onPressed: () => Navigator.of(dialogContext).pop(index),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
