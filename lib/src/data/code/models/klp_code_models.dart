import 'package:flutter/foundation.dart';

/// Code Viewer 可用的語言選項。
@immutable
class KlpCodeLanguageOption {
	const KlpCodeLanguageOption({
		required this.id,
		required this.label,
		this.supportsView = false,
	});

	final String id;
	final String label;
	final bool supportsView;
}

/// Code Viewer 的預設語言清單。
abstract final class KlpCodeLanguages {
	static const options = <KlpCodeLanguageOption>[
		KlpCodeLanguageOption(id: 'text', label: 'Plain text'),
		KlpCodeLanguageOption(id: 'shell', label: 'Shell'),
		KlpCodeLanguageOption(id: 'c', label: 'C'),
		KlpCodeLanguageOption(id: 'cpp', label: 'C++'),
		KlpCodeLanguageOption(id: 'csharp', label: 'C#'),
		KlpCodeLanguageOption(id: 'css', label: 'CSS'),
		KlpCodeLanguageOption(id: 'dart', label: 'Dart'),
		KlpCodeLanguageOption(id: 'go', label: 'Go'),
		KlpCodeLanguageOption(id: 'html', label: 'HTML', supportsView: true),
		KlpCodeLanguageOption(id: 'java', label: 'Java'),
		KlpCodeLanguageOption(id: 'javascript', label: 'JavaScript'),
		KlpCodeLanguageOption(id: 'json', label: 'JSON'),
		KlpCodeLanguageOption(id: 'kotlin', label: 'Kotlin'),
		KlpCodeLanguageOption(id: 'markdown', label: 'Markdown', supportsView: true),
		KlpCodeLanguageOption(id: 'mermaid', label: 'Mermaid', supportsView: true),
		KlpCodeLanguageOption(id: 'php', label: 'PHP'),
		KlpCodeLanguageOption(id: 'python', label: 'Python'),
		KlpCodeLanguageOption(id: 'rust', label: 'Rust'),
		KlpCodeLanguageOption(id: 'sql', label: 'SQL'),
		KlpCodeLanguageOption(id: 'swift', label: 'Swift'),
		KlpCodeLanguageOption(id: 'typescript', label: 'TypeScript'),
		KlpCodeLanguageOption(id: 'yaml', label: 'YAML'),
	];
}

/// Code Viewer 的介面文字。
@immutable
class KlpCodeViewerLabels {
	const KlpCodeViewerLabels({
		required this.copy,
		required this.menu,
		required this.toggleView,
		required this.languageMenu,
		required this.wrap,
		required this.lineNumbers,
	});

	static const english = KlpCodeViewerLabels(
		copy: 'Copy',
		menu: 'Code menu',
		toggleView: 'Switch view',
		languageMenu: 'Code language',
		wrap: 'Wrap lines',
		lineNumbers: 'Line numbers',
	);

	final String copy;
	final String menu;
	final String toggleView;
	final String languageMenu;
	final String wrap;
	final String lineNumbers;
}

enum KlpDiffLineType { unchanged, added, deleted }

/// Diff 單行資料。
@immutable
class KlpDiffLine {
	const KlpDiffLine({
		this.oldNumber,
		this.newNumber,
		required this.content,
		this.type = KlpDiffLineType.unchanged,
		this.onApprove,
		this.onReject,
	});

	final int? oldNumber;
	final int? newNumber;
	final String content;
	final KlpDiffLineType type;
	final VoidCallback? onApprove;
	final VoidCallback? onReject;
}
