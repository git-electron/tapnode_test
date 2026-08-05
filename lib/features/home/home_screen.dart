import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../gen/assets.gen.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.appBar,
      body: Center(
        child: Assets.images.logo.image(
          width: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
