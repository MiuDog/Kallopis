part of 'klp_geometric_spinner.dart';

/// 管理幾何載入圖示的循環動畫與 reduced-motion 狀態。
class _KlpGeometricSpinnerState extends State<KlpGeometricSpinner>
		with SingleTickerProviderStateMixin {
	late final AnimationController _controller;

	@override
	void initState() {
		super.initState();
		_controller = AnimationController(vsync: this);
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		_controller.duration = widget.duration ?? context.klp.motion.spinnerCycle;
		if (context.klp.motion.stateTransition == Duration.zero) {
			_controller.stop();
		} else if (!_controller.isAnimating) {
			_controller.repeat();
		}
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		final effectiveSize = widget.size ?? klp.space.iconLarge;
		final effectivePrimary = widget.color ?? tokens.accent;
		final effectiveContrast = widget.contrastColor ?? tokens.interaction;
		final reduceMotion = klp.motion.stateTransition == Duration.zero;

		if (reduceMotion) {
			return Center(
				child: SizedBox.square(
					dimension: effectiveSize,
					child: CustomPaint(
						size: Size.square(effectiveSize),
						painter: _GeometricSpinnerPainter(
							progress: 0.0,
							primaryColor: effectivePrimary,
							contrastColor: effectiveContrast,
							squareFactor: klp.geometry.data.spinnerSquareFactor,
							orbitFactor: klp.geometry.data.spinnerOrbitFactor,
							cornerFactor: klp.geometry.data.spinnerCornerFactor,
						),
					),
				),
			);
		}

		return Center(
			child: SizedBox.square(
				dimension: effectiveSize,
				child: AnimatedBuilder(
					animation: _controller,
					builder: (context, child) {
						return CustomPaint(
							size: Size.square(effectiveSize),
							painter: _GeometricSpinnerPainter(
								progress: _controller.value,
								primaryColor: effectivePrimary,
								contrastColor: effectiveContrast,
								squareFactor: klp.geometry.data.spinnerSquareFactor,
								orbitFactor: klp.geometry.data.spinnerOrbitFactor,
								cornerFactor: klp.geometry.data.spinnerCornerFactor,
							),
						);
					},
				),
			),
		);
	}
}
