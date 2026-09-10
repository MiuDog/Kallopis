part of 'klp_finite_workflow.dart';

/// 有限工作流的語意狀態；狀態轉移仍由呼叫端控制。
enum KlpWorkflowState {
  empty,
  collecting,
  reviewing,
  ready,
  stale,
  applying,
  applied,
  failed,
}
