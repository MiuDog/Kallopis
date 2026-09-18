import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

int _rgb(KlpColor color) => color.red << 16 | color.green << 8 | color.blue;

void main() {
	test('style version and warm default colors match the accepted catalog', () {
		expect(KlpWorkspacePreset.styleVersion, '1.0.0');
		expect(KlpWorkspacePreset.light().colors.take(6).map(_rgb), [0xe7e4dd, 0x21201b, 0xefede7, 0xf8f6f1, 0x6a655b, 0xe1ddd2]);
		expect(KlpWorkspacePreset.dark().colors.take(6).map(_rgb), [0x201f1c, 0xf0ede6, 0x292724, 0x35322d, 0xbab5aa, 0x484339]);
	});
	test('tone changes preserve geometry and non-style dimensions', () {
		for (final dark in [false, true]) {
			for (final tone in KlpWorkspaceTone.values) {
				final preset = dark ? KlpWorkspacePreset.dark(tone: tone) : KlpWorkspacePreset.light(tone: tone);
				expect(preset.distances.map((value) => value.value), [0, 4, 8, 12, 20, 32, 40, 48]);
				expect(preset.radii.map((value) => value.value), [0, 4, 6, 12, 16, 20, 24, 32]);
				expect(preset.strokeWidths.map((value) => value.value), [0, 1, 1.5, 2, 2.5, 3, 3.5, 4]);
				expect(preset.fontSizes.map((value) => value.value), [10, 12, 14, 16, 18, 20, 24, 32]);
				expect(preset.fontWeights.map((value) => value.value), [100, 200, 300, 400, 500, 600, 700, 800]);
				expect(preset.lineHeights.map((value) => value.value), [1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.8, 2]);
				expect(preset.durations.map((value) => value.milliseconds), [0, 60, 100, 140, 180, 240, 320, 400]);
				expect(preset.colors[6].alpha, 34);
				if (dark) {
					expect(preset.colors[0].red, lessThan(preset.colors[2].red));
					expect(preset.colors[2].red, lessThan(preset.colors[3].red));
				}
			}
		}
	});
}
