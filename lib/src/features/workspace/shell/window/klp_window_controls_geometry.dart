/// 視窗控制鈕已解析的幾何介面。
class KlpWindowControlsGeometry {
	const KlpWindowControlsGeometry({required this.extent});

	final double extent;

	double get iconExtent => extent / 2;
}
