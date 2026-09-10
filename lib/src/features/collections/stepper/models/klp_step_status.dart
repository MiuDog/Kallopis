part of '../klp_stepper.dart';

/// 單一步驟相對於 [KlpStepper.currentIndex] 的狀態。
///
/// 由 [KlpStepper] 依步驟位置自動推導，呼叫端不需要（也不應該）自行指定——
/// 三態永遠只由「目前在第幾步」這一個事實決定。
enum KlpStepStatus { completed, current, upcoming }
