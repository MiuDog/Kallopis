/// 本庫派送操作後回報是否真正提交；導覽 guard 拒絕不改變元件選取狀態。
final class KlpActionActivation {
  final bool committed;

  const KlpActionActivation(this.committed);
}
