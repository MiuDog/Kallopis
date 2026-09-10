part of '../klp_menu.dart';

/// [KlpMenu] 系列元件共用的文字角色，目前只有一項。獨立成類別是為了讓未來
/// 若要新增更多共用樣式常數時有現成的落點，不必再改動呼叫端。
abstract final class KlpMenuStyle {
	static const KlpTextRole textRole = KlpTextRole.label;
}
