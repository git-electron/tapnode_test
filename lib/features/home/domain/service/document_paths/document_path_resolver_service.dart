abstract interface class DocumentPathResolverService {
  Future<String> resolveManagedPath(String path);

  Future<List<String>> resolveManagedPaths(List<String> paths);
}
