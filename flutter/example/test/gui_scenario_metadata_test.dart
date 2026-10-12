import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis_catalog/gui_scenario_metadata.dart';

Map<String, Object?> _entry(Object? title, Object? reference) => {
	'title': title,
	'reference': reference,
};

void main() {
	const reference = 'https://example.org/docs/workbench?view=layout#panels';

	test('任意非空登錄表保留資料、依識別碼排序且不修改輸入', () {
		final source = jsonDecode('''{
			"zebra-2": {
				"title": "第二個工作台",
				"reference": "https://example.org/zebra"
			},
			"alpha": {
				"title": "第一個工作台",
				"reference": "https://example.org/alpha?view=layout#panels"
			}
		}''');
		final original = jsonEncode(source);
		final result = GuiScenarioMetadata.fromJson(source);

		expect(result.map((entry) => entry.id), ['alpha', 'zebra-2']);
		expect(
			result.map((entry) => entry.title),
			['第一個工作台', '第二個工作台'],
		);
		expect(
			result.map((entry) => entry.reference),
			[
				'https://example.org/alpha?view=layout#panels',
				'https://example.org/zebra',
			],
		);
		expect(jsonEncode(source), original);
	});

	test('單筆有效資料可以解析，不固定場景數量', () {
		final result = GuiScenarioMetadata.fromJson({
			'a': _entry('獨立場景', reference),
		});

		expect(result, hasLength(1));
		expect(result.single.id, 'a');
		expect(result.single.title, '獨立場景');
		expect(result.single.reference, reference);
	});

	test('回傳清單與欄位唯讀，輸入後續變更不影響結果', () {
		final entry = _entry('原始標題', reference);
		final source = {'scene': entry};
		final result = GuiScenarioMetadata.fromJson(source);
		final metadata = result.single;

		expect(() => result.add(metadata), throwsUnsupportedError);
		expect(() => result[0] = metadata, throwsUnsupportedError);
		expect(() => result.clear(), throwsUnsupportedError);
		// 透過動態呼叫驗證公開資料無可寫入的欄位。
		final dynamic exposed = metadata;
		expect(() => exposed.id = 'other', throwsNoSuchMethodError);
		expect(() => exposed.title = '其他標題', throwsNoSuchMethodError);
		expect(() => exposed.reference = reference, throwsNoSuchMethodError);
		entry['title'] = '已改變';
		entry['reference'] = 'https://example.org/changed';
		source.clear();
		expect(metadata.id, 'scene');
		expect(metadata.title, '原始標題');
		expect(metadata.reference, reference);
	});

	final invalidRoots = <String, Object?>{
		'null': null,
		'陣列': <Object?>[],
		'字串': 'scene',
		'數字': 1,
		'空登錄表': <String, Object?>{},
	};
	for (final invalid in invalidRoots.entries) {
		test('拒絕非法根資料：${invalid.key}', () {
			expect(
				() => GuiScenarioMetadata.fromJson(invalid.value),
				throwsException,
			);
		});
	}

	final invalidIds = <Object?>[
		null,
		1,
		'',
		'Uppercase',
		'1scene',
		'-scene',
		'scene_name',
		'scene/name',
		'scene name',
		'scene\n',
		'場景',
	];
	for (final id in invalidIds) {
		test('拒絕非法識別碼：${jsonEncode(id)}', () {
			expect(
				() => GuiScenarioMetadata.fromJson({
					id: _entry('場景', reference),
				}),
				throwsException,
			);
		});
	}

	final invalidRecords = <String, Object?>{
		'null': null,
		'陣列': <Object?>[],
		'字串': 'scene',
		'空記錄': <String, Object?>{},
		'缺少標題': {'reference': reference},
		'缺少引用': {'title': '場景'},
		'空標題': _entry('', reference),
		'非字串標題': _entry(1, reference),
		'null 標題': _entry(null, reference),
		'空引用': _entry('場景', ''),
		'非字串引用': _entry('場景', 1),
		'null 引用': _entry('場景', null),
		'HTTP 引用': _entry('場景', 'http://example.org/docs'),
		'相對引用': _entry('場景', '/docs'),
		'無協定引用': _entry('場景', '//example.org/docs'),
		'缺少主機': _entry('場景', 'https:///docs'),
		'僅有協定': _entry('場景', 'https://'),
		'非 HTTPS 協定': _entry('場景', 'mailto:user@example.org'),
		'URI 格式非法': _entry('場景', 'https://[broken'),
	};
	for (final invalid in invalidRecords.entries) {
		test('拒絕非法場景記錄：${invalid.key}', () {
			expect(
				() => GuiScenarioMetadata.fromJson({'scene': invalid.value}),
				throwsException,
			);
		});
	}

	test('重複標題拒絕且不修改原始登錄表', () {
		final source = {
			'alpha': _entry('相同標題', reference),
			'beta': _entry('相同標題', 'https://example.org/beta'),
		};
		final original = jsonEncode(source);

		expect(
			() => GuiScenarioMetadata.fromJson(source),
			throwsException,
		);
		expect(jsonEncode(source), original);
	});
}
