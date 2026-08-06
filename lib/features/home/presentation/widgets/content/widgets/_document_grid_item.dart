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

  static double itemHeight({
    required BuildContext context,
    required DocumentModel document,
    required double maxWidth,
  }) {
    return titleHasTwoLines(
          context: context,
          title: document.title,
          maxWidth: maxWidth,
        )
        ? 240
        : 224;
  }

  static bool titleHasTwoLines({
    required BuildContext context,
    required String title,
    required double maxWidth,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: context.styles.header3,
      ),
      maxLines: 2,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length > 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasTwoTitleLines = titleHasTwoLines(
          context: context,
          title: document.title,
          maxWidth: constraints.maxWidth,
        );
        final height = hasTwoTitleLines ? 240.0 : 224.0;

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
}
