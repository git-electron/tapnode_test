part of '../../../home_screen.dart';

double _documentGridItemHeight({
  required BuildContext context,
  required DocumentModel document,
  required double maxWidth,
}) {
  return _documentTitleHasTwoLines(
        context: context,
        title: document.title,
        maxWidth: maxWidth,
      )
      ? 240
      : 224;
}

bool _documentTitleHasTwoLines({
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
