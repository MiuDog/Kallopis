import 'dart:async';

enum KlpWorkspaceCommandStatus { completed, canceled, failed }

/// 呈現流程的結果；不宣稱產品已持久化。
final class KlpWorkspaceCommandResult {

	final KlpWorkspaceCommandStatus status;
	final Object? error;
	final StackTrace? stackTrace;

	const KlpWorkspaceCommandResult.completed() : status = KlpWorkspaceCommandStatus.completed, error = null, stackTrace = null;
	const KlpWorkspaceCommandResult.canceled() : status = KlpWorkspaceCommandStatus.canceled, error = null, stackTrace = null;
	const KlpWorkspaceCommandResult.failed(this.error, this.stackTrace) : status = KlpWorkspaceCommandStatus.failed;
}

/// 可選快捷鍵語意；renderer 不從顯示文字推測命令用途。
enum KlpWorkspaceCommandShortcut { rename, delete }

/// 工作區選單命令；互動流程由 Kallopis 呈現，資料變更仍由 consumer 執行。
final class KlpWorkspaceCommand {
	final String label;
	final bool enabled;
	final bool destructive;
	final String? inputLabel;
	final String? initialValue;
	final String? confirmation;
	final String submitLabel;
	final String cancelLabel;
	final KlpWorkspaceCommandShortcut? shortcut;
	final FutureOr<void> Function(String?) onInvoke;
	final void Function(KlpWorkspaceCommandResult)? onResult;

	KlpWorkspaceCommand({required this.label, this.enabled = true, this.destructive = false, this.inputLabel, this.initialValue, this.confirmation, this.submitLabel = 'OK', this.cancelLabel = 'Cancel', this.shortcut, required this.onInvoke, this.onResult}) {
		if (label.trim().isEmpty) throw ArgumentError.value(label, 'label', 'Workspace command label must not be empty.');
		if (inputLabel != null && inputLabel!.trim().isEmpty) throw ArgumentError.value(inputLabel, 'inputLabel', 'Workspace command input label must not be empty.');
		if (confirmation != null && confirmation!.trim().isEmpty) throw ArgumentError.value(confirmation, 'confirmation', 'Workspace command confirmation must not be empty.');
		if (submitLabel.trim().isEmpty) throw ArgumentError.value(submitLabel, 'submitLabel', 'Workspace command submit label must not be empty.');
		if (cancelLabel.trim().isEmpty) throw ArgumentError.value(cancelLabel, 'cancelLabel', 'Workspace command cancel label must not be empty.');
	}
}
