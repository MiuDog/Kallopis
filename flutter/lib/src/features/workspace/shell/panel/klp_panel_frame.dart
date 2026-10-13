import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:kallopis/src/features/workspace/layout/klp_app_layout.dart';

import 'package:kallopis/src/foundation/layout/klp_panel_layout.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'klp_panel_footer.dart';
import 'package:kallopis/src/styling/presets/klp_frame_relief_recipe.dart';
import 'klp_panel_header_size.dart';
import 'klp_panel_tone.dart';

export 'klp_panel_header_size.dart';
export 'klp_panel_tone.dart';

part 'primitives/klp_panel_frame_view.dart';

/// 面板表面層次；raised 使用既有微立體陰影與亮邊。
enum KlpPanelElevation { flat, raised }

/// 通用面板：header 與 content，選用 footer。
///
/// 消費者只選擇語意背景與 header 尺寸；外距、圓角、裁切、footer 高度與
/// scrollbar 全由 Kallopis token 與 primitive frame 決定。
class KlpPanelFrame extends StatelessWidget implements KlpPanelLayout {
	const KlpPanelFrame({
		super.key,
		this.header,
		required this.content,
		this.footer,
		this.headerSize = KlpPanelHeaderSize.standard,
		this.tone = KlpPanelTone.surface,
		this.elevation = KlpPanelElevation.flat,
		this.contentScrollController,
	});

	final Widget? header;
	final Widget content;
	final Widget? footer;
	final KlpPanelHeaderSize headerSize;
	final KlpPanelTone tone;

	/// 僅改變表面層次，不改布局與內容裁切。
	final KlpPanelElevation elevation;

	/// 內容區的捲動控制器。提供時，Frame 只負責繪製 Scrollbar；內容的
	/// 內距由 [content] 自己決定。
	final ScrollController? contentScrollController;

	@override
	Widget build(BuildContext context) {
		return _KlpPanelFrameView(
			header: header,
			content: content,
			footer: footer,
			headerSize: headerSize,
			tone: tone,
			elevation: elevation,
			contentScrollController: contentScrollController,
		);
	}

	@override
	Widget buildPanelLayout(BuildContext context) => build(context);
}
