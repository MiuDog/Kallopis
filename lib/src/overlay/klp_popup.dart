import 'package:flutter/widgets.dart';

import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';

/// Popup 面板的固定尺寸種類。
enum KlpPopupPanelKind { standard, large }

/// 供 App frame 注入視窗標題列保留範圍。
class KlpPopupInteractionScope extends InheritedWidget {
	const KlpPopupInteractionScope({
		super.key,
		required this.topInset,
		required super.child,
	});

	final double topInset;

	static double topInsetOf(BuildContext context) =>
		context.dependOnInheritedWidgetOfExactType<KlpPopupInteractionScope>()?.topInset ?? 0;

	@override
	bool updateShouldNotify(KlpPopupInteractionScope oldWidget) => topInset != oldWidget.topInset;
}

/// Popup 的背景遮罩。點擊 panel 以外的可互動背景時呼叫 [onDismiss]。
///
/// 若位於 [KlpPopupInteractionScope] 之下，scope 的頂部範圍只負責顯示遮罩，
/// 不會接收 pointer，因此視窗標題列的拖動與雙擊事件優先。
class KlpPopupBackground extends StatelessWidget {
	const KlpPopupBackground({
		super.key,
		required this.child,
		required this.onDismiss,
	});

	final KlpPopupPanel child;
	final VoidCallback onDismiss;

	@override
	Widget build(BuildContext context) {
		final topInset = KlpPopupInteractionScope.topInsetOf(context);
		final scrim = context.klp.color.modalScrim.withValues(
			alpha: context.klp.surface.scrimOpacity,
		);

		return Stack(
			fit: StackFit.expand,
			children: [
				IgnorePointer(child: ColoredBox(color: scrim)),
				Positioned.fill(
					top: topInset,
					child: GestureDetector(
						behavior: HitTestBehavior.opaque,
						onTap: onDismiss,
					),
				),
				Positioned.fill(
					top: topInset,
					child: Center(child: child),
				),
			],
		);
	}
}

/// Popup 的固定尺寸 surface。內容內距由 [child] 自己擁有。
class KlpPopupPanel extends StatelessWidget {
	const KlpPopupPanel({
		super.key,
		required this.kind,
		required this.child,
	});

	/// 普通表單面板固定為 600×816，對應建立頻道等完整輸入流程。
	static const Size standardSize = Size(600, 816);
	static const Size largeSize = Size(1064, 880);

	final KlpPopupPanelKind kind;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: (context, constraints) {
				final size = kind == KlpPopupPanelKind.large ? largeSize : standardSize;
				final isFullPage = kind == KlpPopupPanelKind.large &&
					(constraints.maxWidth < size.width || constraints.maxHeight < size.height);
				final surface = isFullPage
					? ColoredBox(color: context.klp.color.overlay, child: child)
					: KlpSurface(
						tone: KlpSurfaceTone.overlay,
						radius: context.klp.shape.panel,
						child: child,
					);

				return isFullPage
					? SizedBox.expand(child: surface)
					: SizedBox(width: size.width, height: size.height, child: surface);
			},
		);
	}
}
