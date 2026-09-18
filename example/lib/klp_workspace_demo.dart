import 'package:kallopis/kallopis_declarative.dart';
import 'catalog_declarative/catalog_application.dart';
import 'workspace_demo/sample_content.dart';

/// Frame 角色與零內距樣板；文字元件本身不提供 padding。
/// 深色使用 --dart-define=WORKSPACE_DARK=true。
void main() => runCatalog(stage: KlpAppLayout(
	id: KlpId.parse('frame_demo.layout'),
	child: LayoutRow(id: KlpId.parse('frame_demo.row'), children: [
		KlpAppFrame(
			id: KlpId.parse('frame_demo.sidebar'),
			role: KlpAppFrameRole.auxiliary,
			child: _groups('navigation', sampleContent(KlpId.parse('frame_demo.navigation'), '輔助區\n\n內容元件未設定 padding\nFrame 不額外縮排')),
		),
		LayoutResizeHandle(id: KlpId.parse('frame_demo.handle')),
		KlpAppFrame(
			id: KlpId.parse('frame_demo.stage'),
			flex: 3,
			child: _groups('content', sampleContent(KlpId.parse('frame_demo.content'), '主內容區\n\n外距 12 · 欄距 12 · 圓角 12px\nFrame 內距 0，由內部子元件決定 padding。')),
		),
	]),
));

KlpFrameGroups _groups(String id, KlpNode child) => KlpFrameGroups(
	id: KlpId.parse('frame_demo.$id.groups'),
	groups: [KlpFrameGroup(id: KlpId.parse('frame_demo.$id.group'), content: [child])],
);
