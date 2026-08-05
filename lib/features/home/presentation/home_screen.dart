import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../gen/assets.gen.dart';

part 'widgets/_app_bar.dart';
part 'widgets/_body.dart';
part 'widgets/_content.dart';
part 'widgets/_documents_list.dart';
part 'widgets/_filters_tab_bar.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: context.colors.appBar,
      statusBarStyle: GlassStatusBarStyle.light,
      body: const SafeArea(
        bottom: false,
        child: Column(
          children: [
            _AppBar(),
            Expanded(child: _Body()),
          ],
        ),
      ),
    );
  }
}
