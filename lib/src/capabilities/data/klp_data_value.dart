part of 'klp_data_state.dart';

/// 已採納的資料；泛型允許以空值作為合法結果。
final class KlpDataValue<T> extends KlpDataState<T> {

	final T value;

	const KlpDataValue(this.value);
}
