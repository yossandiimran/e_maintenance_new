class AppResult<T> {
  const AppResult.success(this.data, {this.statusCode}) : errorMessage = null;
  const AppResult.failure(this.errorMessage, {this.statusCode}) : data = null;

  final T? data;
  final String? errorMessage;
  final int? statusCode;

  bool get isSuccess => errorMessage == null;
}
