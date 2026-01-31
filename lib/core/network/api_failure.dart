class ApiFailure {
  final String message;
  final int? statusCode;

  ApiFailure(this.message, {this.statusCode});

  @override
  String toString() => message;
}