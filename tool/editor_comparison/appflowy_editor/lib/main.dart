import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storageKey = 'kallopis-editor-comparison-appflowy';

void main() {
	runApp(const PrototypeApp());
}

class PrototypeApp extends StatelessWidget {

	const PrototypeApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'AppFlowy Editor 原型',
			localizationsDelegates: const [AppFlowyEditorLocalizations.delegate],
			theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
			home: const EditorPrototypePage(),
		);
	}
}

class EditorPrototypePage extends StatefulWidget {

	const EditorPrototypePage({super.key});

	@override
	State<EditorPrototypePage> createState() => _EditorPrototypePageState();
}

class _EditorPrototypePageState extends State<EditorPrototypePage> {

	late EditorState editorState;
	String status = '正在讀取本機存檔…';

	@override
	void initState() {
		super.initState();
		editorState = EditorState.blank(withInitialText: true);
		loadSavedOnStart();
	}

	@override
	void dispose() {
		editorState.dispose();
		super.dispose();
	}

	Future<void> loadSavedOnStart() async {
		// 從跨平台本機儲存讀取上次明確保存的文件。
		final preferences = await SharedPreferences.getInstance();
		final saved = preferences.getString(storageKey);
		if (!mounted) return;

		if (saved == null) {
			setState(() => status = '尚無本機存檔');
			return;
		}

		try {
			replaceDocument(Document.fromJson(jsonDecode(saved) as Map<String, dynamic>), '已載入本機存檔');
		}
		catch (_) {
			setState(() => status = '本機存檔無法讀取');
		}
	}

	void replaceDocument(Document document, String message) {
		final previous = editorState;
		setState(() {
			editorState = EditorState(document: document);
			status = message;
		});
		previous.dispose();
	}

	Future<void> saveDocument() async {
		// 明確按下儲存才寫入跨平台本機儲存。
		final preferences = await SharedPreferences.getInstance();
		await preferences.setString(storageKey, jsonEncode(editorState.document.toJson()));
		if (!mounted) return;

		setState(() => status = '已儲存');
	}

	Future<void> reopenDocument() async {
		// 重新讀取上次明確儲存的內容。
		final preferences = await SharedPreferences.getInstance();
		final saved = preferences.getString(storageKey);
		if (!mounted) return;

		if (saved == null) {
			setState(() => status = '尚無本機存檔');
			return;
		}

		replaceDocument(Document.fromJson(jsonDecode(saved) as Map<String, dynamic>), '已從上次存檔重開');
	}

	Document createSampleDocument() {
		final sampleImageUrl = Uri.base.resolve('assets/assets/sample-image.png').toString();
		final richText = Delta()
			..insert('這是中文段落，用於比較編輯、選取與字型呈現。')
			..insert('粗體', attributes: {'bold': true})
			..insert('、')
			..insert('斜體', attributes: {'italic': true})
			..insert('與')
			..insert('標記', attributes: {'bg_color': '#fff59d'})
			..insert('文字也在同一段。');
		final nestedList = bulletedListNode(
			text: '第一層清單',
			children: [
				bulletedListNode(text: '第二層清單 A'),
				bulletedListNode(text: '第二層清單 B'),
			],
		);
		final table = TableNode.fromList<String>([
			['欄位', '中文', '保存'],
			['說明', '表格內容', '手動儲存後可重開'],
		]).node;

		return Document(
			root: Node(
				type: 'page',
				children: [
					paragraphNode(delta: richText),
					nestedList,
					table,
					imageNode(url: sampleImageUrl, width: 720, height: 240),
				],
			),
		);
	}

	Document createLongDocument() {
		return Document(
			root: Node(
				type: 'page',
				children: List.generate(
					400,
					(index) => paragraphNode(text: '長文段落 ${index + 1}：這是用於手動觀察捲動、輸入延遲與選取表現的中文內容。'),
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('AppFlowy Editor 原型'),
				actions: [
					TextButton(onPressed: () => replaceDocument(createSampleDocument(), '已載入共同範例'), child: const Text('載入範例')),
					TextButton(onPressed: () => replaceDocument(createLongDocument(), '已載入 400 段長文'), child: const Text('載入長文')),
					TextButton(onPressed: saveDocument, child: const Text('儲存')),
					TextButton(onPressed: reopenDocument, child: const Text('重開')),
					const SizedBox(width: 12),
				],
			),
			body: Column(
				children: [
					Container(
						width: double.infinity,
						padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
						color: Theme.of(context).colorScheme.surfaceContainerLow,
						child: Text(status),
					),
					Expanded(
						child: Padding(
							padding: const EdgeInsets.all(24),
							child: AppFlowyEditor(editorState: editorState),
						),
					),
				],
			),
		);
	}
}
