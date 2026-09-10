import 'klp_location.dart';

/// 每次推入取得獨立生命週期識別；參數必須由消費端提供不可變值。
final class KlpNavigationEntry {

	final String id;
	final KlpLocation<Object?> location;

	const KlpNavigationEntry(this.id, this.location);
}
