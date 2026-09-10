import 'klp_form_dependencies.dart';

part 'klp_input_frame_state.dart';
part 'primitives/klp_input_frame_surface.dart';

/// Form recipe 共用的輸入外框，不屬於公開元件 API。
class KlpInputFrame extends StatefulWidget {
	final String label;
	final Widget child;
	final bool enabled;
	final bool readOnly;
	final String? error;

	const KlpInputFrame({
		super.key,
		required this.label,
		required this.child,
		required this.enabled,
		required this.readOnly,
		this.error,
	});

	@override
	State<KlpInputFrame> createState() => _KlpInputFrameState();
}
