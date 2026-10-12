part of '../klp_anchored_popup.dart';

final class _KlpWorkspaceCommandRouteOwner {
	Route<dynamic>? _route;
	NavigatorState? _navigator;
	var _generation = 0;

	int begin() {
		dismiss();
		return _generation;
	}

	void attach(BuildContext context, int generation) {
		final route = ModalRoute.of(context);
		if (route == null) return;

		final navigator = Navigator.of(context);
		if (generation != _generation) {
			_remove(route, navigator);
			return;
		}
		_route = route;
		_navigator = navigator;
	}

	void finish(int generation) {
		if (generation != _generation) return;
		_route = null;
		_navigator = null;
	}

	void dismiss() {
		_generation++;
		final route = _route;
		final navigator = _navigator;
		_route = null;
		_navigator = null;
		if (route == null || navigator == null) return;

		_remove(route, navigator);
	}

	void _remove(Route<dynamic> route, NavigatorState navigator) {
		WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
			if (navigator.mounted && route.isActive && identical(route.navigator, navigator)) navigator.removeRoute(route);
		});
	}
}

Future<KlpWorkspaceCommandResult> _runKlpWorkspaceCommand(
	BuildContext context,
	KlpWorkspaceCommand command,
	bool Function() isActive, {
	_KlpWorkspaceCommandRouteOwner? routeOwner,
}) async {
	const canceled = KlpWorkspaceCommandResult.canceled();
	KlpWorkspaceCommandResult finish(KlpWorkspaceCommandResult result) {
		if (context.mounted && isActive()) command.onResult?.call(result);
		return result;
	}

	if (!command.enabled || !context.mounted || !isActive()) return canceled;

	// 步驟 1：依序完成輸入與確認；任一步取消都不執行產品命令。
	String? value;
	if (command.inputLabel != null) {
		final generation = routeOwner?.begin();
		try {
			value = await showDialog<String>(
				context: context,
				builder: (dialogContext) {
					if (generation != null) routeOwner!.attach(dialogContext, generation);
					return _KlpCommandInputDialog(command: command);
				},
			);
		}
		finally {
			if (generation != null) routeOwner!.finish(generation);
		}
		if (value == null) return finish(canceled);
	}
	if (!context.mounted || !isActive()) return canceled;

	if (command.confirmation != null) {
		final generation = routeOwner?.begin();
		bool? confirmed;
		try {
			confirmed = await showDialog<bool>(
				context: context,
				builder: (dialogContext) {
					if (generation != null) routeOwner!.attach(dialogContext, generation);
					return _KlpCommandConfirmationDialog(command: command);
				},
			);
		}
		finally {
			if (generation != null) routeOwner!.finish(generation);
		}
		if (confirmed != true) return finish(canceled);
	}
	if (!context.mounted || !isActive()) return canceled;

	// 步驟 2：產品命令只執行一次；失敗轉成結果並保留原始錯誤資訊。
	KlpWorkspaceCommandResult result;
	try {
		await command.onInvoke(value);
		result = const KlpWorkspaceCommandResult.completed();
	}
	catch (error, stackTrace) {
		result = KlpWorkspaceCommandResult.failed(error, stackTrace);
		if (command.onResult == null) {
			FlutterError.reportError(
				FlutterErrorDetails(
					exception: error,
					stack: stackTrace,
					library: 'Kallopis workspace commands',
				),
			);
		}
	}

	return finish(result);
}

final class _KlpCommandInputDialog extends StatefulWidget {
	const _KlpCommandInputDialog({required this.command});

	final KlpWorkspaceCommand command;

	@override
	State<_KlpCommandInputDialog> createState() => _KlpCommandInputDialogState();
}

final class _KlpCommandInputDialogState extends State<_KlpCommandInputDialog> {
	late final TextEditingController _controller = TextEditingController(text: widget.command.initialValue);

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	void _submit() {
		final value = _controller.text.trim();
		if (value.isNotEmpty) Navigator.pop(context, value);
	}

	@override
	Widget build(BuildContext context) {
		final command = widget.command;
		return KlpModalFrame(
			insets: KlpBoxInsets.uniform(context.klp.space.space6),
			child: KlpDialog(
				label: command.label,
				title: command.inputLabel!,
				primaryLabel: command.submitLabel,
				onPrimary: _submit,
				secondaryLabel: command.cancelLabel,
				onSecondary: () => Navigator.pop(context),
				child: KlpTextField(
					controller: _controller,
					autofocus: true,
					onSubmitted: (value) => _submit(),
				),
			),
		);
	}
}

final class _KlpCommandConfirmationDialog extends StatelessWidget {
	const _KlpCommandConfirmationDialog({required this.command});

	final KlpWorkspaceCommand command;

	@override
	Widget build(BuildContext context) {
		return KlpModalFrame(
			insets: KlpBoxInsets.uniform(context.klp.space.space6),
			child: KlpDialog(
				label: command.label,
				title: command.confirmation!,
				primaryLabel: command.submitLabel,
				onPrimary: () => Navigator.pop(context, true),
				secondaryLabel: command.cancelLabel,
				onSecondary: () => Navigator.pop(context, false),
				child: const SizedBox.shrink(),
			),
		);
	}
}
