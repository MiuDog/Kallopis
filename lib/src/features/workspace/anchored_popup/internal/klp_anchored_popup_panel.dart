part of '../klp_anchored_popup.dart';

final class _KlpAnchoredPopupPanel extends StatelessWidget {
	const _KlpAnchoredPopupPanel({
		required this.content,
		required this.focusScopeNode,
		required this.onInvokeItem,
		required this.onRunCommand,
	});

	final KlpAnchoredPopup content;
	final FocusScopeNode focusScopeNode;
	final ValueChanged<KlpAnchoredPopupItem> onInvokeItem;
	final void Function(BuildContext context, KlpWorkspaceCommand command) onRunCommand;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		return Semantics(
			container: true,
			label: content.accessibilityLabel,
			child: KlpSurface(
				tone: KlpSurfaceTone.overlay,
				radius: klp.shape.panel,
				padding: EdgeInsets.all(klp.space.overlayContentInset),
				shadows: [
					BoxShadow(
						color: klp.surface.overlayShadowColor,
						offset: Offset(0, klp.surface.overlayOffsetY),
						blurRadius: klp.surface.overlayBlur,
					),
				],
				child: FocusTraversalGroup(
					policy: WidgetOrderTraversalPolicy(),
					child: FocusScope(
						node: focusScopeNode,
						child: SingleChildScrollView(
							child: Column(
								mainAxisSize: MainAxisSize.min,
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: _children(context),
							),
						),
					),
				),
			),
		);
	}

	List<Widget> _children(BuildContext context) {
		final gap = context.klp.space.space2;
		final children = <Widget>[];
		void separate() {
			if (children.isNotEmpty) children.add(SizedBox(height: gap));
		}

		if (content.title != null) children.add(KlpText(content.title!, role: KlpTextRole.h4));
		if (content.items?.isNotEmpty ?? false) {
			separate();
			for (final item in content.items!) {
				children.add(
					_KlpAnchoredPopupItemView(
						item: item,
						onInvoke: () => onInvokeItem(item),
						onRunCommand: onRunCommand,
					),
				);
			}
		}
		if (content.actions?.isNotEmpty ?? false) {
			separate();
			for (final (index, command) in content.actions!.indexed) {
				children.add(
					Padding(
						padding: EdgeInsets.only(bottom: index == content.actions!.length - 1 ? 0 : gap),
						child: SizedBox(
							width: double.infinity,
							child: KlpButton(
								label: command.label,
								onPressed: command.enabled ? () => onRunCommand(context, command) : null,
								tone: command.destructive ? KlpButtonTone.danger : KlpButtonTone.ghost,
							),
						),
					),
				);
			}
		}
		if (content.state != KlpAnchoredPopupState.ready) {
			separate();
			children.add(_feedback(context));
		}
		return children;
	}

	Widget _feedback(BuildContext context) {
		if (content.state == KlpAnchoredPopupState.loading) {
			return KlpLiveRegion(
				message: content.message,
				child: Row(
					children: [
						KlpGeometricSpinner(size: context.klp.space.icon),
						if (content.message != null) ...[
							SizedBox(width: context.klp.space.space2),
							Expanded(child: KlpText(content.message!, role: KlpTextRole.body, tone: KlpTextTone.muted)),
						],
					],
				),
			);
		}

		final tone = content.state == KlpAnchoredPopupState.error ? KlpFeedbackTone.danger : KlpFeedbackTone.success;
		return KlpLiveRegion(
			message: content.message,
			child: KlpInlineNotice(title: content.message!, tone: tone),
		);
	}
}

final class _KlpAnchoredPopupItemView extends StatelessWidget {
	_KlpAnchoredPopupItemView({
		required this.item,
		required this.onInvoke,
		required this.onRunCommand,
	}) : _menuController = KlpContextMenuController();

	final KlpAnchoredPopupItem item;
	final VoidCallback onInvoke;
	final void Function(BuildContext context, KlpWorkspaceCommand command) onRunCommand;
	final KlpContextMenuController _menuController;

	@override
	Widget build(BuildContext context) {
		final commandsEnabled = item.enabled && item.commands.any((command) => command.enabled);
		final row = Row(
			children: [
				Expanded(
					child: KlpActionRegion(
						label: item.label,
						onPressed: item.enabled && item.onPressed != null ? onInvoke : null,
						selected: item.current,
						builder: (context, style) => ConstrainedBox(
							constraints: BoxConstraints(minHeight: context.klp.menuItemHeight),
							child: Padding(
								padding: EdgeInsets.symmetric(horizontal: context.klp.space.space2),
								child: Row(
									children: [
										if (item.icon != null) ...[
											KlpIcon(item.icon!, size: context.klp.space.iconSmall, color: style.foreground),
											SizedBox(width: context.klp.space.space2),
										],
										Expanded(
											child: Column(
												mainAxisSize: MainAxisSize.min,
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													KlpText(item.label, role: KlpTextRole.body, color: style.foreground),
													if (item.subtitle != null) KlpText(item.subtitle!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
												],
											),
										),
									],
								),
							),
						),
					),
				),
				if (item.commands.isNotEmpty)
					Builder(
						builder: (buttonContext) => KlpIconButton(
							icon: KlpIcons.more,
							label: item.label,
							onPressed: commandsEnabled ? () => _openMenu(buttonContext) : null,
							tone: KlpIconButtonTone.inline,
						),
					),
			],
		);
		if (item.commands.isEmpty) return row;

		return KlpContextMenu(
			controller: _menuController,
			label: item.label,
			items: [
				for (final command in item.commands)
					KlpMenuItemData(
						label: command.label,
						enabled: item.enabled && command.enabled,
						danger: command.destructive,
						shortcut: _shortcutLabel(command.shortcut),
						onPressed: () => onRunCommand(context, command),
					),
			],
			child: row,
		);
	}

	void _openMenu(BuildContext context) {
		final box = context.findRenderObject()! as RenderBox;
		_menuController.openAt(box.localToGlobal(Offset(0, box.size.height)));
	}

	String? _shortcutLabel(KlpWorkspaceCommandShortcut? shortcut) => switch (shortcut) {
		KlpWorkspaceCommandShortcut.rename => 'F2',
		KlpWorkspaceCommandShortcut.delete => 'Delete',
		null => null,
	};
}
