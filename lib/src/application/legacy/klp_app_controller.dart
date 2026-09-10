import 'package:flutter/material.dart';

import '../../foundation/interaction/keybinding/klp_key_binding_controller.dart';

/// Kallopis 應用程式對外提供的控制介面。
abstract class KlpAppController {
	Brightness get brightness;
	ThemeMode get themeMode;
	void toggleBrightness();
	void setThemeMode(ThemeMode mode);
	KlpKeyBindingController get keyBindings;
}
