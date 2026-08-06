import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/gen/assets.gen.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/app_glass_button.dart';
import '../domain/bloc/floating_actions_bloc.dart';

part 'widgets/_app_bar.dart';
part 'widgets/_body.dart';
part 'widgets/content/_content.dart';
part 'widgets/content/_documents_list.dart';
part 'widgets/content/_filters_tab_bar.dart';
part 'widgets/floating_actions/_add_document_button.dart';
part 'widgets/floating_actions/_floating_actions.dart';
part 'widgets/floating_actions/_search_button.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: context.colors.appBar,
      statusBarStyle: GlassStatusBarStyle.light,
      settings: LiquidGlassSettings(
        blur: 14,
        thickness: 28,
        refractiveIndex: 1.14,
        chromaticAberration: .18,
        lightIntensity: 1.4,
        saturation: 1.2,
        whitenStrength: .35,
        whitenGated: false,
        shadow: [
          BoxShadow(
            color: context.colors.white.withValues(alpha: .72),
            blurRadius: 34,
            spreadRadius: 3,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: context.colors.black.withValues(alpha: .08),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => FloatingActionsBloc(),
        child: const SafeArea(
          bottom: false,
          child: Column(
            children: [
              _AppBar(),
              Expanded(child: _Body()),
            ],
          ),
        ),
      ),
    );
  }
}
