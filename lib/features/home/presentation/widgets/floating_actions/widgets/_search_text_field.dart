part of '../../../home_screen.dart';

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      placeholder: 'home.floating_actions.search_documents'.tr(),
      autocorrect: false,
      enableSuggestions: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(),
      style: context.styles.text1.copyWith(
        color: context.colors.textPrimary,
      ),
      cursorColor: const Color(0xff0088FF),
      onChanged: (text) {
        context.read<DocumentsBloc>().add(
          DocumentsEvent.searchChanged(text),
        );
      },
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      onEditingComplete: () {
        if (controller.text.isNotEmpty) {
          focusNode.unfocus();
          return;
        }

        context.read<FloatingActionsBloc>().add(
          const FloatingActionsEvent.closeSearch(),
        );
      },
      placeholderStyle: context.styles.text1.copyWith(
        color: context.colors.textSecondary.withValues(alpha: .35),
      ),
    );
  }
}
