import 'package:flutter/material.dart';

/// Material 選單與表單也使用已解析的互動色，不另建產品主題來源。
final class KlpFlutterInteractionTheme extends StatelessWidget {
	final Color color;
	final Color foreground;
	final double radius;
	final Widget child;
	const KlpFlutterInteractionTheme({required this.color, required this.foreground, required this.radius, required this.child, super.key});
	@override
	Widget build(BuildContext context) {
		final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
		final buttonStyle = ButtonStyle(
			foregroundColor: WidgetStatePropertyAll(foreground),
			overlayColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.disabled) ? null : states.any({WidgetState.hovered, WidgetState.pressed, WidgetState.focused, WidgetState.selected}.contains) ? color : null),
			shape: WidgetStatePropertyAll(shape), side: const WidgetStatePropertyAll(BorderSide.none),
			splashFactory: NoSplash.splashFactory,
		);
		final border = OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none);
		return Theme(data: Theme.of(context).copyWith(
			hoverColor: color, focusColor: color, highlightColor: color, splashFactory: NoSplash.splashFactory,
			textButtonTheme: TextButtonThemeData(style: buttonStyle),
			iconButtonTheme: IconButtonThemeData(style: buttonStyle),
			popupMenuTheme: PopupMenuThemeData(shape: shape),
			inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: color, hoverColor: color, focusColor: color, border: border, enabledBorder: border, focusedBorder: border),
		), child: child);
	}
}
