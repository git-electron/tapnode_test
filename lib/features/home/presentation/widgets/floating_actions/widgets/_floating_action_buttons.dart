part of '../../../home_screen.dart';

class _FloatingActionButtons extends StatelessWidget {
  const _FloatingActionButtons();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Padding(
          padding: Pad(all: 12),
          child: Stack(
            children: [
              _AddDocumentPopupTitle(),
              TextFieldTapRegion(
                child: Row(
                  children: [
                    _SearchButton(),
                    Gap(12),
                    _AddDocumentButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
