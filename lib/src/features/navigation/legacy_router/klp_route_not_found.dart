part of 'klp_router.dart';

/// 找不到已註冊目的地時拋出的明確程式錯誤。
class KlpRouteNotFound extends Error {
	KlpRouteNotFound(this.id, this.known);

	final String id;
	final Iterable<String> known;

	@override
	String toString() =>
			'KlpRouteNotFound: 沒有註冊 id 為 "$id" 的目的地。'
			'已註冊的有：${known.isEmpty ? '（無）' : known.join('、')}';
}
