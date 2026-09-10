import '../klp_visual_style.dart';
import 'klp_visual_style_json_helpers.dart';
import 'klp_visual_style_json_validation.dart';

/// 舊版萬用間距只在匯入邊界展開，進入模型後各欄位獨立保存。
KlpJsonMap migrateLegacySpacing(KlpJsonMap json, KlpVisualStyle base) {
	if (json['schemaVersion'] == 2 || json['schemaVersion'] == 3) return json;

	final original = readMap(json, 'spacing', '');
	if (original == null) return json;
	final hasCompact = original.containsKey('compact');
	final hasHairline = original.containsKey('hairline');
	if (!hasCompact && !hasHairline) return json;

	// 先驗證舊值，避免忽略舊檔案的錯誤或改寫呼叫端 map。
	final compact = hasCompact ? readNonNegativeDouble(original, 'compact', 'spacing', 0) : base.spacing.navigationSectionGap + base.spacing.hairline;
	final hairline = readNonNegativeDouble(original, 'hairline', 'spacing', base.spacing.hairline);
	final spacing = <String, Object?>{...original}..remove('compact');
	if (hasCompact) {
		for (final key in <String>[
			'contentInlineGap',
			'contentStackGap',
			'contentInset',
			'controlContentGap',
			'controlInset',
			'actionGap',
			'chromeGap',
			'chromePanelInset',
			'chromeToolbarGap',
			'navigationItemInset',
			'navigationRailInset',
			'navigationRailItemGap',
			'overlayContentInset',
			'overlayHeadingGap',
			'overlayItemGap',
		]) {
			spacing.putIfAbsent(key, () => compact);
		}
		for (final key in <String>[
			'appFrameInset',
			'workbenchContentInset',
			'windowHeaderMargin',
			'dockMargin',
		]) {
			spacing.putIfAbsent(key, () => compact / 2);
		}
	}
	spacing.putIfAbsent('navigationSectionGap', () => compact > hairline ? compact - hairline : 0.0);
	if (!hasCompact) return <String, Object?>{...json, 'spacing': spacing};

	// 原本依賴 compact 的精確幾何一併遷移；明寫的新欄位優先。
	final geometry = <String, Object?>{...?readMap(json, 'geometry', '')};
	final control = <String, Object?>{...?readMap(geometry, 'control', 'geometry')};
	final layout = <String, Object?>{...?readMap(geometry, 'layout', 'geometry')};
	for (final key in <String>[
		'pageBackgroundHitRadius',
		'presenceMarkerExtent',
		'colorPickerCursorRadius',
		'swatchExtent',
		'segmentedProgressHeight',
	]) {
		control.putIfAbsent(key, () => compact);
	}
	for (final key in <String>[
		'resizeHandleExtent',
		'overlayViewportInset',
		'railDropTargetExtent',
		'disclosureIconSize',
		'treeLeadingGap',
		'tooltipOffsetX',
	]) {
		layout.putIfAbsent(key, () => compact);
	}
	geometry['control'] = control;
	geometry['layout'] = layout;
	return <String, Object?>{...json, 'spacing': spacing, 'geometry': geometry};
}


/// v1／v2 的尺寸從 spacing 搬入 geometry，舊欄位只存在於匯入邊界。
KlpJsonMap migrateLegacyDimensions(KlpJsonMap json) {
	if (json['schemaVersion'] == 3) return json;

	final original = readMap(json, 'spacing', '');
	if (original == null) return json;

	const controlKeys = {'switchTrackWidth', 'switchTrackHeight', 'switchThumb'};
	const layoutKeys = {'drawerWidth', 'drawerHeight'};
	if (!original.keys.any((key) => controlKeys.contains(key) || layoutKeys.contains(key))) return json;

	// 複製各層 map 並驗證舊值；新 geometry 鍵永遠優先。
	final spacing = <String, Object?>{...original};
	final geometry = <String, Object?>{...?readMap(json, 'geometry', '')};
	final control = <String, Object?>{...?readMap(geometry, 'control', 'geometry')};
	final layout = <String, Object?>{...?readMap(geometry, 'layout', 'geometry')};
	for (final key in controlKeys) {
		if (!spacing.containsKey(key)) continue;

		final value = readNonNegativeDouble(spacing, key, 'spacing', 0);
		control.putIfAbsent(key, () => value);
		spacing.remove(key);
	}
	for (final key in layoutKeys) {
		if (!spacing.containsKey(key)) continue;

		final value = readNonNegativeDouble(spacing, key, 'spacing', 0);
		layout.putIfAbsent(key, () => value);
		spacing.remove(key);
	}
	geometry['control'] = control;
	geometry['layout'] = layout;
	return <String, Object?>{...json, 'spacing': spacing, 'geometry': geometry};
}
