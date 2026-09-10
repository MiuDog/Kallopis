part of 'klp_code_models.dart';

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
		KlpCodeLanguageOption(
			id: 'markdown',
			label: 'Markdown',
			supportsView: true,
		),
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
