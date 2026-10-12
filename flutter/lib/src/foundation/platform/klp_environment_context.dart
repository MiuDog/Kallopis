import 'package:flutter/widgets.dart';

import 'klp_environment_scope.dart';
import 'klp_platform_info.dart';

/// 讓元件直接讀取平台環境，不訂閱 App 控制狀態。
extension KlpEnvironmentContext on BuildContext {
  KlpPlatformInfo get klpPlatform => KlpEnvironmentScope.of(this);
}
