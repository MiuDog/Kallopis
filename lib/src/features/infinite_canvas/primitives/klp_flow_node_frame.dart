part of '../klp_canvas_workspace.dart';

class _KlpFlowNodeFrame extends StatelessWidget {
	const _KlpFlowNodeFrame({
		required this.selected,
		required this.onPressed,
		required this.child,
	});

	final bool selected;
	final VoidCallback? onPressed;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return Semantics(
			button: onPressed != null,
			selected: selected,
			child: GestureDetector(
				onTap: onPressed,
				child: KlpSurface(
					tone: selected
							? KlpSurfaceTone.raised
							: KlpSurfaceTone.component,
					border: Border.all(
						color: selected ? klp.color.selection : klp.color.divider,
						width: klp.shape.hairline,
					),
					padding: EdgeInsets.all(klp.space.contentInset),
					child: child,
				),
			),
		);
	}
}
