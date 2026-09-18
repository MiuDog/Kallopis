import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/semantics/klp_control_density.dart';
import 'package:kallopis/src/features/workspace/shell/window/klp_window_controls_geometry.dart';

void main() {
	test('compact density preserves the selected A contract', () {
		final density = KlpControlDensity(KlpDistance(32));
		expect(density.windowControl, 24);
		expect(KlpWindowControlsGeometry(extent: density.windowControl).iconExtent, 12);
		expect([density.height, density.icon, density.padding, density.gap, density.row, density.lineHeight], [32, 16, 8, 6, 36, 18]);
	});
	test('primitive replacement keeps targets usable and visual content contained', () {
		for (var extent = 1.0; extent <= 256; extent++) {
			final density = KlpControlDensity(KlpDistance(extent));
			expect(density.touchTarget, greaterThanOrEqualTo(48));
			expect(density.touchTarget, greaterThanOrEqualTo(density.height));
			expect(density.icon + density.gap * 2, lessThanOrEqualTo(density.height));
			expect(density.lineHeight + density.gap * 2, lessThanOrEqualTo(density.height));
			expect(density.row, greaterThanOrEqualTo(density.height));
		}
	});
	test('zero extent fails before rendering', () {
		expect(() => KlpControlDensity(KlpDistance(0)), throwsArgumentError);
	});
}
