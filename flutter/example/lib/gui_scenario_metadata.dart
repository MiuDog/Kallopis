class GuiScenarioMetadata {
	const GuiScenarioMetadata({required this.id, required this.title, required this.reference});
	/* 路由、可見標題與官方引用只由同一份 package asset 擁有。 */
	final String id;
	final String title;
	final String reference;

	static List<GuiScenarioMetadata> fromJson(Object? value) {
		if (value is! Map || value.isEmpty) throw const FormatException('Invalid GUI scenario registry');
		final titles = <String>{};
		final result = <GuiScenarioMetadata>[];
		for (final entry in value.entries) {
			final id = entry.key;
			final data = entry.value;
			if (id is! String || !RegExp(r'^[a-z][a-z0-9-]*$').hasMatch(id) || data is! Map) throw const FormatException('Invalid GUI scenario identity');
			final title = data['title'];
			final reference = data['reference'];
			if (title is! String || title.trim().isEmpty || !titles.add(title)) throw const FormatException('Invalid GUI scenario title');
			final uri = reference is String ? Uri.tryParse(reference) : null;
			if (uri == null || uri.scheme != 'https' || !uri.hasAuthority || uri.host.isEmpty) throw const FormatException('Invalid GUI scenario reference');
			result.add(GuiScenarioMetadata(id: id, title: title, reference: reference as String));
		}
		result.sort((a, b) => a.id.compareTo(b.id));
		return List.unmodifiable(result);
	}
}
