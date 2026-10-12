/// 視窗控制鈕已解析的幾何介面。
class KlpWindowControlsGeometry {
	const KlpWindowControlsGeometry({required this.extent});

	final double extent;

	// 圖示恢復為按鈕範圍的一半，預設 24 的按鈕搭配 12 的圖示。
	double get iconExtent => extent / 2;
}
