part of '../klp_command_menu.dart';

/// 命令面板：分組的指令清單，存在的意義就是不用滑鼠也能操作。
///
/// **鍵盤**：`↓`／`↑` 在（跨分組攤平後的）項目間移動高亮，跳過
/// [KlpCommandItemData.onPressed] 為 `null`（停用）的項目，並在頭尾之間循環；
/// `Home`／`End` 跳到第一／最後一個可用項目；`Enter`／`Space` 觸發目前高亮的
/// 項目；`Escape` 呼叫 [onEscape]。索引移動規則沿用 [KlpRovingIndex]，與
/// [KlpMenu]、[KlpCombobox] 共用同一套實作。
///
/// 面板預設會在出現時自動取得鍵盤焦點（[autofocus]），因為命令面板通常是剛彈出
/// 的 overlay。
class KlpCommandMenu extends StatefulWidget {
	const KlpCommandMenu({
		super.key,
		required this.sections,
		this.framed = true,
		this.autofocus = true,
		this.onEscape,
	});

	final List<KlpCommandSectionData> sections;
	final bool framed;

	/// 是否在面板出現時自動取得鍵盤焦點。預設 `true`。
	final bool autofocus;

	/// 按下 `Escape` 時呼叫，通常由呼叫端用來關閉面板；未提供時無效果。
	final VoidCallback? onEscape;

	@override
	State<KlpCommandMenu> createState() => _KlpCommandMenuState();
}
