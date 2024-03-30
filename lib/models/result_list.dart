class ResultList<T> {
  String? errorMessage;
  int? returnCode;
  bool isSuccess;
  List<T>? content;
  int count;

  ResultList({this.errorMessage, this.returnCode, required this.isSuccess, this.content, required this.count});

  factory ResultList.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return ResultList(
      errorMessage: json['errorMessage'],
      returnCode: json['returnCode'],
      isSuccess: json['isSuccess'],
      content: json['content'] != null
          ? List<T>.from(json['content'].map((x) => fromJson(x)))
          : null,
      count: json['count'],
    );
  }
}