part of 'klp_stepper.dart';

/// 步驟流程指示。依 [currentIndex] 把 [steps] 分成已完成／進行中／未開始三態。
///
/// 純顯示元件——不持有互動狀態，也不處理點擊；切換到下一步是呼叫端更新
/// [currentIndex] 後重建的結果。[direction] 決定排列方向。
class KlpStepper extends StatelessWidget {
	const KlpStepper({
		super.key,
		required this.steps,
		required this.currentIndex,
		this.direction = KlpStepperDirection.horizontal,
	});

	final List<KlpStepData> steps;
	final int currentIndex;
	final KlpStepperDirection direction;

	@override
	Widget build(BuildContext context) {
		assert(steps.isNotEmpty, 'KlpStepper 至少需要一個步驟');
		assert(
			currentIndex >= 0 && currentIndex < steps.length,
			'currentIndex 必須落在 steps 範圍內',
		);

		return switch (direction) {
			KlpStepperDirection.horizontal => _KlpStepperHorizontalLayout(
				steps: steps,
				currentIndex: currentIndex,
			),
			KlpStepperDirection.vertical => _KlpStepperVerticalLayout(
				steps: steps,
				currentIndex: currentIndex,
			),
		};
	}
}
