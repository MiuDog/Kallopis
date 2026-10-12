import 'dart:convert';

import 'package:flutter/material.dart';

import '../legacy_theme/klp_motion_theme.dart';
import '../legacy_theme/klp_theme.dart';
import '../legacy_theme/klp_visual_style.dart';
import '../legacy_theme/klp_visual_style_json.dart';
import 'generated.dart';

part 'native_codec.dart';

const _modes = ['light', 'dark', 'ultraDark', 'transparent'];
final _canonical = _map(jsonDecode(klpDefaultStylePackJson), 'default');
final _catalog = _map(_freeze(jsonDecode(klpStyleCatalogJson)), 'catalog');

/// 共通型別與限制由 catalog 擁有，不隨 consumer 風格變更。
final Map<String, Object?> klpStyleParameters = _map(_catalog['parameters'], 'catalog.parameters');

/// 不可變的共通風格交換資料；不持有產品 tree、handler 或布局狀態。
class KlpStylePack {
	KlpStylePack._(this.data);

	/// data：與 caller 隔離的完整交換資料及配方原文。
	final Map<String, Object?> data;

	factory KlpStylePack.defaults() => KlpStylePack.parse(_canonical);

	factory KlpStylePack.parse(Object? input) {
		final data = _map(input is String ? jsonDecode(input) : input, 'pack');
		_validate(data);
		for (final mode in _modes) {
			_resolve(data, mode);
		}
		return KlpStylePack._(_freeze(data) as Map<String, Object?>);
	}

	Map<String, Object?> resolve(KlpThemeVariant variant) => _freeze(_resolve(data, variant.name)) as Map<String, Object?>;

	KlpStylePack applyOverrides(Map<String, Object?> overrides) {
		final next = _copy(data) as Map<String, Object?>;
		for (final section in overrides.keys) {
			if (!['primitives', 'semantics'].contains(section)) _fail('overrides.$section', 'unsupported override section');
			final values = _map(overrides[section], 'overrides.$section');
			final target = _map(next[section], section);
			for (final entry in values.entries) {
				if (!target.containsKey(entry.key)) _fail('$section.${entry.key}', 'unknown override ID');
				if (section == 'primitives') {
					target[entry.key] = _copy(entry.value);
				} else {
					final modes = _map(entry.value, '$section.${entry.key}');
					final expressions = _map(target[entry.key], '$section.${entry.key}');
					for (final mode in modes.entries) {
						if (!_modes.contains(mode.key)) _fail('$section.${entry.key}.${mode.key}', 'unknown override mode');
						expressions[mode.key] = mode.value;
					}
				}
			}
		}
		return KlpStylePack.parse(next);
	}

	KlpVisualStyle toVisualStyle(KlpThemeVariant variant) => _nativeStyle(data['id'] as String, resolve(variant));
}

Never _fail(String path, String reason) => throw FormatException('$path: $reason');

Map<String, Object?> _map(Object? value, String path) {
	if (value is! Map<String, Object?>) _fail(path, 'expected dictionary');
	return value;
}

Object? _copy(Object? value) {
	if (value is Map<String, Object?>) return {for (final entry in value.entries) entry.key: _copy(entry.value)};
	if (value is List) return [for (final item in value) _copy(item)];
	return value;
}

Object? _freeze(Object? value) {
	if (value is Map<String, Object?>) return Map<String, Object?>.unmodifiable({for (final entry in value.entries) entry.key: _freeze(entry.value)});
	if (value is List) return List<Object?>.unmodifiable(value.map(_freeze));
	return value;
}

void _text(Object? value, String path, {bool empty = false}) {
	if (value is! String || (!empty && value.trim().isEmpty)) _fail(path, 'expected string');
}

void _identifier(String id, String path) {
	if (id.trim().isEmpty || id != id.trim() || ['__proto__', 'prototype', 'constructor'].contains(id)) _fail(path, 'invalid ID');
}

void _validate(Map<String, Object?> data) {
	if (data['schemaVersion'] != 1) _fail('schemaVersion', 'unsupported version');
	_text(data['id'], 'id');
	_text(data['version'], 'version');
	for (final section in ['primitives', 'semantics', 'recipes', 'primitiveDescriptions', 'semanticDescriptions']) {
		_map(data[section], section);
	}
	for (final section in ['primitives', 'semantics', 'recipes']) {
		final values = _map(data[section], section);
		for (final id in _map(_canonical[section], section).keys) {
			if (!values.containsKey(id)) _fail('$section.$id', 'missing canonical ID');
		}
		for (final id in values.keys) { _identifier(id, '$section.$id'); }
	}
	final primitives = _map(data['primitives'], 'primitives');
	for (final entry in primitives.entries) {
		final values = entry.value is List ? entry.value as List : [entry.value];
		if (!values.every((value) => value is String || value is num && value.isFinite)) _fail('primitives.${entry.key}', 'expected finite scalar or scalar array');
		_text(_map(data['primitiveDescriptions'], 'primitiveDescriptions')[entry.key], 'primitiveDescriptions.${entry.key}', empty: true);
	}
	final semantics = _map(data['semantics'], 'semantics');
	for (final entry in semantics.entries) {
		final modes = _map(entry.value, 'semantics.${entry.key}');
		if (modes.length != 4) _fail('semantics.${entry.key}', 'expected four modes');
		for (final mode in _modes) { _text(modes[mode], 'semantics.${entry.key}.$mode'); }
		_text(_map(data['semanticDescriptions'], 'semanticDescriptions')[entry.key], 'semanticDescriptions.${entry.key}', empty: true);
	}
	final recipes = _map(data['recipes'], 'recipes');
	final active = <String>{}, complete = <String>{};
	void recipe(String id) {
		if (complete.contains(id)) return;
		if (!recipes.containsKey(id)) _fail('recipes.$id', 'missing inherited recipe');
		if (!active.add(id)) _fail('recipes.$id', 'recipe inheritance cycle');
		final value = _map(recipes[id], 'recipes.$id');
		for (final field in ['aliases', 'inherit', 'parameters']) { _text(value[field], 'recipes.$id.$field', empty: true); }
		final inherit = value['inherit'] as String;
		if (inherit != '—' && !inherit.startsWith('繼承')) recipe(inherit.replaceAll('`', ''));
		for (final match in RegExp(r'([ps])\(([^()]+)\)').allMatches(value['parameters'] as String)) {
			final target = match[2]!;
			final source = match[1] == 'p' ? primitives : target.startsWith('theme.') ? semantics : recipes;
			if (!source.containsKey(target)) _fail('recipes.$id', 'missing reference $target');
		}
		active.remove(id);
		complete.add(id);
	}
	for (final id in recipes.keys) { recipe(id); }
}

Map<String, Object?> _resolve(Map<String, Object?> data, String mode) {
	final semantics = _map(data['semantics'], 'semantics');
	final primitives = _map(data['primitives'], 'primitives');
	final tokens = <String, Object?>{}, active = <String>{};
	Object? semantic(String id) {
		if (tokens.containsKey(id)) return tokens[id];
		if (!semantics.containsKey(id)) _fail(id, 'missing semantic reference');
		if (!active.add(id)) _fail(id, 'semantic cycle');
		final expression = _map(semantics[id], id)[mode] as String;
		Object? value;
		final single = RegExp(r'^([ps])\(([^()]+)\)$').firstMatch(expression);
		Object? primitive(String target) {
			if (!primitives.containsKey(target)) _fail(id, 'missing primitive reference $target');
			return primitives[target];
		}
		if (single != null) {
			value = single[1] == 'p' ? primitive(single[2]!) : semantic(single[2]!);
		} else if (RegExp(r'^\[p\([^()]+\)(?:,\s*p\([^()]+\))*\]$').hasMatch(expression)) {
			value = [for (final match in RegExp(r'p\(([^()]+)\)').allMatches(expression)) primitive(match[1]!)];
		} else {
			final add = RegExp(r'^add\(s\(([^()]+)\),\s*s\(([^()]+)\)\)$').firstMatch(expression);
			if (add == null) _fail(id, 'unknown expression');
			final left = semantic(add[1]!), right = semantic(add[2]!);
			if (left is! num || right is! num) _fail(id, 'add requires two numbers');
			value = left + right;
		}
		if (!klpStyleParameters.containsKey(id)) _fail(id, 'missing catalog metadata');
		tokens[id] = _typed(value, _map(klpStyleParameters[id], id), id);
		active.remove(id);
		return tokens[id];
	}
	for (final id in semantics.keys) { semantic(id); }
	num number(String id) {
		final value = tokens[id];
		if (value is! num) _fail(id, 'constraint requires numeric token');
		return value;
	}
	for (final raw in _catalog['constraints'] as List) {
		final rule = _map(raw, 'constraint');
		if (rule['kind'] == 'ordered') {
			final ids = (rule['ids'] as List).cast<String>();
			for (var index = 1; index < ids.length; index++) {
				if (number(ids[index - 1]) > number(ids[index])) _fail(ids[index - 1], 'must not exceed ${ids[index]}');
			}
		} else if (rule['kind'] == 'fits') {
			final child = rule['child'] as String;
			final extent = number(child) + 2 * number(rule['inset'] as String);
			if (!extent.isFinite || (rule['containers'] as List).cast<String>().any((id) => extent > number(id))) _fail(child, 'does not fit containers');
		} else { _fail('constraint', 'unknown kind'); }
	}
	return tokens;
}

Object? _typed(Object? value, Map<String, Object?> metadata, String id) {
	final type = metadata['type'];
	if (['length', 'ratio', 'opacity', 'duration', 'weight', 'count'].contains(type)) {
		if (value is! num || !value.isFinite) _fail(id, 'expected finite $type');
		if (metadata['integer'] == true && value != value.roundToDouble()) _fail(id, 'expected integer');
		if (metadata['min'] is num && value < (metadata['min'] as num)) _fail(id, 'below minimum');
		if (metadata['max'] is num && value > (metadata['max'] as num)) _fail(id, 'above maximum');
		if (metadata['exclusiveMin'] is num && value <= (metadata['exclusiveMin'] as num)) _fail(id, 'must exceed minimum');
		return value;
	}
	final color = RegExp(r'^#(?:[\da-fA-F]{6}|[\da-fA-F]{8})$');
	if (type == 'curve') {
		if (value is String) {
			try { value = jsonDecode(value); } catch (_) { _fail(id, 'invalid curve JSON'); }
		}
		if (value is! List || value.length != 4 || !value.every((point) => point is num && point.isFinite)) _fail(id, 'expected four finite curve points');
		final points = value.cast<num>();
		if (points[0] < 0 || points[0] > 1 || points[2] < 0 || points[2] > 1) _fail(id, 'curve x coordinates outside [0,1]');
		return value;
	}
	if (type == 'color') {
		if (value is! String || !color.hasMatch(value)) _fail(id, 'expected color');
		return value;
	}
	if (type == 'font-family' || type == 'symbol') {
		if (value is! String || value.trim().isEmpty) _fail(id, 'expected $type string');
		return value;
	}
	if (type == 'font-family-array' || type == 'color-array') {
		if (value is! List || value.isEmpty || !value.every((item) => item is String && item.trim().isNotEmpty && (type != 'color-array' || color.hasMatch(item)))) _fail(id, 'invalid $type');
		return value;
	}
	_fail(id, 'unknown catalog type');
}
