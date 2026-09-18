import 'dart:convert';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:win32/win32.dart';

/// Windows host 的版本化 BlockNote 文件儲存；替換失敗時原檔保持不動。
final class BlockNoteFileStore {
	final File file;
	BlockNoteFileStore(this.file);

	Future<KlpBlockNoteDocument?> read() async {
		if (!await file.exists()) return null;
		final decoded = jsonDecode(await file.readAsString());
		if (decoded is! Map) throw const FormatException('BlockNote file root must be an object');
		return KlpBlockNoteDocument.fromJson(Map<String, Object?>.from(decoded));
	}

	Future<void> write(KlpBlockNoteDocument document) async {
		await file.parent.create(recursive: true);
		final temporary = File('${file.path}.tmp-$pid-${DateTime.now().microsecondsSinceEpoch}');
		try {
			// 先完整寫入並 flush 暫存檔，再用 Windows replace 語意一次提交。
			await temporary.writeAsString(jsonEncode(document.toJson()), flush: true);
			_replace(temporary.path, file.path);
		}
		finally {
			if (await temporary.exists()) await temporary.delete();
		}
	}

	void _replace(String source, String destination) {
		final sourcePointer = source.toNativeUtf16();
		final destinationPointer = destination.toNativeUtf16();
		try {
			// MoveFileExW 以 replace-existing 與 write-through 保證不先刪除既有文件。
			final result = MoveFileEx(PCWSTR(sourcePointer), PCWSTR(destinationPointer), MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH);
			if (!result.value) throw WindowsException(result.error.toHRESULT());
		}
		finally {
			calloc.free(sourcePointer);
			calloc.free(destinationPointer);
		}
	}
}
