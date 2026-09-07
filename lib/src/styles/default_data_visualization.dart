part of '../theme/klp_data_visualization_theme.dart';

/// 此分類的預設風格 recipe；schema 的公開 static 成員保留相同值與 const 契約。

const KlpDataVisualizationTheme _defaultDataVisualizationLight =
		KlpDataVisualizationTheme(
			series: [
				KlpPalette.sand500,
				KlpPalette.gold500,
				KlpPalette.ochre500,
				KlpPalette.terracotta500,
				KlpPalette.clay500,
				KlpPalette.umber500,
			],
			seriesWash: [
				KlpPalette.sand50,
				KlpPalette.gold50,
				KlpPalette.ochre50,
				KlpPalette.terracotta50,
				KlpPalette.clay50,
				KlpPalette.umber50,
			],
			axis: KlpPalette.warmNeutral100,
			grid: KlpPalette.warmNeutral50,
			gridStrong: KlpPalette.warmNeutral200,
			label: KlpPalette.ink550,
			value: KlpPalette.ink900,
			plotBackground: KlpPalette.transparent,
			crosshair: KlpPalette.warmNeutral450,
			marketUp: KlpPalette.green600,
			marketUpWash: KlpPalette.green100,
			marketDown: KlpPalette.red600,
			marketDownWash: KlpPalette.red100,
			marketFlat: KlpPalette.warmNeutral450,
		);

const KlpDataVisualizationTheme _defaultDataVisualizationDark =
		KlpDataVisualizationTheme(
			series: [
				KlpPalette.sand300,
				KlpPalette.gold300,
				KlpPalette.ochre300,
				KlpPalette.terracotta300,
				KlpPalette.clay300,
				KlpPalette.umber300,
			],
			seriesWash: [
				KlpPalette.sand800,
				KlpPalette.gold800,
				KlpPalette.ochre800,
				KlpPalette.terracotta800,
				KlpPalette.clay800,
				KlpPalette.umber800,
			],
			axis: KlpPalette.warmNeutral700,
			grid: KlpPalette.warmNeutral800,
			gridStrong: KlpPalette.warmNeutral600,
			label: KlpPalette.warmNeutral300,
			value: KlpPalette.warmNeutral25,
			plotBackground: KlpPalette.transparent,
			crosshair: KlpPalette.warmNeutral400,
			marketUp: KlpPalette.green400,
			marketUpWash: KlpPalette.green800,
			marketDown: KlpPalette.red400,
			marketDownWash: KlpPalette.red800,
			marketFlat: KlpPalette.warmNeutral400,
		);

const KlpDataVisualizationTheme _defaultDataVisualizationUltraDark =
		KlpDataVisualizationTheme(
			series: [
				KlpPalette.sand300,
				KlpPalette.gold300,
				KlpPalette.ochre300,
				KlpPalette.terracotta300,
				KlpPalette.clay300,
				KlpPalette.umber300,
			],
			seriesWash: [
				KlpPalette.sand900,
				KlpPalette.gold900,
				KlpPalette.ochre900,
				KlpPalette.terracotta900,
				KlpPalette.clay900,
				KlpPalette.umber900,
			],
			axis: KlpPalette.warmNeutral750,
			grid: KlpPalette.warmNeutral900,
			gridStrong: KlpPalette.warmNeutral700,
			label: KlpPalette.warmNeutral300,
			value: KlpPalette.warmNeutral25,
			plotBackground: KlpPalette.transparent,
			crosshair: KlpPalette.warmNeutral500,
			marketUp: KlpPalette.green400,
			marketUpWash: KlpPalette.green900,
			marketDown: KlpPalette.red400,
			marketDownWash: KlpPalette.red900,
			marketFlat: KlpPalette.warmNeutral500,
		);
