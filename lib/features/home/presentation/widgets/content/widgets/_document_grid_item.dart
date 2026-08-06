part of '../../../home_screen.dart';

class _DocumentGridItem extends StatelessWidget {
  const _DocumentGridItem({
    required this.document,
    required this.selectionMode,
    required this.isSelected,
  });

  final DocumentModel document;
  final bool selectionMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final titleHasTwoLines = _titleHasTwoLines(
          context: context,
          maxWidth: constraints.maxWidth,
        );
        final height = titleHasTwoLines ? 240.0 : 224.0;

        return SizedBox(
          height: height,
          width: double.maxFinite,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  _DocumentPreview(document: document),
                  Positioned(
                    bottom: -10,
                    child: _DocumentSignedMark(visible: document.isSigned),
                  ),
                  Positioned.fill(
                    child: Align(
                      child: _DocumentSelectionMark(
                        visible: selectionMode,
                        selected: isSelected,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(15),
              Text(
                document.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.styles.header3,
              ),
              const Gap(4),
              Text(
                document.createdAt.formattedDate,
                style: context.styles.text2.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _titleHasTwoLines({
    required BuildContext context,
    required double maxWidth,
  }) {
    return _documentTitleHasTwoLines(
      context: context,
      title: document.title,
      maxWidth: maxWidth,
    );
  }
}
