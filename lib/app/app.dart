import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;
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
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Signica',
      theme: AppTheme.light,
      routerConfig: _appRouter.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: appSystemUiOverlayStyle,
          child: Theme(
            data: AppTheme.materialLight,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
