part of '../klp_oklch_color_picker.dart';

class _OklchPlane extends StatefulWidget {
	const _OklchPlane({
		required this.kind,
		required this.label,
		required this.value,
		required this.chromaRange,
		required this.onChanged,
	});

	final _OklchPlaneKind kind;
	final String label;
	final KlpOklchColor value;
	final KlpOklchChromaRange chromaRange;
	final ValueChanged<KlpOklchColor>? onChanged;

	@override
	State<_OklchPlane> createState() => _OklchPlaneState();
}
