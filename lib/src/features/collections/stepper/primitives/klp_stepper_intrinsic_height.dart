part of '../klp_stepper.dart';

class _KlpStepperIntrinsicHeight extends StatelessWidget {
	const _KlpStepperIntrinsicHeight({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) => IntrinsicHeight(child: child);
}
