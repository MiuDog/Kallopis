part of 'klp_finite_workflow.dart';

/// 建立可回復焦點的邊界；對話框或導覽完成後可呼叫 [requestFocus]。
class KlpFocusBoundary extends StatefulWidget {
	const KlpFocusBoundary({super.key, required this.child, this.autofocus = false});

	final Widget child;
	final bool autofocus;

	static void requestFocus(BuildContext context) {
		context.findAncestorStateOfType<_KlpFocusBoundaryState>()?.requestFocus();
	}

	@override
	State<KlpFocusBoundary> createState() => _KlpFocusBoundaryState();
}
