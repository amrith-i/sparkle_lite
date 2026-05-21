class ApiValidationException implements Exception {
  final Map<String, List<String>> errors;

  ApiValidationException(this.errors);

  @override
  String toString() => 'ApiValidationException: $errors';
}
