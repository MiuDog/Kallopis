import 'package:flutter/widgets.dart';

/// 快捷鍵解析的責任層級。數值越小，解析優先權越高。
enum KlpKeyBindingScope { component, region, page, app }

/// 一筆產品或元件快捷鍵宣告。
class KlpKeyBinding {
	const KlpKeyBinding({
		required this.commandId,
		required this.activator,
		required this.scope,
		this.scopeId,
		this.enabled = true,
	});

	final String commandId;
	final ShortcutActivator activator;
	final KlpKeyBindingScope scope;
	final String? scopeId;
	final bool enabled;
}

/// 將解析後的命令傳給 Flutter `Actions` 系統。
class KlpCommandIntent extends Intent {
	const KlpCommandIntent(this.commandId);

	final String commandId;
}
