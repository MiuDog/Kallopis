import 'package:flutter/widgets.dart';

import 'klp_key_binding.dart';

typedef KlpKeyBindingAction = VoidCallback;

class _KlpRegisteredBinding {
	const _KlpRegisteredBinding(this.binding, this.action);

	final KlpKeyBinding binding;
	final KlpKeyBindingAction action;
}

/// App 內唯一的快捷鍵註冊與 scope 解析器。
class KlpKeyBindingController extends ChangeNotifier {
	final List<_KlpRegisteredBinding> _bindings = [];
	String? _activePageId;
	String? _activeRegionId;

	String? get activePageId => _activePageId;
	String? get activeRegionId => _activeRegionId;

	/// 註冊快捷鍵，回傳可保存的解除註冊函式。
	VoidCallback register({
		required KlpKeyBinding binding,
		required KlpKeyBindingAction action,
	}) {
		final registered = _KlpRegisteredBinding(binding, action);
		_bindings.add(registered);
		notifyListeners();
		return () {
			if (_bindings.remove(registered)) notifyListeners();
		};
	}

	void activatePage(String? pageId) {
		if (_activePageId == pageId) return;
		_activePageId = pageId;
		_activeRegionId = null;
		notifyListeners();
	}

	void activateRegion({required String regionId, String? pageId}) {
		final changed = _activeRegionId != regionId || _activePageId != pageId;
		_activeRegionId = regionId;
		_activePageId = pageId ?? _activePageId;
		if (changed) notifyListeners();
	}

	void clearRegion(String regionId) {
		if (_activeRegionId != regionId) return;
		_activeRegionId = null;
		notifyListeners();
	}

	Map<ShortcutActivator, Intent> get shortcuts {
		final result = <ShortcutActivator, Intent>{};
		for (final item in _resolvedBindings) {
			result[item.binding.activator] = KlpCommandIntent(item.binding.commandId);
		}
		return result;
	}

	Map<Type, Action<Intent>> get actions {
		return <Type, Action<Intent>>{
			KlpCommandIntent: CallbackAction<Intent>(
				onInvoke: (intent) {
					if (intent is KlpCommandIntent) invoke(intent.commandId);
					return null;
				},
			),
		};
	}

	void invoke(String commandId) {
		for (final item in _resolvedBindings) {
			if (item.binding.commandId == commandId) {
				item.action();
				return;
			}
		}
	}

	List<_KlpRegisteredBinding> get _resolvedBindings {
		final result = _bindings.where((item) {
			final binding = item.binding;
			if (!binding.enabled) return false;
			return switch (binding.scope) {
				KlpKeyBindingScope.app => true,
				KlpKeyBindingScope.page => binding.scopeId == _activePageId,
				KlpKeyBindingScope.region || KlpKeyBindingScope.component =>
					binding.scopeId == _activeRegionId,
			};
		}).toList();
		// 先放廣 scope，再由較窄 scope 覆蓋相同按鍵。
		result.sort((a, b) => b.binding.scope.index.compareTo(a.binding.scope.index));
		return result;
	}
}

/// 將 controller 的目前 scope 接到 Flutter Shortcuts／Actions。
class KlpKeyBindingHost extends StatelessWidget {
	const KlpKeyBindingHost({super.key, required this.controller, required this.child});

	final KlpKeyBindingController controller;
	final Widget child;

	@override
	Widget build(BuildContext context) => AnimatedBuilder(
			animation: controller,
			builder: (context, _) => Shortcuts(
					shortcuts: controller.shortcuts,
					child: Actions(actions: controller.actions, child: child),
				),
		);
}
