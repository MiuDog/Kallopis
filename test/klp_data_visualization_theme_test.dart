import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	test('資料視覺化語意組合保留既有色碼', () {
		expect(_signature(KlpDataVisualizationTheme.light), const [
			0xFFE0BE73, 0xFFD3A152, 0xFFC6823D, 0xFFA96836, 0xFF895137, 0xFF683E33,
			0xFFF8F1E2, 0xFFF6EBD7, 0xFFF3E4CF, 0xFFEEDDD0, 0xFFE9D8D1, 0xFFE4D5D1,
			0xFFD6D0C6, 0xFFE4E1DA, 0xFFC8C0B4, 0xFF6B6459, 0xFF1D1D1D, 0x00000000,
			0xFF8C8477, 0xFF2D8057, 0xFFDFF0E5, 0xFFA7443F, 0xFFFAE3E2, 0xFF8C8477,
		]);
		expect(_signature(KlpDataVisualizationTheme.dark), const [
			0xFFF0D79A, 0xFFE8BD70, 0xFFDFA04E, 0xFFC88745, 0xFFA86D43, 0xFF89573E,
			0xFF453D2B, 0xFF443725, 0xFF413222, 0xFF3D2D22, 0xFF382A23, 0xFF332724,
			0xFF585249, 0xFF433F3A, 0xFF6A6256, 0xFFB8B2A4, 0xFFF5F2EC, 0x00000000,
			0xFF918A7B, 0xFF67AE86, 0xFF243B2D, 0xFFD27B74, 0xFF472925, 0xFF918A7B,
		]);
		expect(_signature(KlpDataVisualizationTheme.ultraDark), const [
			0xFFF0D79A, 0xFFE8BD70, 0xFFDFA04E, 0xFFC88745, 0xFFA86D43, 0xFF89573E,
			0xFF302B20, 0xFF30271B, 0xFF2E241A, 0xFF2C211B, 0xFF291F1C, 0xFF261D1C,
			0xFF45413A, 0xFF34302B, 0xFF585249, 0xFFB8B2A4, 0xFFF5F2EC, 0x00000000,
			0xFF7A7566, 0xFF67AE86, 0xFF1D3025, 0xFFD27B74, 0xFF3B2320, 0xFF7A7566,
		]);
	});
}

List<int> _signature(KlpDataVisualizationTheme theme) {
	final colors = <Color>[
		...theme.series,
		...theme.seriesWash,
		theme.axis,
		theme.grid,
		theme.gridStrong,
		theme.label,
		theme.value,
		theme.plotBackground,
		theme.crosshair,
		theme.marketUp,
		theme.marketUpWash,
		theme.marketDown,
		theme.marketDownWash,
		theme.marketFlat,
	];
	return colors.map((color) => color.toARGB32()).toList();
}
