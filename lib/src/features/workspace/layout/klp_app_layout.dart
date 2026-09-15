import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_screen_body.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/features/workspace/layout/klp_frame_groups.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_block.dart';

/// App background 上第一層的受控布局根；不建立預設 Header。
final class KlpAppLayout implements KlpCompositeNode, KlpScreenBody {

	static const String typeId = 'kallopis.app_layout';
	static final childSlot = KlpSlot<KlpLayoutNode>(owner: typeId, name: 'child', min: 1, max: 1);
	static final floatingActionSlot = KlpSlot<KlpWorkspaceBlock>(owner: typeId, name: 'floatingAction', max: 1);

	@override
	final KlpId id;
	final KlpLayoutNode child;
	/// 可拖曳的浮動操作；位置由呈現層維護，內容仍屬同一棵結構樹。
	final KlpWorkspaceBlock? floatingAction;
	/// 頂部空白區要求宿主開始原生拖曳；互動元件不觸發。
	final void Function()? onHeaderDrag;
	@override
	final KlpChildren children;

	KlpAppLayout({required this.id, required this.child, this.onHeaderDrag, this.floatingAction}) : children = KlpChildren([childSlot.assign([child]), floatingActionSlot.assign([?floatingAction])]) {
		if (floatingAction != null && floatingAction!.kind != KlpWorkspaceBlockKind.action) throw ArgumentError.value(floatingAction, 'floatingAction', 'Floating content must be an action.');
	}

	@override
	String get definitionId => typeId;
}

/// 可置於 [KlpAppLayout] 的純資料布局節點資格。
abstract interface class KlpLayoutNode implements KlpCompositeNode {}

/// 在主軸上水平排列受控布局節點。
final class LayoutRow implements KlpLayoutNode {

	static const String typeId = 'kallopis.layout_row';
	static final childSlot = KlpSlot<KlpLayoutNode>(owner: typeId, name: 'children', min: 1);

	@override
	final KlpId id;
	final int flex;
	final KlpLayoutMainAlignment alignment;
	final KlpLayoutSpacing spacing;
	@override
	final KlpChildren children;

	LayoutRow({required this.id, required List<KlpLayoutNode> children, this.flex = 1, this.alignment = KlpLayoutMainAlignment.start, this.spacing = KlpLayoutSpacing.standard}) : children = KlpChildren([childSlot.assign(children)]) {
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	@override
	String get definitionId => typeId;
}

/// 水平布局的主軸起端或末端對齊選項；不定義原始幾何位置。
enum KlpLayoutMainAlignment { start, end }
/// 線性布局的標準或無間距選項；實際距離由本庫語意樣式決定。
enum KlpLayoutSpacing { standard, none }

/// 在主軸上垂直排列受控布局節點。
final class LayoutColumn implements KlpLayoutNode {

	static const String typeId = 'kallopis.layout_column';
	static final childSlot = KlpSlot<KlpLayoutNode>(owner: typeId, name: 'children', min: 1);

	@override
	final KlpId id;
	final int flex;
	final KlpLayoutSpacing spacing;
	@override
	final KlpChildren children;

	LayoutColumn({required this.id, required List<KlpLayoutNode> children, this.flex = 1, this.spacing = KlpLayoutSpacing.standard}) : children = KlpChildren([childSlot.assign(children)]) {
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	@override
	String get definitionId => typeId;
}

/// 取代相鄰 node 自動 gutter 的固定尺寸 resize 槽；本輪不提供手勢。
final class LayoutResizeHandle implements KlpLayoutNode {

	static const String typeId = 'kallopis.layout_resize_handle';

	@override
	final KlpId id;

	const LayoutResizeHandle({required this.id});

	@override
	KlpChildren get children => KlpChildren(const []);

	@override
	String get definitionId => typeId;
}

/// 線性布局中不承載內容的彈性空間。
final class LayoutSpacer implements KlpLayoutNode {
	static const String typeId = 'kallopis.layout_spacer';
	@override
	final KlpId id;
	final int flex;
	LayoutSpacer({required this.id, this.flex = 1}) {
		if (flex < 1) throw ArgumentError.value(flex, 'flex', 'Spacer flex must be positive.');
	}
	@override
	KlpChildren get children => KlpChildren(const []);
	@override
	String get definitionId => typeId;
}

/// 布局欄的尺寸角色選項；不承載原始寬度或自行管理拖曳尺寸。
enum KlpLayoutPaneSize { trailing, content, expand }

/// 不帶材質的受控布局欄，可承載具水平內距的群組。
final class KlpLayoutPane implements KlpLayoutNode {
	static const String typeId = 'kallopis.layout_pane';
	static final childSlot = KlpSlot<KlpFrameGroups>(owner: typeId, name: 'child', min: 1, max: 1);
	@override
	final KlpId id;
	final KlpFrameGroups child;
	final KlpLayoutPaneSize size;
	final int flex;
	@override
	final KlpChildren children;
	KlpLayoutPane({required this.id, required this.child, this.size = KlpLayoutPaneSize.trailing, int? flex})
		: flex = flex ?? (size == KlpLayoutPaneSize.expand ? 1 : 0),
			children = KlpChildren([childSlot.assign([child])]) {
		if (this.flex < 0) throw ArgumentError.value(this.flex, 'flex', 'Layout flex must not be negative.');
	}
	@override
	String get definitionId => typeId;
}

/// Frame 的內容主次角色，不綁定左右位置。
enum KlpAppFrameRole { content, auxiliary, sidebar, rightSidebar, toolbarControls }

/// Frame 表面選項；微立體的陰影與亮邊由本庫解析。
enum KlpAppFrameSurface { flat, raised }

/// 僅可作為 app background 第一層布局節點的具名 frame。
final class KlpAppFrame implements KlpLayoutNode {

	static const String typeId = 'kallopis.app_frame';
	static final childSlot = KlpSlot<KlpFrameGroups>(owner: typeId, name: 'child', min: 1, max: 1);

	@override
	final KlpId id;
	final KlpFrameGroups child;
	final KlpAppFrameRole role;
	final KlpAppFrameSurface surface;
	final int flex;
	@override
	final KlpChildren children;

	KlpAppFrame({required this.id, required this.child, this.flex = 1, this.role = KlpAppFrameRole.content, this.surface = KlpAppFrameSurface.flat}) : children = KlpChildren([childSlot.assign([child])]) {
		if (flex < 0) throw ArgumentError.value(flex, 'flex', 'Layout flex must not be negative.');
	}

	@override
	String get definitionId => typeId;
}
