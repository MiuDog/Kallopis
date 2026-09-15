import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/environment/klp_device_class.dart' as capability;
import 'package:kallopis/src/capabilities/environment/klp_display_mode.dart' as capability;
import 'package:kallopis/src/capabilities/environment/klp_orientation.dart' as capability;
import 'package:kallopis/src/foundation/platform/klp_device_class.dart' as foundation;
import 'package:kallopis/src/foundation/platform/klp_display_mode.dart' as foundation;
import 'package:kallopis/src/foundation/platform/klp_orientation.dart' as foundation;

void main() {
	test('device class compatibility preserves type values order and identity', () {
		// 雙向靜態賦值防止相容路徑建立另一個 enum 或包裝值。
		const List<foundation.KlpDeviceClass> current = capability.KlpDeviceClass.values;
		const List<capability.KlpDeviceClass> legacy = foundation.KlpDeviceClass.values;
		expect(capability.KlpDeviceClass, same(foundation.KlpDeviceClass));
		_expectAlias(current, legacy, ['phone', 'tablet', 'desktop']);
	});

	test('display mode compatibility preserves type values order and identity', () {
		const List<foundation.KlpDisplayMode> current = capability.KlpDisplayMode.values;
		const List<capability.KlpDisplayMode> legacy = foundation.KlpDisplayMode.values;
		expect(capability.KlpDisplayMode, same(foundation.KlpDisplayMode));
		_expectAlias(current, legacy, ['browser', 'standalone', 'nativeApp']);
	});

	test('orientation compatibility preserves type values order and identity', () {
		const List<foundation.KlpOrientation> current = capability.KlpOrientation.values;
		const List<capability.KlpOrientation> legacy = foundation.KlpOrientation.values;
		expect(capability.KlpOrientation, same(foundation.KlpOrientation));
		_expectAlias(current, legacy, ['portrait', 'landscape']);
	});
}

void _expectAlias<T extends Enum>(List<T> current, List<T> legacy, List<String> names) {
	// 固定完整名稱與順序，並逐項證明兩條匯入路徑指向同一物件。
	expect(current.map((value) => value.name), orderedEquals(names));
	expect(legacy.map((value) => value.name), orderedEquals(names));
	for (var index = 0; index < names.length; index++) {
		expect(current[index], same(legacy[index]));
		expect(current[index].index, index);
		expect(legacy[index].index, index);
	}
}
