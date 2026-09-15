import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:krepis_block_note/krepis_block_note.dart';
import 'package:kallopis/src/features/feedback/view_states/klp_view_states.dart';

import 'klp_block_note_load_error.dart';
import 'klp_block_note_web_session_loader.dart';
import 'klp_block_note_flow_transport.dart';
import 'klp_page_reference_drag.dart';
import '../klp_viewport_capabilities.dart';

/// 只載入 Kallopis 打包的固定 BlockNote 應用，所有 bridge 封包仍由 session controller 驗證。
final class KlpFlutterBlockNoteEditing extends StatefulWidget {
	final KlpBoundBlockNoteEditing content;
	const KlpFlutterBlockNoteEditing({required this.content, super.key});

	@override
	State<KlpFlutterBlockNoteEditing> createState() => _KlpFlutterBlockNoteEditingState();
}

final class _KlpFlutterBlockNoteEditingState extends State<KlpFlutterBlockNoteEditing> {

	InAppWebViewController? _webView;
	Future<WebViewEnvironment?>? _environment;
	late final KlpBlockNoteWebSessionLoader _loader;
	late final KlpBlockNoteSessionController _session;
	late final KlpBlockNoteBridgeChannel _channel;
	late final KlpBlockNoteFlowTransport _flow;
	final _hostKey = GlobalKey();
	late KlpEditingHostFailureSink _failureSink;
	KlpEditingHostPhase _openPhase = KlpEditingHostPhase.bridgeReady;
	bool _closed = false;
	bool _attachmentLost = false;
	bool _ownsSender = false;
	bool _environmentDisposalStarted = false;
	bool _bodyOpened = false;
	bool _projectionsRunning = false;
	Completer<void>? _initialProjectionGate;
	int _projectionsVersion = 0;
	int _configuredVersion = -1;
	int _dropAttempt = 0;
	String? _hostInstanceId;

	@override
	void initState() {
		super.initState();
		_session = widget.content.controller;
		_channel = _session.bridge as KlpBlockNoteBridgeChannel;
		_loader = KlpBlockNoteWebSessionLoader(_attemptOpen, onFailure: (error, stack) => _report(_openPhase, error, stack), canOpen: () => !_closed && !_attachmentLost && _session.canDetachHost);
		_flow = KlpBlockNoteFlowTransport(session: _session, content: () => widget.content, send: _sendInteraction, onFailure: (error, stack) => _report(KlpEditingHostPhase.callback, error, stack), onStatusChanged: _statusChanged);
		klpActivePageReferenceDrag.addListener(_dragChanged);
	}

	@override
	void didUpdateWidget(KlpFlutterBlockNoteEditing oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (!identical(widget.content.controller, _session)) throw StateError('BlockNote attachment cannot change its session');

		if (!_sameProjections(oldWidget.content.pageProjections, widget.content.pageProjections)) _projectionsVersion++;
		_dropAttempt++;
		_scheduleProjections();
	}

	bool _sameProjections(List<KrepisPageProjection> before, List<KrepisPageProjection> after) {
		if (before.length != after.length) return false;

		for (var index = 0; index < before.length; index++) {
			final left = before[index];
			final right = after[index];
			if (left.page != right.page || left.title != right.title || left.availability != right.availability) return false;
		}
		return true;
	}

	void _statusChanged() {
		if (_closed) return;

		if (_session.operationState != KrepisBlockNoteOperationState.idle) _dropAttempt++;
		_scheduleProjections();
		if (mounted) setState(() {});
	}

	void _dragChanged() {
		_dropAttempt++;
		if (!_closed && mounted) setState(() {});
	}

	void _scheduleProjections() {
		if (!_bodyOpened || _closed || _attachmentLost || _projectionsRunning || _configuredVersion == _projectionsVersion || _flow.blocked) return;

		unawaited(_updateProjections().catchError((Object error, StackTrace stack) {
			if (_closed || _attachmentLost) return;

			final initial = _initialProjectionGate;
			if (initial != null && !initial.isCompleted) {
				initial.completeError(error, stack);
			}
			else {
				_report(KlpEditingHostPhase.configure, error, stack);
			}
		}));
	}

	Future<void> _updateProjections() async {
		if (_projectionsRunning) return;

		_projectionsRunning = true;
		try {
			while (!_closed && !_attachmentLost && !_flow.blocked && _configuredVersion != _projectionsVersion) {
				final version = _projectionsVersion;
				try { await _flow.configurePages(); }
				on KrepisBlockNoteOperationException catch (error) {
					// 宣告更新與 barrier 競爭時留待 idle，不能把暫時鎖定當載入失敗。
					if (_flow.blocked && (error.failure.code == KrepisBlockNoteFailureCode.busy || error.failure.code == KrepisBlockNoteFailureCode.blocked)) return;

					rethrow;
				}
				if (_closed) return;

				_configuredVersion = version;
			}
			final initial = _initialProjectionGate;
			if (!_closed && !_attachmentLost && !_flow.blocked && _configuredVersion == _projectionsVersion && initial != null && !initial.isCompleted) initial.complete();
		}
		finally {
			_projectionsRunning = false;
		}
	}

	Future<void> _sendInteraction(Map<String, Object?> message) async {
		final controller = _webView;
		if (_closed || controller == null) throw StateError('BlockNote attachment is closed');

		await _send(controller, message);
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		final capabilities = KlpViewportCapabilities.of(context);
		if (capabilities == null) throw StateError('BlockNote renderer requires viewport capabilities');
		_failureSink = capabilities.onEditingHostFailure;
	}

	void _report(KlpEditingHostPhase phase, Object error, StackTrace stack) {
		_failureSink(KlpEditingHostFailure(origin: KlpEditingHostOrigin.blockNote, phase: phase, error: error, stackTrace: stack));
	}

	bool _live(InAppWebViewController controller) => !_closed && !_attachmentLost && identical(controller, _webView);

	bool _acceptsPageDrag(KlpPageReferenceDrag carrier) => !_closed && !_attachmentLost && _bodyOpened && _hostInstanceId != null && _flow.acceptsPageDrop && carrier.page != null && identical(klpActivePageReferenceDrag.value, carrier);

	Widget _buildPageDropTarget() => DragTarget<KlpPageReferenceDrag>(
		onWillAcceptWithDetails: (details) {
			if (!_acceptsPageDrag(details.data)) return false;

			unawaited(_probePageDrop(details, false));
			return true;
		},
		onMove: (details) => unawaited(_probePageDrop(details, false)),
		onLeave: (_) { _dropAttempt++; },
		onAcceptWithDetails: (details) => unawaited(_probePageDrop(details, true)),
		builder: (_, candidates, rejected) => const SizedBox.expand(),
	);

	Future<void> _probePageDrop(DragTargetDetails<KlpPageReferenceDrag> details, bool commit) async {
		final controller = _webView;
		final carrier = details.data;
		if (controller == null || !_live(controller) || !_acceptsPageDrag(carrier)) return;

		final box = _hostKey.currentContext?.findRenderObject();
		if (box is! RenderBox || !box.hasSize || box.size.isEmpty) return;

		final local = box.globalToLocal(details.offset);
		if (!local.dx.isFinite || !local.dy.isFinite || !(Offset.zero & box.size).contains(local)) return;

		final attempt = ++_dropAttempt;
		final host = _hostInstanceId;
		final page = carrier.page!;
		final point = {'x': local.dx, 'y': local.dy, 'width': box.size.width, 'height': box.size.height};
		final source = commit ? {'projectId': page.projectId, 'documentId': page.documentId} : null;
		try {
			// 座標只送固定私有端點；release 由實際 DOM 再判定，不使用 preview 當成功憑證。
			final result = await controller.evaluateJavascript(source: 'window.kallopisBlockNote.probeDatabaseDrop(${jsonEncode(point)}, ${jsonEncode(source)}, $commit);');
			if (!_live(controller) || _dropAttempt != attempt || _hostInstanceId != host || _flow.blocked) return;

			if (result == null) return;

			if (result is! Map || result['hostInstanceId'] != host) throw const FormatException('Invalid BlockNote database drop probe response');
			// placement 僅為命中觀察；真正 database.drop 仍由 typed receipt 交付，這裡不插入正文。
		}
		catch (error, stack) {
			if (_live(controller) && _dropAttempt == attempt) _report(KlpEditingHostPhase.input, error, stack);
		}
	}

	void _releaseSender() {
		if (!_ownsSender) return;
		_ownsSender = false;
		_channel.unbindPlatformSender();
	}

	@override
	Widget build(BuildContext context) {
		final l10n = KlpLocalizations.of(context);
		final capabilities = KlpViewportCapabilities.of(context);
		if (capabilities == null) throw StateError('BlockNote renderer requires viewport capabilities');
		final environment = _environment ??= _createEnvironment(capabilities.nativeWindows);
		return LayoutBuilder(builder: (context, constraints) {
			return KlpBlockNoteLoadSurface(
				loader: _loader,
				onRetry: () => unawaited(_retry()),
				child: FutureBuilder<WebViewEnvironment?>(future: environment, builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) return const SizedBox.expand();
					if (snapshot.hasError) return KlpErrorState(title: l10n.editorEnvironmentFailedTitle, message: l10n.editorEnvironmentFailedMessage);
					return SizedBox.expand(key: _hostKey, child: Stack(children: [Positioned.fill(child: _buildWebView(snapshot.data)), if (_bodyOpened && _flow.acceptsPageDrop && klpActivePageReferenceDrag.value?.page != null) Positioned.fill(child: _buildPageDropTarget())]));
				}),
			);
		});
	}

	Widget _buildWebView(WebViewEnvironment? environment) {
		return InAppWebView(
			webViewEnvironment: environment,
			initialFile: 'packages/kallopis/assets/blocknote_editor/index.html',
			initialSettings: InAppWebViewSettings(javaScriptEnabled: true, useShouldOverrideUrlLoading: true),
			onWebViewCreated: _createWebView,
			onLoadStop: (controller, url) {
				if (_live(controller)) unawaited(_open());
			},
			onReceivedError: (_, request, error) {
				if (_closed) return;
				debugPrint('BlockNote WebView error: ${request.url} ${error.description}');
				_loader.reportFailure(error);
				_report(KlpEditingHostPhase.receive, error, StackTrace.current);
				if (mounted) setState(() {});
			},
			onConsoleMessage: (_, message) {
				if (message.messageLevel == ConsoleMessageLevel.ERROR) debugPrint('BlockNote console error: ${message.message}');
			},
			shouldOverrideUrlLoading: (_, action) async {
				if (_closed) return NavigationActionPolicy.CANCEL;
				final scheme = action.request.url?.scheme;
				if (scheme == 'asset') {
					final assetId = action.request.url?.host;
					if (assetId != null) {
						try { await widget.content.onOpenAsset?.call(assetId); }
						catch (error, stack) {
							_report(KlpEditingHostPhase.callback, error, stack);
							rethrow;
						}
					}
					return NavigationActionPolicy.CANCEL;
				}
				return scheme == 'file' || scheme == 'data' || scheme == 'about' ? NavigationActionPolicy.ALLOW : NavigationActionPolicy.CANCEL;
			},
		);
	}

	Future<WebViewEnvironment?> _createEnvironment(bool nativeWindows) async {
		try {
			if (!nativeWindows || _closed) return null;
			final version = await WebViewEnvironment.getAvailableVersion();
			if (_closed) return null;
			if (version == null) throw StateError('WebView2 Runtime 未安裝');
			// Windows plugin 要求先建立對應的 WebView2 environment。
			return await WebViewEnvironment.create();
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.environmentCreate, error, stack);
			rethrow;
		}
	}

	void _createWebView(InAppWebViewController controller) {
		if (_closed || _attachmentLost) return;

		if (_webView != null && !identical(_webView, controller)) {
			// 同一 attachment 不接受第二個平台宿主，不能重播初始正文。
			final error = StateError('BlockNote WebView attachment was replaced');
			_attachmentLost = true;
			_dropAttempt++;
			final initial = _initialProjectionGate;
			if (initial != null && !initial.isCompleted) initial.complete();
			_loader.reportFailure(error);
			_flow.dispose();
			_releaseSender();
			_report(KlpEditingHostPhase.bind, error, StackTrace.current);
			return;
		}
		_webView = controller;
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNote', callback: (arguments) => _live(controller) ? _receive(arguments) : null);
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNoteAsset', callback: (arguments) => _live(controller) ? _resolveAsset(arguments) : null);
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNoteOpenAsset', callback: (arguments) => _live(controller) ? _openAsset(arguments) : null);
		controller.addJavaScriptHandler(handlerName: 'KallopisBlockNoteOpenReference', callback: (arguments) => _live(controller) ? _openReference(arguments) : null);
	}

	Future<void> _openReference(List<dynamic> arguments) async {
		if (_closed) return;
		try {
			if (arguments.length != 1 || arguments.single is! Map) throw const FormatException('Invalid BlockNote reference request');
			final value = Map<String, Object?>.from(arguments.single as Map);
			final referenceId = value['referenceId'];
			final sourceDocumentId = value['sourceDocumentId'];
			final sourceBlockId = value['sourceBlockId'];
			if (referenceId is! String || sourceDocumentId is! String || sourceBlockId is! String) throw const FormatException('Invalid BlockNote reference identity');
			final opener = widget.content.onOpenReference;
			if (opener == null) throw StateError('BlockNote reference opener is unavailable');
			await opener(referenceId, sourceDocumentId, sourceBlockId);
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.callback, error, stack);
			rethrow;
		}
	}

	Future<void> _openAsset(List<dynamic> arguments) async {
		if (_closed) return;
		try {
			if (arguments.length != 1 || arguments.single is! String) throw const FormatException('Invalid BlockNote open-asset request');
			final opener = widget.content.onOpenAsset;
			if (opener == null) throw StateError('BlockNote asset opener is unavailable');
			await opener(arguments.single as String);
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.callback, error, stack);
			rethrow;
		}
	}

	Future<Map<String, Object?>> _resolveAsset(List<dynamic> arguments) async {
		if (_closed) throw StateError('BlockNote attachment is closed');
		try {
			if (arguments.length != 1 || arguments.single is! String) throw const FormatException('Invalid BlockNote asset request');
			final resolver = widget.content.resolveAsset;
			if (resolver == null) throw StateError('BlockNote asset resolver is unavailable');
			final asset = await resolver(arguments.single as String);
			return {'mediaType': asset.mediaType, 'base64': base64Encode(asset.bytes)};
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.callback, error, stack);
			rethrow;
		}
	}

	Future<void> _open() async {
		if (_closed) return;
		await _loader.open();
		if (mounted) setState(() {});
	}

	Future<void> _retry() async {
		if (_closed) return;
		await _loader.retry();
		if (mounted) setState(() {});
	}

	Future<void> _attemptOpen() async {
		final controller = _webView;
		if (_closed || controller == null) return;
		var opened = false;
		try {
			_openPhase = KlpEditingHostPhase.bridgeReady;
			await _waitForBridge(controller);
			if (!_live(controller)) return;
			_openPhase = KlpEditingHostPhase.bind;
			await _channel.bindPlatformSender((command) => _send(controller, command), flushPending: false);
			_ownsSender = true;
			if (!_live(controller)) {
				_releaseSender();
				return;
			}
			_openPhase = KlpEditingHostPhase.configure;
			await _send(controller, {
				'protocolVersion': KlpBlockNoteSessionController.protocolVersion,
				'type': 'configure',
				'sessionId': _session.sessionId,
				'requestId': 1,
				'revision': _session.revision,
				'appearance': {
					'background': widget.content.background,
					'text': widget.content.text,
					'fontFamily': widget.content.fontFamily,
					'fontSize': widget.content.fontSize,
				},
			});
			if (!_live(controller)) return;
			await _session.prepareFlowCapabilities();
			if (!_live(controller)) return;

			_openPhase = KlpEditingHostPhase.open;
			await _session.open();
			opened = true;
			_loader.markOpened();
			if (!_live(controller)) return;

			final initial = Completer<void>();
			_initialProjectionGate = initial;
			_bodyOpened = true;
			_openPhase = KlpEditingHostPhase.configure;
			await _updateProjections();
			// 初始投影若遇上 barrier，等待唯一 status observer 在 idle 時續送。
			await initial.future;
			_initialProjectionGate = null;
			if (!_live(controller)) return;

			_openPhase = KlpEditingHostPhase.flush;
			await _channel.flush();
			if (!_live(controller)) return;
			_openPhase = KlpEditingHostPhase.callback;
			await widget.content.onOpened?.call();
		}
		catch (_) {
			_initialProjectionGate = null;
			if (!opened) _releaseSender();
			rethrow;
		}
	}

	Future<void> _waitForBridge(InAppWebViewController controller) async {
		for (var attempt = 0; attempt < 50; attempt++) {
			if (!_live(controller)) return;
			final ready = await controller.evaluateJavascript(source: "typeof window.kallopisBlockNote?.receive === 'function'");
			if (!_live(controller)) return;
			if (ready == true) return;
			await Future<void>.delayed(const Duration(milliseconds: 100));
			if (!_live(controller)) return;
		}
		throw TimeoutException('BlockNote web bridge was not registered');
	}

	Future<void> _send(InAppWebViewController controller, Map<String, Object?> command) async {
		if (!_live(controller)) throw StateError('BlockNote attachment is closed');
		final source = 'window.kallopisBlockNote.receive(${jsonEncode(command)});';

		// 固定呼叫已打包應用的單一封閉入口，不接受 consumer script。
		await controller.evaluateJavascript(source: source);
	}

	Object? _receive(List<dynamic> arguments) {
		if (_closed) return null;
		try {
			if (arguments.length != 1 || arguments.single is! Map) throw const FormatException('Invalid BlockNote WebView message');
			final message = Map<String, Object?>.from(arguments.single as Map);
			final receipt = _flow.receive(message);
			if (receipt is Map && receipt['received'] == true) _hostInstanceId = receipt['hostInstanceId'] as String;
			if (mounted) setState(() {});
			return receipt;
		}
		catch (error, stack) {
			_report(KlpEditingHostPhase.receive, error, stack);
			rethrow;
		}
	}

	Future<void> _disposeEnvironment(WebViewEnvironment? value) async {
		if (_environmentDisposalStarted || value == null) return;
		_environmentDisposalStarted = true;
		try { await value.dispose(); }
		catch (error, stack) { _report(KlpEditingHostPhase.dispose, error, stack); }
	}

	@override
	void dispose() {
		_closed = true;
		_dropAttempt++;
		final initial = _initialProjectionGate;
		if (initial != null && !initial.isCompleted) initial.complete();
		_flow.dispose();
		klpActivePageReferenceDrag.removeListener(_dragChanged);
		_releaseSender();
		_webView = null;
		final environment = _environment;
		// 建立失敗已由建立操作回報；此處只處理成功結果的唯一釋放。
		if (environment != null) unawaited(environment.then(_disposeEnvironment, onError: (Object error, StackTrace stack) {}));
		super.dispose();
	}
}
