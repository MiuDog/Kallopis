import 'package:flutter/material.dart';
import 'package:kallopis/src/features/overlays/klp_menu.dart';
import 'klp_flutter_menu.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_command.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';

/// 命令表面只接已解析的樣式，不另設主題或依功能推導預設值。
final class KlpFlutterCommandStyle {

	final Color surface, foreground, muted, interaction, destructive;
	final TextStyle text;
	final double extent, inset, radius;

	const KlpFlutterCommandStyle({required this.surface, required this.foreground, required this.muted, required this.interaction, required this.destructive, required this.text, required this.extent, required this.inset, required this.radius});
}

/// 只追蹤目前命令流程建立的 route，取消時不影響宿主的其他導覽。
final class KlpFlutterCommandRouteOwner {
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
		// Navigator mutation 離開目前 build/layout 階段，且只移除先前捕捉的 route。
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (navigator.mounted && route.isActive && identical(route.navigator, navigator)) navigator.removeRoute(route);
		});
	}
}

/// 滑鼠、鍵盤與行內入口共用定位選單；框架限制其在 viewport 內。
Future<void> showKlpCommandMenu(BuildContext context, List<KlpBoundWorkspaceCommand> commands, Offset anchor, KlpFlutterCommandStyle style, bool Function() isActive, {KlpFlutterCommandRouteOwner? routeOwner}) async {
	if (!isActive() || commands.isEmpty) return;

	// 工作區命令沿用現行 KlpMenu；只將此子 route 配對給指定 owner。
	final generation = routeOwner?.begin();
	int? index;
	try {
		index = await showKlpMenuItems(
			context: context,
			anchor: anchor,
			surface: style.surface,
			foreground: style.foreground,
			fontFamily: style.text.fontFamily ?? '',
			items: [for (final command in commands) KlpMenuItemData(label: command.label, enabled: command.enabled, danger: command.destructive, onPressed: () {})],
			onRouteContext: generation == null ? null : (routeContext) => routeOwner!.attach(routeContext, generation),
		);
	}
	finally {
		if (generation != null) routeOwner!.finish(generation);
	}
	if (index == null || !context.mounted || !isActive()) return;

	await runKlpCommand(context, commands[index], style, isActive, routeOwner: routeOwner);
}

/// 完整確認後才執行一次命令；結果不代替產品提交。
Future<KlpWorkspaceCommandResult> runKlpCommand(BuildContext context, KlpBoundWorkspaceCommand command, KlpFlutterCommandStyle style, bool Function() isActive, {KlpFlutterCommandRouteOwner? routeOwner}) async {
	const canceled = KlpWorkspaceCommandResult.canceled();
	KlpWorkspaceCommandResult finish(KlpWorkspaceCommandResult result) {
		if (context.mounted && isActive()) command.onResult?.call(result);
		return result;
	}

	if (!command.enabled || !context.mounted || !isActive()) return canceled;

	// 步驟 1：輸入與確認是明確資料選項，任一步取消均不提交。
	String? value;
	if (command.inputLabel != null) {
		final generation = routeOwner?.begin();
		try {
			value = await showDialog<String>(context: context, builder: (dialogContext) {
				if (generation != null) routeOwner!.attach(dialogContext, generation);
				return _CommandInputDialog(command, style);
			});
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
			confirmed = await showDialog<bool>(context: context, builder: (dialogContext) {
				if (generation != null) routeOwner!.attach(dialogContext, generation);
				return AlertDialog(
					backgroundColor: style.surface,
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.radius)),
					title: Text(command.confirmation!, style: style.text),
					actions: [
						TextButton(style: TextButton.styleFrom(foregroundColor: style.foreground), onPressed: () => Navigator.pop(dialogContext, false), child: Text(command.cancelLabel)),
						TextButton(style: TextButton.styleFrom(foregroundColor: style.foreground), onPressed: () => Navigator.pop(dialogContext, true), child: Text(command.submitLabel)),
					],
				);
			});
		}
		finally {
			if (generation != null) routeOwner!.finish(generation);
		}
		if (confirmed != true) return finish(canceled);
	}
	if (!context.mounted || !isActive()) return canceled;

	// 步驟 2：等待非同步 consumer 操作，保留原始錯誤給既有應用錯誤處理。
	KlpWorkspaceCommandResult result;
	try {
		await command.onInvoke(value);
		result = const KlpWorkspaceCommandResult.completed();
	}
	catch (error, stackTrace) {
		result = KlpWorkspaceCommandResult.failed(error, stackTrace);
		if (command.onResult == null) FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stackTrace, library: 'Kallopis commands'));
	}

	return finish(result);
}

/// Controller 的生命週期跟隨實際對話框，包含退場動畫。
final class _CommandInputDialog extends StatefulWidget {

	final KlpBoundWorkspaceCommand command;
	final KlpFlutterCommandStyle style;

	const _CommandInputDialog(this.command, this.style);

	@override
	State<_CommandInputDialog> createState() => _CommandInputDialogState();
}

final class _CommandInputDialogState extends State<_CommandInputDialog> {

	late final _controller = TextEditingController(text: widget.command.initialValue);

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
		final style = widget.style;
		return AlertDialog(
			backgroundColor: style.surface,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.radius)),
			title: Text(widget.command.inputLabel!, style: style.text),
			content: TextField(
				controller: _controller,
				autofocus: true,
				style: style.text,
				cursorColor: style.foreground,
				onSubmitted: (_) => _submit(),
				decoration: InputDecoration(contentPadding: EdgeInsets.all(style.inset), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: style.muted)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: style.foreground))),
			),
			actions: [
				TextButton(style: TextButton.styleFrom(foregroundColor: style.foreground), onPressed: () => Navigator.pop(context), child: Text(widget.command.cancelLabel)),
				TextButton(style: TextButton.styleFrom(foregroundColor: style.foreground), onPressed: _submit, child: Text(widget.command.submitLabel)),
			],
		);
	}
}
