/// 宣告或註冊違反契約時的可辨識錯誤。
final class KlpContractError implements Exception {
  final String code;
  final String message;

  const KlpContractError(this.code, this.message);

  @override
  String toString() => 'KlpContractError($code): $message';
}
