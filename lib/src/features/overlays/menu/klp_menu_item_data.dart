part of '../klp_menu.dart';

/// [KlpMenu] 裡的一個項目。
///
/// [toggleValue] 非 null 時項目會額外畫出一個開關指示，用於「這個選項本身是
/// 一個可切換設定」的情境（例如選單裡的「顯示隱藏檔案」）；[hasSubmenu] 只是
/// 畫出展開箭頭的視覺提示，實際的子選單彈出邏輯不歸這個資料類別管，由呼叫端
/// 自行處理 [onPressed]。[separatedBefore] 在這個項目之前插入一條分隔線，
/// 用來把選單切成語意上的幾組。
class KlpMenuItemData {
	const KlpMenuItemData({
		required this.label,
		required this.onPressed,
		this.key,
		this.icon,
		this.shortcut,
		this.toggleValue,
		this.hasSubmenu = false,
		this.danger = false,
		this.separatedBefore = false,
		this.dashedSeparatorBefore = false,
		this.selected = false,
		this.enabled = true,
	}) : assert(
				!separatedBefore || !dashedSeparatorBefore,
				'A menu item can only use one separator style.',
			);

	final String label;
	final VoidCallback onPressed;
	final Key? key;
	final KlpIconData? icon;
	final String? shortcut;
	final bool? toggleValue;
	final bool hasSubmenu;
	final bool danger;
	final bool separatedBefore;

	/// 在此項目前以虛線分組；不可與 [separatedBefore] 同時使用。
	final bool dashedSeparatorBefore;
	final bool selected;
	final bool enabled;
}
