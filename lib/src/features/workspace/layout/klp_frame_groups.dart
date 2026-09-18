import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// Frame 內的內容群組容器；Frame 自身繼續維持零內距。
final class KlpFrameGroups implements KlpCompositeNode {

	static const String typeId = 'kallopis.frame_groups';
	static final groupSlot = KlpSlot<KlpFrameGroup>(owner: typeId, name: 'groups', min: 1);
	static final footerSlot = KlpSlot<KlpFrameGroup>(owner: typeId, name: 'footer', max: 1);

	@override
	final KlpId id;
	final List<KlpFrameGroup> groups;
	/// 固定於底部置中的操作群組；其餘群組於可用高度內捲動。
	final KlpFrameGroup? footer;
	@override
	final KlpChildren children;

	KlpFrameGroups({required this.id, required List<KlpFrameGroup> groups, this.footer})
		: groups = List.unmodifiable(groups),
			children = KlpChildren([groupSlot.assign(groups), footerSlot.assign([?footer])]);

	@override
	String get definitionId => typeId;
}

/// Frame 中一段具名內容；水平內距與前置分隔線由 [style] 決定。
final class KlpFrameGroup implements KlpCompositeNode {

	static const String typeId = 'kallopis.frame_group';
	static final childSlot = KlpSlot<KlpNode>(owner: typeId, name: 'content', min: 1);

	@override
	final KlpId id;
	final KlpFrameGroupStyle style;
	final List<KlpNode> content;
	@override
	final KlpChildren children;

	KlpFrameGroup({
		required this.id,
		required List<KlpNode> content,
		this.style = KlpFrameGroupStyle.defaultHorizontal,
	})
		: content = List.unmodifiable(content),
			children = KlpChildren([childSlot.assign(content)]);

	@override
	String get definitionId => typeId;
}

/// Frame 中用來建立功能分群與水平內距的公開 padding 元件。
///
/// 不接受原始幾何值；請以 [KlpPaddingStyle] 選取已核准的群組樣式。
typedef KlpPadding = KlpFrameGroup;

/// 群組內容可使用的水平內距；垂直節奏仍由內容元件擁有。
enum KlpFrameGroupPadding { none, standard }

/// [KlpPadding] 可選用的水平內距樣式。
typedef KlpPaddingHorizontal = KlpFrameGroupPadding;

/// 群組前的分隔線。第一群通常採 [invisible]。
enum KlpFrameGroupDivider { invisible, dashed, solid, transparentGap, sectionGap }
/// 群組內容之間的標準或無間距選項；不改變群組內距或定義原始距離。
enum KlpFrameGroupContentSpacing { none, standard }

/// [KlpPadding] 在群組前可選用的分隔線樣式。
typedef KlpPaddingDivider = KlpFrameGroupDivider;

/// Frame 內容群組的封閉樣式；不接受原始色彩、距離或 Flutter padding。
final class KlpFrameGroupStyle {

	static const defaultHorizontal = KlpFrameGroupStyle();
	static const noHorizontalPadding = KlpFrameGroupStyle(padding: KlpFrameGroupPadding.none);

	final KlpFrameGroupPadding padding;
	final KlpFrameGroupDivider divider;
	final KlpFrameGroupContentSpacing contentSpacing;

	const KlpFrameGroupStyle({
		this.padding = KlpFrameGroupPadding.standard,
		this.divider = KlpFrameGroupDivider.invisible,
		this.contentSpacing = KlpFrameGroupContentSpacing.none,
	});

	KlpFrameGroupStyle copyWith({KlpFrameGroupPadding? padding, KlpFrameGroupDivider? divider, KlpFrameGroupContentSpacing? contentSpacing}) => KlpFrameGroupStyle(
		padding: padding ?? this.padding,
		divider: divider ?? this.divider,
		contentSpacing: contentSpacing ?? this.contentSpacing,
	);
}

/// [KlpPadding] 的封閉樣式；不開放外部傳入原始 padding 或分隔線色彩。
typedef KlpPaddingStyle = KlpFrameGroupStyle;
