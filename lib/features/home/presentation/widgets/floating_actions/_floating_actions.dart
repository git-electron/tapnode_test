part of '../../home_screen.dart';

class _FloatingActions extends StatelessWidget {
  const _FloatingActions();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: Stack(
        children: [
          _FloatingActionsBackdrop(),
          _AddDocumentPopupActions(),
          _FloatingActionButtons(),
        ],
      ),
    );
  }
}
