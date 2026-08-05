import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/system_ui_overlay.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Signica',
      theme: AppTheme.light,
      routerConfig: _appRouter.config(),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: appSystemUiOverlayStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
