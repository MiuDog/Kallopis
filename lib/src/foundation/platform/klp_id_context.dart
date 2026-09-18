import 'package:flutter/widgets.dart';

import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_id_scope.dart';

/// 讓 Flutter 元件可直接取得最近的渲染期識別範圍。
extension KlpIdBuildContext on BuildContext {
	KlpId get klpId => KlpIdScope.of(this);

	KlpId? get maybeKlpId => KlpIdScope.maybeOf(this);
}
