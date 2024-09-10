class AttendanceModel {
  int? code;
  String? message;

  AttendanceModel({this.code, this.message});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
          code: json['meta']['code'] ?? json['code'],
          message: json['meta']['message'] ?? json['message']);
}
