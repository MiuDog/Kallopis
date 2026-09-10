import '../../../composition/nodes/klp_node.dart';
import '../../../kernel/identity/klp_placement_id.dart';
import '../../../composition/registry/klp_registry.dart';
import '../../../composition/validation/klp_tree_validation.dart';
import '../../../composition/validation/klp_validated_node.dart';
import 'klp_default_placement.dart';
import 'klp_installation_exception.dart';
import 'klp_placement_resource.dart';

/// 安裝交易的內部核心，管理放置資源並將呈現交由上層 runtime 處理。
final class KlpInstallation {

	final KlpRegistry registry;
	final KlpPlacementResource Function(KlpValidatedNode) _create;
	Map<KlpPlacementId, KlpPlacementResource> _resources = {};
	KlpTreeValidation? _tree;
	bool _busy = false;
	bool _disposed = false;

	KlpInstallation(this.registry, {KlpPlacementResource Function(KlpValidatedNode)? create}) : _create = create ?? KlpDefaultPlacement.new;

	KlpTreeValidation? get tree => _tree;
	bool get isDisposed => _disposed;
	Map<KlpPlacementId, KlpPlacementResource> get resources => Map.unmodifiable(_resources);

	void update(KlpNode root) {
		_enter();
		try {
			// 步驟 1：完整驗證先於任何資源建立，後續只讀不可變快照。
			final next = registry.validate(root);
			_apply(next);
		}
		finally {
			_busy = false;
		}
	}

	/// 僅供已完成同次註冊與資料準備的 runtime 使用，避免再次讀取外部節點。
	void updateValidated(KlpTreeValidation next, {void Function()? onCommitted}) {
		_enter();
		try {
			_apply(next, onCommitted: onCommitted);
		}
		finally {
			_busy = false;
		}
	}

	void dispose() {
		if (_disposed) return;

		_enter();
		_disposed = true;
		final previous = _resources;
		final previousTree = _tree;
		_resources = {};
		_tree = null;
		final issues = <({Object error, StackTrace stackTrace})>[];
		try {
			// 先清除可見狀態，確保清理回呼不能再次使用已卸載的樹。
			for (final node in previousTree?.nodes.reversed ?? <KlpValidatedNode>[]) {
				_cleanup(previous[node.placementId]!, issues);
			}
		}
		finally {
			_busy = false;
		}
		if (issues.isNotEmpty) throw KlpInstallationException(true, issues);
	}

	void _apply(KlpTreeValidation next, {void Function()? onCommitted}) {
		final previous = _resources;
		final previousTree = _tree;
		final oldNodes = {for (final node in previousTree?.nodes ?? <KlpValidatedNode>[]) node.placementId: node};
		final pending = <KlpPlacementId, KlpPlacementResource>{};
		final created = <KlpPlacementResource>[];
		final issues = <({Object error, StackTrace stackTrace})>[];

		// 步驟 2：暫存新資源；建立失敗時舊狀態與舊資源尚未改動。
		try {
			for (final node in next.nodes) {
				final old = oldNodes[node.placementId];
				if (old != null && old.definitionId == node.definitionId) {
					pending[node.placementId] = previous[node.placementId]!;
				}
				else {
					final resource = _create(node);
					created.add(resource);
					pending[node.placementId] = resource;
				}
			}
		}
		catch (error, stackTrace) {
			issues.add((error: error, stackTrace: stackTrace));
			for (final resource in created.reversed) {
				_cleanup(resource, issues);
			}
			throw KlpInstallationException(false, issues);
		}

		// 步驟 3：原子交換樹與資源索引，再派送保留節點的結構更新。
		_resources = pending;
		_tree = next;
		try {
			onCommitted?.call();
		}
		catch (error, stackTrace) {
			issues.add((error: error, stackTrace: stackTrace));
		}
		for (final node in next.nodes) {
			final old = oldNodes[node.placementId];
			if (old == null || !identical(previous[node.placementId], pending[node.placementId])) continue;
			if (_sameChildren(old, node)) continue;

			try {
				pending[node.placementId]!.update(node);
			}
			catch (error, stackTrace) {
				issues.add((error: error, stackTrace: stackTrace));
			}
		}

		// 步驟 4：依舊樹反序清理已移除或替換的位置，不中止剩餘清理。
		for (final node in previousTree?.nodes.reversed ?? <KlpValidatedNode>[]) {
			final resource = previous[node.placementId]!;
			if (!identical(resource, pending[node.placementId])) _cleanup(resource, issues);
		}
		if (issues.isNotEmpty) throw KlpInstallationException(true, issues);
	}

	bool _sameChildren(KlpValidatedNode left, KlpValidatedNode right) {
		if (left.childrenPlacements.length != right.childrenPlacements.length) return false;

		for (var index = 0; index < left.childrenPlacements.length; index++) {
			if (left.childrenPlacements[index] != right.childrenPlacements[index]) return false;
		}
		return true;
	}

	void _cleanup(KlpPlacementResource resource, List<({Object error, StackTrace stackTrace})> issues) {
		try {
			resource.dispose();
		}
		catch (error, stackTrace) {
			issues.add((error: error, stackTrace: stackTrace));
		}
	}

	void _enter() {
		if (_disposed) throw StateError('Installation has been disposed.');
		if (_busy) throw StateError('Installation cannot be changed reentrantly.');

		_busy = true;
	}
}
