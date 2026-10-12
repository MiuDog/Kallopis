import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

/// 真實公開 Panel 的淺深色及平面／微立體對照。
void main() => runApp(MaterialApp(theme: buildKlpTheme(Brightness.light), home: const _ReliefReview()));

class _ReliefReview extends StatelessWidget {

	const _ReliefReview();

	@override
	Widget build(BuildContext context) => Scaffold(body: Column(children: [
		for (final brightness in Brightness.values) Expanded(child: Theme(
			data: buildKlpTheme(brightness),
			child: Builder(builder: (context) => ColoredBox(
				color: context.klp.color.app,
				child: Padding(padding: EdgeInsets.all(context.klp.space.base), child: Row(children: [
					for (final elevation in KlpPanelElevation.values) Expanded(child: KlpPanelFrame(
						elevation: elevation,
						header: KlpPanelHeader(title: '${brightness.name} / ${elevation.name}'),
						content: const Center(child: KlpText('Panel')),
					)),
				])),
			)),
		)),
	]));
}
