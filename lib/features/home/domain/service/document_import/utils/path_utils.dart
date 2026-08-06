String documentImportTitleFromPath(String path) {
  final fileName = documentImportFileNameFromPath(path);
  final extensionIndex = fileName.lastIndexOf('.');

  if (extensionIndex <= 0) return fileName;

  return fileName.substring(0, extensionIndex);
}

String documentImportFileNameFromPath(String path) {
  final normalizedPath = path.replaceAll(r'\', '/');

  return normalizedPath.split('/').last;
}
