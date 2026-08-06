extension DateTimeExtensions on DateTime {
  String get formattedDate {
    return '${day._twoDigits}.${month._twoDigits}.$year';
  }
}

extension on int {
  String get _twoDigits => toString().padLeft(2, '0');
}
