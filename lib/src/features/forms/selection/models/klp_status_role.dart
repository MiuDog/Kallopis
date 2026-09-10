/// Kallopis 提供的狀態色彩角色。
enum KlpStatusRole {
	success,
	danger,
	warning,
	info;

	/// 色票旁顯示的穩定角色名稱。
	String get label => name.toUpperCase();
}
