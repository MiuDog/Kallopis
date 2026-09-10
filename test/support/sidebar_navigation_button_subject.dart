import 'package:flutter/material.dart';
import 'package:kallopis/kallopis.dart';

/// Sidebar navigation button 測試使用的固定尺寸宿主。
class SidebarNavigationButtonSubject extends StatelessWidget {
	const SidebarNavigationButtonSubject({
		super.key,
		required this.onPressed,
		this.selected = false,
		this.brightness = Brightness.light,
	});

	final VoidCallback? onPressed;
	final bool selected;
	final Brightness brightness;

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: buildKlpTheme(brightness),
			home: Scaffold(
				body: SizedBox(
					width: 240,
					child: KlpSidebarNavigationButton(
						icon: KlpIcons.folder,
						label: 'Project',
						selected: selected,
						onPressed: onPressed,
					),
				),
			),
		);
	}
}
