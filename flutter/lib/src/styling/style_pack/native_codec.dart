part of 'klp_style_pack.dart';

/// 所有 semantic 依完整路徑映射；原生限制不得靜默截斷交換值。
KlpVisualStyle _nativeStyle(String name, Map<String, Object?> tokens) {
	final json = <String, Object?>{'schemaVersion': 3, 'name': name};
	for (final entry in tokens.entries) {
		final path = entry.key.substring('theme.'.length).split('.');
		var parent = json;
		for (final segment in path.take(path.length - 1)) {
			parent = _map(parent.putIfAbsent(segment, () => <String, Object?>{}), entry.key);
		}
		parent[path.last] = _copy(entry.value);
	}
	final typography = _map(json['typography'], 'theme.typography');
	for (final key in ['regular', 'medium', 'semiBold', 'bold', 'extraBold', 'strong']) {
		typography.remove(key);
	}
	// 舊 JSON codec 的百位字重與整毫秒限制不適用共通交換契約。
	json.remove('motion');
	_map(json['surface'], 'theme.surface').remove('overlaySpread');
	late KlpVisualStyle decoded;
	try {
		decoded = KlpVisualStyleJson.decode(json);
	} on FormatException catch (error) {
		throw FormatException('theme.${error.message}');
	}
	FontWeight weight(String key) => FontWeight((tokens['theme.typography.$key'] as num).toInt());
	Duration duration(String key) {
		final id = 'theme.motion.$key';
		final micros = (tokens[id] as num) * 1000;
		if (!micros.isFinite || micros != micros.roundToDouble() || micros.toInt().toDouble() != micros) _fail(id, 'cannot represent exact native microseconds');
		return Duration(microseconds: micros.toInt());
	}
	Cubic curve(String key) {
		final points = (tokens['theme.motion.$key'] as List).cast<num>();
		return Cubic(points[0].toDouble(), points[1].toDouble(), points[2].toDouble(), points[3].toDouble());
	}
	return decoded.copyWith(
		typography: decoded.typography.copyWith(
			regular: weight('regular'), medium: weight('medium'), semiBold: weight('semiBold'),
			bold: weight('bold'), extraBold: weight('extraBold'), strong: weight('strong'),
			sansFallback: List<String>.unmodifiable(decoded.typography.sansFallback),
			monoFallback: List<String>.unmodifiable(decoded.typography.monoFallback),
		),
		motion: KlpMotionTheme(
			themeTransition: duration('themeTransition'), styleTransition: duration('styleTransition'),
			stateTransition: duration('stateTransition'), overlayEnter: duration('overlayEnter'),
			overlayExit: duration('overlayExit'), toastDwell: duration('toastDwell'),
			tooltipDelay: duration('tooltipDelay'), tooltipDwell: duration('tooltipDwell'),
			spinnerCycle: duration('spinnerCycle'), longPressThreshold: duration('longPressThreshold'),
			standard: curve('standard'), emphasized: curve('emphasized'),
		),
		surface: decoded.surface.copyWith(overlaySpread: (tokens['theme.surface.overlaySpread'] as num).toDouble()),
		dataVisualization: decoded.dataVisualization.copyWith(
			series: List<Color>.unmodifiable(decoded.dataVisualization.series),
			seriesWash: List<Color>.unmodifiable(decoded.dataVisualization.seriesWash),
		),
	);
}
