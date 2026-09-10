part of '../klp_stepper.dart';

KlpStepStatus _resolveKlpStepStatus(int index, int currentIndex) {
	if (index < currentIndex) return KlpStepStatus.completed;
	if (index == currentIndex) return KlpStepStatus.current;
	return KlpStepStatus.upcoming;
}
