import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final buttonSystemPage = CatalogPageData(
	label: 'Button system',
	title: 'Button system',
	description: 'Semantic tones across rest, hover, selected, and disabled states.',
	icon: KlpIcons.check,
	specimens: const [],
	tokenView: (context) => const _ButtonSystemPreview(),
);

class _ButtonSystemPreview extends StatelessWidget {
	const _ButtonSystemPreview();

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpMasonryGrid(children: [for (final tone in KlpButtonTone.values) _ToneCard(tone: tone)]),
				SizedBox(height: space.section),
				const KlpText('Size scale', role: KlpTextRole.section),
				SizedBox(height: space.compact),
				const _SizeScale(),
			],
		);
	}
}

class _ToneCard extends StatelessWidget {
	const _ToneCard({required this.tone});

	final KlpButtonTone tone;

	@override
	Widget build(BuildContext context) {
		final space = context.klp.space;
		return KlpSurface(
			tone: KlpSurfaceTone.raised,
			padding: EdgeInsets.all(space.compact),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					KlpText(tone.name, role: KlpTextRole.code),
					SizedBox(height: space.compact),
					Wrap(
						spacing: space.compact,
						runSpacing: space.compact,
						children: [
							_StateSample(label: 'Rest', button: _button('Rest')),
							_StateSample(label: 'Hover', button: _button('Hover me')),
							_StateSample(label: 'Selected', button: _button('Selected', selected: true)),
							_StateSample(label: 'Disabled', button: KlpButton(label: 'Disabled', tone: tone, onPressed: null)),
						],
					),
				],
			),
		);
	}

	Widget _button(String label, {bool selected = false}) {
		return KlpButton(label: label, tone: tone, selected: selected, onPressed: _noop);
	}
}

class _StateSample extends StatelessWidget {
	const _StateSample({required this.label, required this.button});

	final String label;
	final Widget button;

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				KlpText(label, role: KlpTextRole.caption, tone: KlpTextTone.muted),
				SizedBox(height: context.klp.space.tight),
				button,
			],
		);
	}
}

class _SizeScale extends StatelessWidget {
	const _SizeScale();

	@override
	Widget build(BuildContext context) {
		return Wrap(
			spacing: context.klp.space.compact,
			runSpacing: context.klp.space.compact,
			crossAxisAlignment: WrapCrossAlignment.center,
			children: [
				KlpButton(label: 'Default SM', onPressed: _noop),
				KlpButton(label: 'Compact XS', compact: true, onPressed: _noop),
				KlpButton(label: 'XS', size: KlpControlSize.xs, onPressed: _noop),
				KlpButton(label: 'SM', size: KlpControlSize.sm, onPressed: _noop),
				KlpButton(label: 'MD', size: KlpControlSize.md, onPressed: _noop),
				KlpButton(label: 'LG', size: KlpControlSize.lg, onPressed: _noop),
				KlpButton(label: 'XL', size: KlpControlSize.xl, onPressed: _noop),
			],
		);
	}
}

void _noop() {}
