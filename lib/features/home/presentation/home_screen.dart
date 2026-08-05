import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/widgets/interactive/glass_icon_button.dart';
import 'package:liquid_glass_widgets/widgets/shared/glass_page.dart';
import 'package:liquid_glass_widgets/widgets/surfaces/glass_scaffold.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../gen/assets.gen.dart';

part 'widgets/_app_bar.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: context.colors.appBar,
      statusBarStyle: GlassStatusBarStyle.light,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _AppBar(),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                child: ColoredBox(
                  color: context.colors.background,
                  child: ListView.builder(
                    itemBuilder: (context, index) => Text(index.toString()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
