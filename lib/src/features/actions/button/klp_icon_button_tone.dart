/// 圖示按鈕在版面中的角色，不是外觀參數。
enum KlpIconButtonTone {
	/// 獨立控制項：靜置時就有底色，讓它在空白區域中可辨識。
	standalone,

	/// 嵌在既有表面上：靜置透明，只在互動或選取時浮出底色。
	inline,
}
