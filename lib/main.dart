import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_glass_widgets/liquid_glass_setup.dart';

import 'app/app.dart';
import 'app/di/injector.dart';
import 'app/theme/system_ui_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  await configureDependencies();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  SystemChrome.setSystemUIOverlayStyle(appSystemUiOverlayStyle);

  runApp(LiquidGlassWidgets.wrap(child: const App()));
}
