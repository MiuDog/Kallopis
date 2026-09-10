part of '../klp_editor_action_bars.dart';

/// 僅供編輯器動作列共用的中性表面。
class _KlpEditorActionSurface extends StatelessWidget {
	const _KlpEditorActionSurface({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return KlpBox(
			tone: KlpSurfaceTone.component,
			paddingSize: KlpSpaceSize.contentInset,
			child: child,
		);
	}
}
