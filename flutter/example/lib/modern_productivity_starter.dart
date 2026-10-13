import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

/// 可複製到 consumer 的最小接線；所有業務狀態由產品持有。
class ModernProductivityStarter extends StatefulWidget {
	/* sidebarWidth：局部模板期望寬度；省略時沿用主題。 */
	final double? sidebarWidth;
	const ModernProductivityStarter({super.key, this.sidebarWidth});
	@override
	State<ModernProductivityStarter> createState() => _ModernProductivityStarterState();
}

class _ModernProductivityStarterState extends State<ModernProductivityStarter> {
	/* _selected：受控功能；_navigation／_tools：作品自己的草稿，不因調整樣式重建。 */
	String _selected = 'navigation';
	final _navigation = TextEditingController();
	final _tools = TextEditingController();
	@override
	void dispose() { _navigation.dispose(); _tools.dispose(); super.dispose(); }
	@override
	Widget build(BuildContext context) {
		final inset = context.klp.space.contentInset;
		return KlpModernProductivityLayout(
			sidebarWidth: widget.sidebarWidth,
			selectedId: _selected,
			onSelected: (id) => setState(() => _selected = id),
			panels: [
				KlpModernProductivityPanel(id: 'navigation', label: '導航', content: _panel('導航草稿', _navigation)),
				KlpModernProductivityPanel(id: 'tools', label: '工具', content: _panel('工具草稿', _tools)),
			],
			header: Padding(padding: EdgeInsets.all(inset), child: const Align(alignment: Alignment.centerLeft, child: KlpText('現代風生產力佈局'))),
			stage: Padding(padding: EdgeInsets.all(inset), child: const Align(alignment: Alignment.topLeft, child: KlpText('Stage：替換成你的作品內容。工具功能已整合在左側欄。'))),
		);
	}
	Widget _panel(String label, TextEditingController controller) => SingleChildScrollView(child: Padding(padding: EdgeInsets.all(context.klp.space.contentInset), child: TextField(controller: controller, style: KlpTextStyles.definitionOf(KlpTextRole.body, context.klp.type).toTextStyle(context.klp.type), decoration: InputDecoration(labelText: label, labelStyle: KlpTextStyles.definitionOf(KlpTextRole.label, context.klp.type).toTextStyle(context.klp.type)))));
}
