import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart' as stable;
import 'package:kallopis/kallopis.dart' as umbrella;
import 'package:kallopis/src/foundation/localization/klp_localizations.dart' as owner;
import 'package:kallopis/src/rendering/flutter/internal/klp_block_note_load_error.dart';

import 'support/load_test_fonts.dart';

void main() {
	setUpAll(loadKlpTestFonts);
	// 固定原基線 30ba4945 的全部字串；執行時不從產品建構子產生預期值。
	test('all original localization defaults remain unchanged', () {
		const value = stable.KlpLocalizations();
		final fields = <String, (String, String)>{
			'toastNowLabel': (value.toastNowLabel, 'NOW'),
			'codeViewerCollapseLabel': (value.codeViewerCollapseLabel, '收合'),
			'codeViewerExpandLabel': (value.codeViewerExpandLabel, '展開'),
			'codeDataCopyLabel': (value.codeDataCopyLabel, 'Copy'),
			'codeDiffApproveLabel': (value.codeDiffApproveLabel, '同意'),
			'codeDiffRejectLabel': (value.codeDiffRejectLabel, '拒絕'),
			'codeTerminalClearLabel': (value.codeTerminalClearLabel, 'Clear'),
			'dataTableSelectAllLabel': (value.dataTableSelectAllLabel, 'Select all rows'),
			'dataTableSelectRowLabel': (value.dataTableSelectRowLabel, 'Select row'),
			'jsonTreeLoadingLabel': (value.jsonTreeLoadingLabel, 'Loading...'),
			'jsonTreeInvalidLabel': (value.jsonTreeInvalidLabel, 'Invalid structured data'),
			'filePreviewOpenExternalLabel': (value.filePreviewOpenExternalLabel, 'Open externally'),
			'filePreviewDownloadLabel': (value.filePreviewDownloadLabel, 'Download'),
			'filePreviewLoadingLabel': (value.filePreviewLoadingLabel, 'Loading preview...'),
			'filePreviewErrorLabel': (value.filePreviewErrorLabel, 'Preview failed to load'),
			'filePreviewUnsupportedLabel': (value.filePreviewUnsupportedLabel, 'No preview available for this type'),
			'filePreviewEmptyLabel': (value.filePreviewEmptyLabel, 'No preview content'),
			'panelToggleLabel': (value.panelToggleLabel, '切換面板'),
			'windowMinimizeLabel': (value.windowMinimizeLabel, 'Minimize window'),
			'windowMaximizeLabel': (value.windowMaximizeLabel, 'Maximize window'),
			'windowRestoreLabel': (value.windowRestoreLabel, 'Restore window'),
			'windowCloseLabel': (value.windowCloseLabel, 'Close window'),
			'searchPreviousResultLabel': (value.searchPreviousResultLabel, 'Previous result'),
			'searchNextResultLabel': (value.searchNextResultLabel, 'Next result'),
			'searchCloseLabel': (value.searchCloseLabel, 'Close search'),
			'entityPickerRemoveLabel': (value.entityPickerRemoveLabel, 'Remove'),
			'entityPickerApplyLabel': (value.entityPickerApplyLabel, 'Apply'),
			'dockMoreActionsLabel': (value.dockMoreActionsLabel, '更多操作'),
			'oklchLightnessLabel': (value.oklchLightnessLabel, 'Lightness'),
			'oklchChromaLabel': (value.oklchChromaLabel, 'Chroma'),
			'oklchHueLabel': (value.oklchHueLabel, 'Hue'),
			'oklchAlphaLabel': (value.oklchAlphaLabel, 'Alpha'),
			'oklchLightnessPlaneLabel': (value.oklchLightnessPlaneLabel, 'Lightness plane'),
			'oklchChromaPlaneLabel': (value.oklchChromaPlaneLabel, 'Chroma plane'),
			'oklchHuePlaneLabel': (value.oklchHuePlaneLabel, 'Hue plane'),
			'oklchOriginalPreviewLabel': (value.oklchOriginalPreviewLabel, 'Clipped original'),
			'oklchFallbackPreviewLabel': (value.oklchFallbackPreviewLabel, 'sRGB fallback'),
			'oklchFallbackWarningLabel': (value.oklchFallbackWarningLabel, 'Outside sRGB gamut; fallback reduces chroma.'),
			'formOptionsLabel': (value.formOptionsLabel, '選擇類型'),
			'formPasswordShowLabel': (value.formPasswordShowLabel, '顯示密碼'),
			'formPasswordHideLabel': (value.formPasswordHideLabel, '隱藏密碼'),
			'formQuantityDecreaseLabel': (value.formQuantityDecreaseLabel, '減少'),
			'formQuantityIncreaseLabel': (value.formQuantityIncreaseLabel, '增加'),
			'formDateRangeCalendarLabel': (value.formDateRangeCalendarLabel, '選擇日期區間'),
			'editorUndoLabel': (value.editorUndoLabel, '撤銷'),
			'editorRedoLabel': (value.editorRedoLabel, '重做'),
			'editorMoreLabel': (value.editorMoreLabel, '更多'),
			'editorSaveLabel': (value.editorSaveLabel, '保存'),
			'editorUnsavedLabel': (value.editorUnsavedLabel, '未保存'),
			'editorSavingLabel': (value.editorSavingLabel, '保存中'),
			'editorSavedLabel': (value.editorSavedLabel, '已保存'),
			'editorSaveFailedLabel': (value.editorSaveFailedLabel, '保存失敗'),
			'editorSaveUnknownLabel': (value.editorSaveUnknownLabel, '保存結果未知'),
			'editorBlockActionsLabel': (value.editorBlockActionsLabel, '區塊操作'),
			'editorBlockMoveHint': (value.editorBlockMoveHint, '按空白鍵開始移動，使用方向鍵選擇位置，再按空白鍵放下'),
			'editorMovePreviousLabel': (value.editorMovePreviousLabel, '上移'),
			'editorMoveNextLabel': (value.editorMoveNextLabel, '下移'),
			'editorParagraphLabel': (value.editorParagraphLabel, '段落'),
			'editorHeading1Label': (value.editorHeading1Label, '標題 1'),
			'editorHeading2Label': (value.editorHeading2Label, '標題 2'),
			'editorHeading3Label': (value.editorHeading3Label, '標題 3'),
			'editorOutdentLabel': (value.editorOutdentLabel, '減少縮排'),
			'editorIndentLabel': (value.editorIndentLabel, '增加縮排'),
			'editorOrderedListLabel': (value.editorOrderedListLabel, '編號清單'),
			'editorUnorderedListLabel': (value.editorUnorderedListLabel, '項目清單'),
			'editorBlockTypeLabel': (value.editorBlockTypeLabel, '區塊類型'),
			'editorTaskCompleteLabel': (value.editorTaskCompleteLabel, '完成任務'),
			'editorTaskReopenLabel': (value.editorTaskReopenLabel, '重新開啟任務'),
			'editorToggleCollapseLabel': (value.editorToggleCollapseLabel, '收合區塊'),
			'editorToggleExpandLabel': (value.editorToggleExpandLabel, '展開區塊'),
		};
		for (final entry in fields.entries) {
			expect(entry.value.$1, entry.value.$2, reason: entry.key);
		}
		expect(value.savedLabel('09:30'), 'Saved 09:30');
		expect(value.savedLabel(''), 'Saved ');
		expect(value.savedLabel('昨天 12:00'), 'Saved 昨天 12:00');
	});

	// 每個可覆寫欄位都必須參與值相等與 delegate 重載判斷。
	test('each override participates in equality and delegate reload', () {
		final changes = <String, stable.KlpLocalizations>{
			'toastNowLabel': stable.KlpLocalizations(toastNowLabel: 'consumer override'),
			'codeViewerCollapseLabel': stable.KlpLocalizations(codeViewerCollapseLabel: 'consumer override'),
			'codeViewerExpandLabel': stable.KlpLocalizations(codeViewerExpandLabel: 'consumer override'),
			'codeDataCopyLabel': stable.KlpLocalizations(codeDataCopyLabel: 'consumer override'),
			'codeDiffApproveLabel': stable.KlpLocalizations(codeDiffApproveLabel: 'consumer override'),
			'codeDiffRejectLabel': stable.KlpLocalizations(codeDiffRejectLabel: 'consumer override'),
			'codeTerminalClearLabel': stable.KlpLocalizations(codeTerminalClearLabel: 'consumer override'),
			'dataTableSelectAllLabel': stable.KlpLocalizations(dataTableSelectAllLabel: 'consumer override'),
			'dataTableSelectRowLabel': stable.KlpLocalizations(dataTableSelectRowLabel: 'consumer override'),
			'jsonTreeLoadingLabel': stable.KlpLocalizations(jsonTreeLoadingLabel: 'consumer override'),
			'jsonTreeInvalidLabel': stable.KlpLocalizations(jsonTreeInvalidLabel: 'consumer override'),
			'filePreviewOpenExternalLabel': stable.KlpLocalizations(filePreviewOpenExternalLabel: 'consumer override'),
			'filePreviewDownloadLabel': stable.KlpLocalizations(filePreviewDownloadLabel: 'consumer override'),
			'filePreviewLoadingLabel': stable.KlpLocalizations(filePreviewLoadingLabel: 'consumer override'),
			'filePreviewErrorLabel': stable.KlpLocalizations(filePreviewErrorLabel: 'consumer override'),
			'filePreviewUnsupportedLabel': stable.KlpLocalizations(filePreviewUnsupportedLabel: 'consumer override'),
			'filePreviewEmptyLabel': stable.KlpLocalizations(filePreviewEmptyLabel: 'consumer override'),
			'panelToggleLabel': stable.KlpLocalizations(panelToggleLabel: 'consumer override'),
			'windowMinimizeLabel': stable.KlpLocalizations(windowMinimizeLabel: 'consumer override'),
			'windowMaximizeLabel': stable.KlpLocalizations(windowMaximizeLabel: 'consumer override'),
			'windowRestoreLabel': stable.KlpLocalizations(windowRestoreLabel: 'consumer override'),
			'windowCloseLabel': stable.KlpLocalizations(windowCloseLabel: 'consumer override'),
			'searchPreviousResultLabel': stable.KlpLocalizations(searchPreviousResultLabel: 'consumer override'),
			'searchNextResultLabel': stable.KlpLocalizations(searchNextResultLabel: 'consumer override'),
			'searchCloseLabel': stable.KlpLocalizations(searchCloseLabel: 'consumer override'),
			'entityPickerRemoveLabel': stable.KlpLocalizations(entityPickerRemoveLabel: 'consumer override'),
			'entityPickerApplyLabel': stable.KlpLocalizations(entityPickerApplyLabel: 'consumer override'),
			'dockMoreActionsLabel': stable.KlpLocalizations(dockMoreActionsLabel: 'consumer override'),
			'oklchLightnessLabel': stable.KlpLocalizations(oklchLightnessLabel: 'consumer override'),
			'oklchChromaLabel': stable.KlpLocalizations(oklchChromaLabel: 'consumer override'),
			'oklchHueLabel': stable.KlpLocalizations(oklchHueLabel: 'consumer override'),
			'oklchAlphaLabel': stable.KlpLocalizations(oklchAlphaLabel: 'consumer override'),
			'oklchLightnessPlaneLabel': stable.KlpLocalizations(oklchLightnessPlaneLabel: 'consumer override'),
			'oklchChromaPlaneLabel': stable.KlpLocalizations(oklchChromaPlaneLabel: 'consumer override'),
			'oklchHuePlaneLabel': stable.KlpLocalizations(oklchHuePlaneLabel: 'consumer override'),
			'oklchOriginalPreviewLabel': stable.KlpLocalizations(oklchOriginalPreviewLabel: 'consumer override'),
			'oklchFallbackPreviewLabel': stable.KlpLocalizations(oklchFallbackPreviewLabel: 'consumer override'),
			'oklchFallbackWarningLabel': stable.KlpLocalizations(oklchFallbackWarningLabel: 'consumer override'),
			'formOptionsLabel': stable.KlpLocalizations(formOptionsLabel: 'consumer override'),
			'formPasswordShowLabel': stable.KlpLocalizations(formPasswordShowLabel: 'consumer override'),
			'formPasswordHideLabel': stable.KlpLocalizations(formPasswordHideLabel: 'consumer override'),
			'formQuantityDecreaseLabel': stable.KlpLocalizations(formQuantityDecreaseLabel: 'consumer override'),
			'formQuantityIncreaseLabel': stable.KlpLocalizations(formQuantityIncreaseLabel: 'consumer override'),
			'formDateRangeCalendarLabel': stable.KlpLocalizations(formDateRangeCalendarLabel: 'consumer override'),
			'editorUndoLabel': stable.KlpLocalizations(editorUndoLabel: 'consumer override'),
			'editorRedoLabel': stable.KlpLocalizations(editorRedoLabel: 'consumer override'),
			'editorMoreLabel': stable.KlpLocalizations(editorMoreLabel: 'consumer override'),
			'editorSaveLabel': stable.KlpLocalizations(editorSaveLabel: 'consumer override'),
			'editorUnsavedLabel': stable.KlpLocalizations(editorUnsavedLabel: 'consumer override'),
			'editorSavingLabel': stable.KlpLocalizations(editorSavingLabel: 'consumer override'),
			'editorSavedLabel': stable.KlpLocalizations(editorSavedLabel: 'consumer override'),
			'editorSaveFailedLabel': stable.KlpLocalizations(editorSaveFailedLabel: 'consumer override'),
			'editorSaveUnknownLabel': stable.KlpLocalizations(editorSaveUnknownLabel: 'consumer override'),
			'editorBlockActionsLabel': stable.KlpLocalizations(editorBlockActionsLabel: 'consumer override'),
			'editorBlockMoveHint': stable.KlpLocalizations(editorBlockMoveHint: 'consumer override'),
			'editorMovePreviousLabel': stable.KlpLocalizations(editorMovePreviousLabel: 'consumer override'),
			'editorMoveNextLabel': stable.KlpLocalizations(editorMoveNextLabel: 'consumer override'),
			'editorParagraphLabel': stable.KlpLocalizations(editorParagraphLabel: 'consumer override'),
			'editorHeading1Label': stable.KlpLocalizations(editorHeading1Label: 'consumer override'),
			'editorHeading2Label': stable.KlpLocalizations(editorHeading2Label: 'consumer override'),
			'editorHeading3Label': stable.KlpLocalizations(editorHeading3Label: 'consumer override'),
			'editorOutdentLabel': stable.KlpLocalizations(editorOutdentLabel: 'consumer override'),
			'editorIndentLabel': stable.KlpLocalizations(editorIndentLabel: 'consumer override'),
			'editorOrderedListLabel': stable.KlpLocalizations(editorOrderedListLabel: 'consumer override'),
			'editorUnorderedListLabel': stable.KlpLocalizations(editorUnorderedListLabel: 'consumer override'),
			'editorBlockTypeLabel': stable.KlpLocalizations(editorBlockTypeLabel: 'consumer override'),
			'editorTaskCompleteLabel': stable.KlpLocalizations(editorTaskCompleteLabel: 'consumer override'),
			'editorTaskReopenLabel': stable.KlpLocalizations(editorTaskReopenLabel: 'consumer override'),
			'editorToggleCollapseLabel': stable.KlpLocalizations(editorToggleCollapseLabel: 'consumer override'),
			'editorToggleExpandLabel': stable.KlpLocalizations(editorToggleExpandLabel: 'consumer override'),
			'savedLabel': stable.KlpLocalizations(savedLabel: (savedAt) => 'Consumer $savedAt'),
		};
		const original = stable.KlpLocalizations();
		const old = stable.KlpLocalizationsDelegate(original);
		expect(stable.KlpLocalizations(), original);
		expect(stable.KlpLocalizations().hashCode, original.hashCode);
		expect(original == Object(), isFalse);
		expect(old.shouldReload(const stable.KlpLocalizationsDelegate()), isFalse);
		for (final entry in changes.entries) {
			final value = entry.value;
			expect(value, isNot(original), reason: entry.key);
			expect(original, isNot(value), reason: entry.key);
			final delegate = stable.KlpLocalizationsDelegate(value);
			expect(delegate.shouldReload(old), isTrue, reason: entry.key);
			expect(old.shouldReload(delegate), isTrue, reason: entry.key);
			expect(delegate.shouldReload(stable.KlpLocalizationsDelegate(value)), isFalse, reason: entry.key);
		}
		expect(changes['savedLabel']!.savedLabel('09:30'), 'Consumer 09:30');
		final first = stable.KlpLocalizations(windowCloseLabel: 'consumer');
		final equal = stable.KlpLocalizations(windowCloseLabel: 'consumer');
		expect(first, equal);
		expect(first.hashCode, equal.hashCode);
		expect(stable.KlpLocalizationsDelegate(first).shouldReload(stable.KlpLocalizationsDelegate(equal)), isFalse);
	});

	test('delegate supports every locale and synchronously loads the supplied identity', () async {
		const values = [stable.KlpLocalizations(), stable.KlpLocalizations(windowCloseLabel: 'consumer')];
		const locales = [Locale('en'), Locale('zh', 'TW'), Locale('ar'), Locale('zz')];
		for (final value in values) {
			final delegate = stable.KlpLocalizationsDelegate(value);
			for (final locale in locales) {
				expect(delegate.isSupported(locale), isTrue);
				var completed = false;
				final future = delegate.load(locale);
				future.then((loaded) {
					expect(loaded, same(value));
					completed = true;
				});
				expect(completed, isTrue, reason: '既有 delegate 的 load 必須保持同步完成。');
				expect(await future, same(value));
			}
		}
	});

	testWidgets('missing scope uses built-in fallback and installed scope keeps override identity', (tester) async {
		late BuildContext observed;
		final child = Builder(builder: (context) {
			observed = context;
			return const SizedBox.shrink();
		});
		await tester.pumpWidget(child);
		expect(Localizations.of<stable.KlpLocalizations>(observed, stable.KlpLocalizations), isNull);
		expect(stable.KlpLocalizations.of(observed), const stable.KlpLocalizations());
		expect(stable.KlpLocalizations.of(observed).windowCloseLabel, 'Close window');

		const override = stable.KlpLocalizations(windowCloseLabel: 'consumer scope');
		final localized = Localizations(locale: const Locale('en'), delegates: const [DefaultWidgetsLocalizations.delegate, stable.KlpLocalizationsDelegate(override)], child: child);
		await tester.pumpWidget(localized);
		await tester.pump();
		expect(Localizations.of<stable.KlpLocalizations>(observed, stable.KlpLocalizations), same(override));
		expect(stable.KlpLocalizations.of(observed), same(override));
		expect(tester.takeException(), isNull);
	});

	test('seven recovered editor error defaults preserve original text', () {
		const value = stable.KlpLocalizations();
		final fields = <String, (String, String)>{
			'editorLoadFailedTitle': (value.editorLoadFailedTitle, '無法載入正文編輯器'),
			'editorLoadFailedMessage': (value.editorLoadFailedMessage, '本機編輯器尚未完成啟動，請再試一次。'),
			'editorRetryLabel': (value.editorRetryLabel, '重試'),
			'editorInterruptedTitle': (value.editorInterruptedTitle, '編輯器已中斷'),
			'editorInterruptedMessage': (value.editorInterruptedMessage, '編輯器已中斷。請保留此視窗並嘗試儲存；尚未儲存內容不會自動重載。'),
			'editorEnvironmentFailedTitle': (value.editorEnvironmentFailedTitle, '無法啟動正文編輯器'),
			'editorEnvironmentFailedMessage': (value.editorEnvironmentFailedMessage, '系統無法建立本機 WebView2 環境。請確認 WebView2 Runtime 已安裝後重新開啟。'),
		};
		for (final entry in fields.entries) {
			expect(entry.value.$1, entry.value.$2, reason: entry.key);
		}
	});

	test('every recovered error override participates in equality hash and delegate reload', () {
		final factories = <String, stable.KlpLocalizations Function(String)>{
			'editorLoadFailedTitle': (text) => stable.KlpLocalizations(editorLoadFailedTitle: text),
			'editorLoadFailedMessage': (text) => stable.KlpLocalizations(editorLoadFailedMessage: text),
			'editorRetryLabel': (text) => stable.KlpLocalizations(editorRetryLabel: text),
			'editorInterruptedTitle': (text) => stable.KlpLocalizations(editorInterruptedTitle: text),
			'editorInterruptedMessage': (text) => stable.KlpLocalizations(editorInterruptedMessage: text),
			'editorEnvironmentFailedTitle': (text) => stable.KlpLocalizations(editorEnvironmentFailedTitle: text),
			'editorEnvironmentFailedMessage': (text) => stable.KlpLocalizations(editorEnvironmentFailedMessage: text),
		};
		const original = stable.KlpLocalizations();
		const old = stable.KlpLocalizationsDelegate(original);
		for (final entry in factories.entries) {
			final first = entry.value('Consumer ${entry.key}');
			final equal = entry.value('Consumer ${entry.key}');
			expect(first, isNot(original), reason: entry.key);
			expect(original, isNot(first), reason: entry.key);
			expect(first, equal, reason: entry.key);
			expect(first.hashCode, equal.hashCode, reason: entry.key);
			expect(first.hashCode, isNot(original.hashCode), reason: entry.key);
			final delegate = stable.KlpLocalizationsDelegate(first);
			expect(delegate.shouldReload(old), isTrue, reason: entry.key);
			expect(old.shouldReload(delegate), isTrue, reason: entry.key);
			expect(delegate.shouldReload(stable.KlpLocalizationsDelegate(equal)), isFalse, reason: entry.key);
		}
	});

	// 與現有 load surface 測試共用主題／字型接線，只觀察字串、分支與真實重試 callback。
	testWidgets('BlockNote load error keeps defaults and uses overrides for retry and interrupted states', (tester) async {
		const override = stable.KlpLocalizations(
			editorLoadFailedTitle: 'Consumer load title',
			editorLoadFailedMessage: 'Consumer load message',
			editorRetryLabel: 'Consumer retry',
			editorInterruptedTitle: 'Consumer interrupted title',
			editorInterruptedMessage: 'Consumer interrupted message',
		);
		const cases = [
			(stable.KlpLocalizations(), '無法載入正文編輯器', '本機編輯器尚未完成啟動，請再試一次。', '重試', '編輯器已中斷', '編輯器已中斷。請保留此視窗並嘗試儲存；尚未儲存內容不會自動重載。'),
			(override, 'Consumer load title', 'Consumer load message', 'Consumer retry', 'Consumer interrupted title', 'Consumer interrupted message'),
		];
		for (final entry in cases) {
			var retries = 0;
			await tester.pumpWidget(_errorHost(true, () => retries++, entry.$1));
			await tester.pumpAndSettle();
			expect(find.text(entry.$2), findsOneWidget);
			expect(find.text(entry.$3), findsOneWidget);
			expect(find.text(entry.$4), findsOneWidget);
			expect(find.text(entry.$5), findsNothing);
			await tester.tap(find.text(entry.$4));
			await tester.pumpAndSettle();
			expect(retries, 1);

			await tester.pumpWidget(_errorHost(false, () => retries++, entry.$1));
			await tester.pumpAndSettle();
			expect(find.text(entry.$5), findsOneWidget);
			expect(find.text(entry.$6), findsOneWidget);
			expect(find.text(entry.$2), findsNothing);
			expect(find.text(entry.$4), findsNothing);
			expect(retries, 1, reason: '中斷提示不得自行重試或呼叫載入 callback。');
			expect(tester.takeException(), isNull);
		}
	});

	test('error construction guard accepts legal constructor syntax and rejects lookalike calls', () {
		for (final prefix in ['const ', 'new ', '']) {
			final source = "void render() { ${prefix}KlpErrorState(title: l10n.editorEnvironmentFailedTitle, message: l10n.editorEnvironmentFailedMessage); }";
			final unit = parseString(content: source).unit;
			final calls = _nodes(unit).map(_errorArguments).whereType<ArgumentList>().toList();
			expect(calls, hasLength(1), reason: '合法建構形式：$prefix');
			final arguments = {for (final argument in calls.single.arguments.whereType<NamedExpression>()) argument.name.label.name: argument.expression};
			expect(_usesLocalizationField(arguments['title'], 'editorEnvironmentFailedTitle', {'l10n'}), isTrue);
			expect(_usesLocalizationField(arguments['message'], 'editorEnvironmentFailedMessage', {'l10n'}), isTrue);
		}

		const lookalikes = [
			"fake.KlpErrorState(title: text, message: text)",
			"KlpErrorState.named(title: text, message: text)",
			"const KlpErrorState.named(title: text, message: text)",
			"OtherErrorState(title: text, message: text)",
			"'KlpErrorState(title: text, message: text)'",
			"null /* KlpErrorState(title: text, message: text) */",
		];
		for (final expression in lookalikes) {
			final unit = parseString(content: 'void render() { $expression; }').unit;
			expect(_nodes(unit).map(_errorArguments).whereType<ArgumentList>(), isEmpty, reason: expression);
		}
		final duplicate = parseString(content: 'void render() { KlpErrorState(); const KlpErrorState(); }').unit;
		expect(_nodes(duplicate).map(_errorArguments).whereType<ArgumentList>(), hasLength(2));
	});

	test('native environment failure branch reads title and message from the existing localization scope', () {
		const path = 'lib/src/rendering/flutter/internal/klp_flutter_block_note_editing.dart';
		final source = File(path).readAsStringSync();
		final parsed = parseString(content: source, path: path, throwIfDiagnostics: false);
		expect(parsed.errors, isEmpty);
		final nodes = _nodes(parsed.unit).toList();
		final bindings = nodes.whereType<VariableDeclaration>().where((node) => _isLocalizationLookup(node.initializer)).map((node) => node.name.lexeme).toSet();
		final branches = nodes.whereType<IfStatement>().where((node) => node.expression.toSource().endsWith('.hasError'));
		final errors = branches.expand((node) => _nodes(node.thenStatement)).map(_errorArguments).whereType<ArgumentList>().toList();
		expect(errors, hasLength(1));
		final arguments = {for (final argument in errors.single.arguments.whereType<NamedExpression>()) argument.name.label.name: argument.expression};
		expect(_usesLocalizationField(arguments['title'], 'editorEnvironmentFailedTitle', bindings), isTrue);
		expect(_usesLocalizationField(arguments['message'], 'editorEnvironmentFailedMessage', bindings), isTrue);
		final imports = parsed.unit.directives.whereType<ImportDirective>().map((node) => node.uri.stringValue ?? '');
		expect(imports.any((uri) => uri.endsWith('/foundation/localization/klp_localizations.dart')), isTrue);
	});

	test('Stable and umbrella retain the same localization types', () {
		expect(owner.KlpLocalizations, stable.KlpLocalizations);
		expect(owner.KlpLocalizationsDelegate, stable.KlpLocalizationsDelegate);
		expect(stable.KlpLocalizations, umbrella.KlpLocalizations);
		expect(stable.KlpLocalizationsDelegate, umbrella.KlpLocalizationsDelegate);
		const umbrella.KlpLocalizations value = stable.KlpLocalizations();
		const stable.KlpLocalizationsDelegate delegate = umbrella.KlpLocalizationsDelegate(value);
		expect(delegate.overrides, same(value));
	});
}

Widget _errorHost(bool canRetry, VoidCallback onRetry, stable.KlpLocalizations localizations) {
	return MaterialApp(theme: umbrella.buildKlpTheme(Brightness.light), localizationsDelegates: [stable.KlpLocalizationsDelegate(localizations)], home: Scaffold(body: KlpBlockNoteLoadError(canRetry: canRetry, onRetry: onRetry)));
}

Iterable<AstNode> _nodes(AstNode root) sync* {
	yield root;
	for (final child in root.childEntities.whereType<AstNode>()) {
		yield* _nodes(child);
	}
}

ArgumentList? _errorArguments(AstNode node) {
	// 未解析 AST 將無 const/new 的預設建構子表示為 MethodInvocation；兩種語法仍須精確指向同一建構子。
	if (node is InstanceCreationExpression && node.constructorName.type.toSource() == 'KlpErrorState' && node.constructorName.name == null) return node.argumentList;
	if (node is MethodInvocation && node.target == null && node.methodName.name == 'KlpErrorState') return node.argumentList;

	return null;
}

bool _isLocalizationLookup(Expression? expression) {
	return expression is MethodInvocation && expression.target?.toSource() == 'KlpLocalizations' && expression.methodName.name == 'of' && expression.argumentList.arguments.length == 1;
}

bool _usesLocalizationField(Expression? expression, String field, Set<String> bindings) {
	if (expression is PrefixedIdentifier) return expression.identifier.name == field && bindings.contains(expression.prefix.name);
	if (expression is! PropertyAccess || expression.propertyName.name != field) return false;

	final target = expression.target;
	return _isLocalizationLookup(target) || target is SimpleIdentifier && bindings.contains(target.name);
}
