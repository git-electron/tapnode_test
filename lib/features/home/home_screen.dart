import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tapnode_test/app/theme/app_colors.dart';
import 'package:tapnode_test/app/theme/app_text_styles.dart';
import 'package:tapnode_test/gen/assets.gen.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Tapnode',
          style: textStyles.logo.copyWith(color: colors.white),
        ),
      ),
      body: Center(
        child: Assets.images.logo.image(width: 120, fit: BoxFit.contain),
      ),
    );
  }
}
