part of '../klp_app_screen.dart';

/// 提供 Kallopis 控制項所需的透明 Material 根節點。
class _KlpAppScreenMaterialRoot extends StatelessWidget {
	const _KlpAppScreenMaterialRoot({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) => Material(
		type: MaterialType.transparency,
		child: child,
	);
}
