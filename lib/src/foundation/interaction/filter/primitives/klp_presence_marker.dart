part of '../klp_presence_indicator.dart';

class _KlpPresenceMarker extends StatelessWidget {
	const _KlpPresenceMarker({required this.active});

	final bool active;

	@override
	Widget build(BuildContext context) {
		final color = active
				? context.klpColors.success
				: context.klpColors.textFaint;
		final extent = context.klp.geometry.control.presenceMarkerExtent;

		return Container(
			width: extent,
			height: extent,
			decoration: BoxDecoration(
				color: color,
				borderRadius: BorderRadius.circular(context.klp.shape.pill),
			),
		);
	}
}
