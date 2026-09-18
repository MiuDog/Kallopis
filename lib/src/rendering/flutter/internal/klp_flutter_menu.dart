import 'package:flutter/material.dart';
import 'package:kallopis/src/features/overlays/klp_menu.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

/// 所有宿主命令選單共用既有 KlpMenu，定位與關閉由同一個 route 管理。
Future<int?> showKlpMenuItems({required BuildContext context, required Offset anchor, required List<KlpMenuItemData> items, required Color surface, required Color foreground, required String fontFamily, String label = '操作', bool searchable = false, void Function(BuildContext)? onRouteContext}) {

	final dark = surface.computeLuminance() < foreground.computeLuminance();
	final colors = (dark ? KlpThemeData.dark : KlpThemeData.light).copyWith(overlay: surface, text: foreground);
	// 庫內橋接既有元件的 theme，不將 legacy Widget 或 theme 交給產品。
	return showGeneralDialog<int>(
		context: context,
		barrierDismissible: true,
		barrierLabel: (Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) ?? const DefaultMaterialLocalizations()).modalBarrierDismissLabel,
		barrierColor: Colors.transparent,
		pageBuilder: (routeContext, animation, secondaryAnimation) {
			onRouteContext?.call(routeContext);
			return Theme(
				data: Theme.of(context).copyWith(brightness: dark ? Brightness.dark : Brightness.light, extensions: [colors], textTheme: Theme.of(context).textTheme.apply(fontFamily: fontFamily)),
				child: Builder(builder: (menuContext) => LayoutBuilder(builder: (_, constraints) {
					final overlay = Navigator.of(context, rootNavigator: true).overlay!.context.findRenderObject()! as RenderBox;
					final local = overlay.globalToLocal(anchor);
					final inset = menuContext.klp.geometry.layout.overlayViewportInset.clamp(0.0, constraints.biggest.shortestSide / 2);
					final width = KlpMenuLayout.widthForItems(menuContext, items, scrollable: true).clamp(0.0, constraints.maxWidth - inset * 2);
					final groups = [for (var i = 0; i < items.length; i++) if (items[i].group != null && (i == 0 || items[i - 1].group != items[i].group)) items[i].group];
					final height = (menuContext.klp.space.tight * 2
						+ (groups.isEmpty ? 1 : groups.length) * (menuContext.klp.geometry.layout.menuHeaderHeight + menuContext.klp.space.tight)
						+ items.fold<double>(0, (sum, item) => sum + menuContext.klp.menuItemHeight * (item.description == null ? 1 : 2) + (item.separatedBefore || item.dashedSeparatorBefore ? menuContext.klp.shape.stroke + menuContext.klp.space.tight * 2 : 0)))
						.clamp(0.0, searchable ? constraints.maxHeight / 3 : constraints.maxHeight - inset * 2);
					final left = local.dx.clamp(inset, constraints.maxWidth - width - inset);
					final top = local.dy.clamp(inset, constraints.maxHeight - height - inset);
					return MouseRegion(cursor: SystemMouseCursors.basic, hitTestBehavior: HitTestBehavior.translucent, child: Stack(fit: StackFit.expand, children: [Positioned(left: left, top: top, width: width, height: height, child: Material(type: MaterialType.transparency, child: KlpMenu(
						scrollable: true,
						searchable: searchable,
						searchPlaceholder: '搜尋元件',
						label: label,
						onEscape: () => Navigator.pop(routeContext),
						items: [for (final (index, item) in items.indexed) KlpMenuItemData(label: item.label, description: item.description, group: item.group, iconSvg: item.iconSvg, toggleValue: item.toggleValue, hasSubmenu: item.hasSubmenu, dashedSeparatorBefore: item.dashedSeparatorBefore, icon: item.icon, shortcut: item.shortcut, enabled: item.enabled, selected: item.selected, danger: item.danger, separatedBefore: item.separatedBefore, onPressed: () => Navigator.pop(routeContext, index))],
					)))]));
				})),
			);
		},
	);
}
