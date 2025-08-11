class AttendanceModel {
  final int? id;
  final int? userId;
  final DateTime? attendanceTime;
  final String? status;
  final DateTime? createdAt;

  AttendanceModel({
    this.id,
    this.userId,
    this.attendanceTime,
    this.status,
    this.createdAt,
  });

  // Factory constructor untuk parse dari JSON Map (dari Supabase response)
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      attendanceTime: json['attendance_time'] != null
          ? DateTime.parse(json['attendance_time'])
          : null,
      status: json['status'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // Convert objek ke JSON Map (untuk insert/update)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'attendance_time': attendanceTime?.toIso8601String(),
      'status': status,
    };
  }
}
