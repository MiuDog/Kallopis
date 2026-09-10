part of '../klp_file_explorer.dart';

/// Explorer 的語意間距配方，避免消費者注入 Flutter 幾何物件。
enum KlpFileExplorerSpacing {
	/// 一般獨立 Explorer 的導覽內距。
	standard,

	/// 需要較寬樹狀層級節奏的 Explorer。
	relaxed,

	/// 已由外層 Panel 提供 gutter 時使用的貼齊配方。
	flush;

	double indent(BuildContext context) => switch (this) {
		KlpFileExplorerSpacing.relaxed => context.klp.space.base,
		KlpFileExplorerSpacing.standard ||
		KlpFileExplorerSpacing.flush => context.klp.space.tight,
	};

	KlpBoxInsets sectionPadding(BuildContext context) => switch (this) {
		KlpFileExplorerSpacing.standard => KlpBoxInsets.directional(
			start: context.klp.space.navigationItemInset,
			end: context.klp.space.navigationItemInset,
		),
		KlpFileExplorerSpacing.relaxed => KlpBoxInsets.directional(
			start: context.klp.space.navigationItemInset,
			end: context.klp.space.navigationItemInset,
		),
		KlpFileExplorerSpacing.flush => const KlpBoxInsets.directional(),
	};

	KlpBoxInsets sectionMargin(BuildContext context) => switch (this) {
		KlpFileExplorerSpacing.standard => const KlpBoxInsets.directional(),
		KlpFileExplorerSpacing.relaxed => const KlpBoxInsets.directional(),
		KlpFileExplorerSpacing.flush => KlpBoxInsets.directional(
			start: context.klp.space.hairline,
			end: context.klp.space.hairline,
		),
	};

	KlpBoxInsets itemPadding(BuildContext context) => switch (this) {
		KlpFileExplorerSpacing.standard => KlpBoxInsets.directional(
			start: context.klp.space.navigationItemInset,
			top: context.klp.space.hairline,
			end: context.klp.space.navigationItemInset,
			bottom: context.klp.space.hairline,
		),
		KlpFileExplorerSpacing.relaxed => KlpBoxInsets.directional(
			start: context.klp.space.navigationItemInset,
			top: context.klp.space.hairline,
			end: context.klp.space.navigationItemInset,
			bottom: context.klp.space.hairline,
		),
		KlpFileExplorerSpacing.flush => const KlpBoxInsets.directional(),
	};
}
