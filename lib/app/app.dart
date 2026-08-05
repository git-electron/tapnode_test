import 'package:flutter/material.dart';
import 'package:tapnode_test/app/router/app_router.dart';
import 'package:tapnode_test/app/theme/app_theme.dart';

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
      title: 'Tapnode',
      theme: AppTheme.light,
      routerConfig: _appRouter.config(),
    );
  }
}
