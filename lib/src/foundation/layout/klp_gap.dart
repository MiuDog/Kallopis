import 'package:flutter/widgets.dart';

import '../../styling/legacy_theme/klp_theme.dart';
import 'klp_space_size.dart';

/// 間距排版原語。取代 SizedBox 進行彈性與固定距離佔位。
/// 支援風格介面與風格枚舉（KlpSpaceSize）為第一優先真相。
class KlpGap extends StatelessWidget {
	/// 依據傳統彈性數值指定雙向間距。
	const KlpGap(this.extent, {super.key})
			: size = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 依據風格枚舉指定雙向間距。
	const KlpGap.space(this.size, {super.key})
			: extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 依據彈性數值指定水平寬度間距。
	const KlpGap.width(this.width, {super.key})
			: size = null,
				extent = null,
				widthSize = null,
				heightSize = null,
				height = null;

	/// 依據彈性數值指定垂直高度間距。
	const KlpGap.height(this.height, {super.key})
			: size = null,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null;

	/// 依據風格枚舉指定水平寬度間距。
	const KlpGap.widthSize(this.widthSize, {super.key})
			: size = null,
				extent = null,
				heightSize = null,
				width = null,
				height = null;

	/// 依據風格枚舉指定垂直高度間距。
	const KlpGap.heightSize(this.heightSize, {super.key})
			: size = null,
				extent = null,
				widthSize = null,
				width = null,
				height = null;

	/// 快捷建構子：微細間距
	const KlpGap.hairline({super.key})
			: size = KlpSpaceSize.hairline,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 快捷建構子：緊密間距
	const KlpGap.tight({super.key})
			: size = KlpSpaceSize.tight,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 快捷建構子：標準間距
	const KlpGap.base({super.key})
			: size = KlpSpaceSize.base,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 快捷建構子：舒適間距
	const KlpGap.comfortable({super.key})
			: size = KlpSpaceSize.comfortable,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 快捷建構子：鬆散間距
	const KlpGap.loose({super.key})
			: size = KlpSpaceSize.loose,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 快捷建構子：區塊間距
	const KlpGap.section({super.key})
			: size = KlpSpaceSize.section,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 快捷建構子：內容行內間距
	const KlpGap.inline({super.key})
			: size = KlpSpaceSize.contentInline,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	/// 快捷建構子：內容堆疊間距
	const KlpGap.stack({super.key})
			: size = KlpSpaceSize.contentStack,
				extent = null,
				widthSize = null,
				heightSize = null,
				width = null,
				height = null;

	final KlpSpaceSize? size;
	final double? extent;
	final KlpSpaceSize? widthSize;
	final KlpSpaceSize? heightSize;
	final double? width;
	final double? height;

	@override
	Widget build(BuildContext context) {
		if (width != null) return SizedBox(width: width);
		if (height != null) return SizedBox(height: height);
		if (widthSize != null) {
			final w = resolveSpace(context, widthSize!);
			return SizedBox(width: w);
		}
		if (heightSize != null) {
			final h = resolveSpace(context, heightSize!);
			return SizedBox(height: h);
		}
		if (size != null) {
			final s = resolveSpace(context, size!);
			return SizedBox(width: s, height: s);
		}
		final s = extent ?? context.klp.space.base;
		return SizedBox(width: s, height: s);
	}

	/// 介面解析器：將風格枚舉映射至目前 Theme 的單一真相來源
	static double resolveSpace(BuildContext context, KlpSpaceSize spaceSize) {
		final space = context.klp.space;
		return switch (spaceSize) {
			KlpSpaceSize.xxs => space.xxs,
			KlpSpaceSize.hairline => space.hairline,
			KlpSpaceSize.tight => space.tight,
			KlpSpaceSize.base => space.base,
			KlpSpaceSize.item => space.itemGap,
			KlpSpaceSize.comfortable => space.comfortable,
			KlpSpaceSize.loose => space.loose,
			KlpSpaceSize.section => space.section,
			KlpSpaceSize.sectionLarge => space.sectionLarge,
			KlpSpaceSize.page => space.page,
			KlpSpaceSize.contentInset => space.contentInset,
			KlpSpaceSize.contentInline => space.contentInlineGap,
			KlpSpaceSize.contentStack => space.contentStackGap,
			KlpSpaceSize.action => space.actionGap,
			KlpSpaceSize.controlContent => space.controlContentGap,
			KlpSpaceSize.overlayHeading => space.overlayHeadingGap,
			KlpSpaceSize.chromeToolbar => space.chromeToolbarGap,
			KlpSpaceSize.navigationRailItem => space.navigationRailItemGap,
			KlpSpaceSize.navigationRailControl => space.railItem,
			KlpSpaceSize.commandMenuWidth => context.klp.geometry.layout.commandMenuWidth,
			KlpSpaceSize.toastIconSlot => space.toastIconSlot,
			KlpSpaceSize.skeletonLine => space.skeletonLine,
			KlpSpaceSize.placeholderAction => space.tight * 2,
		};
	}
}
