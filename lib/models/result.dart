class Result<T> {
  String? errorMessage;
  int? returnCode;
  bool isSuccess;
  T? content;

  Result({this.errorMessage, this.returnCode, required this.isSuccess, this.content});

  factory Result.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return Result(
      errorMessage: json['errorMessage'],
      returnCode: json['returnCode'],
      isSuccess: json['isSuccess'],
      content: json['content'] != null ? fromJson(json['content']) : null,
    );
  }
}
