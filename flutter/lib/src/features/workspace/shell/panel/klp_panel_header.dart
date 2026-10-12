import 'package:flutter/widgets.dart';

import 'package:kallopis/src/features/workspace/layout/klp_app_layout.dart';
import 'package:kallopis/src/foundation/layout/klp_layout.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';
import 'klp_panel_header_drag_region_builder.dart';

export 'klp_panel_header_drag_region_builder.dart';

part 'primitives/klp_panel_header_frame.dart';

/// 面板標題列；內容抓取區與右側操作各自擁有尺寸槽。
class KlpPanelHeader extends StatelessWidget {
	const KlpPanelHeader({
		super.key,
		this.title,
		this.content,
		this.label,
		this.leading,
		this.actions = const [],
		this.titleRole = KlpTextRole.header,
		this.dragRegionBuilder,
	}) : assert(title != null || content != null);

	/// 標準文字標題與自訂內容擇一；標籤保留原語意與次序。
	final String? title;
	final Widget? content;
	final String? label;
	/// 前置與操作內容由 caller 提供，庫只分配自己的槽。
	final Widget? leading;
	final List<Widget> actions;
	final KlpTextRole titleRole;
	/// 只包住標題／內容，不包含右側操作。
	final KlpPanelHeaderDragRegionBuilder? dragRegionBuilder;

	@override
	Widget build(BuildContext context) {
		final titleContent = content ?? Align(alignment: AlignmentDirectional.centerStart, child: SingleChildScrollView(
			child: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					KlpText(
						title!,
						role: titleRole,
						maxLines: 1,
						overflow: TextOverflow.ellipsis,
					),
					if (label != null) KlpText(
						label!,
						role: KlpTextRole.label,
						tone: KlpTextTone.faint,
						maxLines: 1,
						overflow: TextOverflow.ellipsis,
					),
				],
			),
		));
		final dragContent = dragRegionBuilder?.call(titleContent) ?? titleContent;
		return _KlpPanelHeaderFrame(child: LayoutRow(
			spacing: KlpLayoutSpacing.none,
			children: [
				if (leading != null) ...[
					_slot(leading!),
					_slot(const KlpGap.widthSize(KlpSpaceSize.chromeToolbar)),
				],
				KlpLayoutPane(size: KlpLayoutPaneSize.expand, child: dragContent),
				for (final action in actions) ...[
					_gap(context.klp.space.tight),
					_slot(action),
				],
			],
		));
	}

	/// 自然寬度的 chrome 槽；垂直仍以原內容大小置中。
	KlpLayoutPane _slot(Widget child) => KlpLayoutPane(
		size: KlpLayoutPaneSize.content,
		flex: 0,
		child: Center(child: child),
	);

	/// 明確間距也參與有限預算，不新增相鄰自動 gutter。
	KlpLayoutPane _gap(double extent) => KlpLayoutPane(
		size: KlpLayoutPaneSize.content,
		flex: 0,
		bounds: KlpLayoutBounds(preferred: extent, maximum: extent),
		child: const SizedBox.shrink(),
	);
}
