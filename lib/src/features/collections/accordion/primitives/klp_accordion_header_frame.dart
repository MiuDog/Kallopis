part of '../klp_accordion.dart';

class _KlpAccordionHeaderFrame extends StatefulWidget {
	const _KlpAccordionHeaderFrame({
		required this.expanded,
		required this.onTap,
		required this.child,
	});

	final bool expanded;
	final VoidCallback onTap;
	final Widget child;

	@override
	State<_KlpAccordionHeaderFrame> createState() =>
			_KlpAccordionHeaderFrameState();
}
