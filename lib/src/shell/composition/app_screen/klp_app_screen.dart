import 'package:flutter/material.dart';

import '../../../theme/klp_theme.dart';

/// 應用程式最外層，提供 Material 祖先與 app 背景。
class KlpAppScreen extends StatelessWidget {
	const KlpAppScreen({super.key, required this.child, this.windowHeader});

	final Widget? windowHeader;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final background = tokens.app;
		final surfaceTokens = tokens.onBackground(background);

		return Material(
			type: MaterialType.transparency,
			child: ColoredBox(
				color: background,
				child: KlpTokenOverride(
					colors: surfaceTokens,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							?windowHeader,
							Expanded(child: child),
						],
					),
				),
			),
		);
	}
}
