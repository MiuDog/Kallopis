part of '../klp_navigator.dart';

class _KlpNavigatorElementView extends StatefulWidget {
	const _KlpNavigatorElementView({required this.element, required this.level});

	final KlpNavigatorElement element;
	final int level;

	@override
	State<_KlpNavigatorElementView> createState() => _KlpNavigatorElementViewState();
}
