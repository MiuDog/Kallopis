part of '../klp_dock_layout.dart';

/// 實例本身就是 request token，不能跨過 callback 或 panel 生命週期。
class _KlpDockCloseRequest {
	const _KlpDockCloseRequest(this.approve);
	/// 保留提出請求時的產品 callback，完成時仍須與當前 registry 比對。
	final FutureOr<bool> Function() approve;
}

/// 關閉只協調產品批准及暫態 pending，不拥有正文或布局保存資料。
extension _KlpDockCloseOperations on _KlpDockLayoutState {
	bool _isPanelPlaced(String id) => [widget.layout.left, widget.layout.right, widget.layout.bottom]
		.any((area) => area.groups.any((group) => group.panelIds.contains(id)));

	void _reconcileCloseRequests() {
		_pendingCloseRequests.removeWhere((id, request) =>
			!_isPanelPlaced(id) || !identical(_findPanel(id)?.onCloseRequested, request.approve),
		);
	}

	bool _closeRequestIsCurrent(String id, _KlpDockCloseRequest request) => mounted &&
		identical(_pendingCloseRequests[id], request) && _isPanelPlaced(id) &&
		identical(_findPanel(id)?.onCloseRequested, request.approve);

	Future<void> _requestClose(KlpDockPanel panel) async {
		final approve = panel.onCloseRequested;
		if (approve == null || _pendingCloseRequests.containsKey(panel.id) || !_isPanelPlaced(panel.id)) return;
		final request = _KlpDockCloseRequest(approve);
		_updateCloseState(() => _pendingCloseRequests[panel.id] = request);
		try {
			final approved = await request.approve();
			if (approved && _closeRequestIsCurrent(panel.id, request)) {
				_commitActions([KlpDockAction.close(panelId: panel.id, approved: true)]);
			}
		} catch (error, stack) {
			if (_closeRequestIsCurrent(panel.id, request)) {
				FlutterError.reportError(FlutterErrorDetails(
					exception: error,
					stack: stack,
					library: 'Kallopis Dock',
					context: ErrorDescription('while requesting panel close'),
				));
			}
		} finally {
			if (mounted && identical(_pendingCloseRequests[panel.id], request)) {
				_updateCloseState(() => _pendingCloseRequests.remove(panel.id));
			}
		}
	}

	String _closeLabel(KlpDockPanel panel) => panel.closeLabel ??
		'${KlpLocalizations.of(context).documentTabCloseLabel} ${panel.id}';

	Widget _panelLabel(KlpDockPanel panel, Widget header) {
		if (!panel.isPinned && !panel.isDirty) return header;
		final strings = KlpLocalizations.of(context);
		return KlpRow(children: [
			header,
			if (panel.isPinned) ...[
				KlpBox(width: context.klp.space.tight),
				KlpIcon(KlpIcons.bookmark, semanticLabel: strings.documentTabPinLabel),
			],
			if (panel.isDirty) Semantics(
				label: strings.documentTabModifiedLabel,
				excludeSemantics: true,
				child: const KlpText(' •', role: KlpTextRole.code),
			),
		]);
	}

	Widget _closeButton(KlpDockPanel panel) => KlpIconButton(
		icon: KlpIcons.close,
		label: _closeLabel(panel),
		tone: KlpIconButtonTone.inline,
		onPressed: _pendingCloseRequests.containsKey(panel.id) ? null : () => _requestClose(panel),
	);
}
