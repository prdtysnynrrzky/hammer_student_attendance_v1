import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hammer_student_attendance/models/attendance_model.dart';
import 'package:hammer_student_attendance/widgets/message/errorMessage.dart';
import 'package:hammer_student_attendance/widgets/message/successMessage.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  Future<AttendanceModel> postAttendance(String rfid) async {
    try {
      Uri uri = Uri.parse("${dotenv.get('BASEURL')}attendance-rfid/$rfid");
      final response = await http.post(uri);

      final responseBody = jsonDecode(response.body);
      final attendanceModel = AttendanceModel.fromJson(responseBody);

      if (response.statusCode == 400) {
        showSuccessMessage(attendanceModel.message.toString());
        return AttendanceModel(code: 400, message: attendanceModel.message);
      }

      return attendanceModel;
    } on Exception catch (_) {
      showErrorMessage("Kesalahan jaringan");
      return AttendanceModel(code: 500, message: "Kesalahan jaringan");
    }
  }
}
