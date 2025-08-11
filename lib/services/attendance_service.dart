import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hammer_student_attendance/models/attendance_model.dart';
import 'package:hammer_student_attendance/models/user_model.dart';

class AttendanceService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Cari user berdasarkan RFID
  Future<UserModel?> getUserByRfid(String rfid) async {
    final response =
        await supabase.from('users').select().eq('rfid', rfid).maybeSingle();

    if (response == null) return null;

    return UserModel.fromJson(response);
  }

  // Cek apakah user sudah absen hari ini
  Future<bool> hasUserAttendedToday(int userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await supabase
        .from('attendances')
        .select()
        .eq('user_id', userId)
        .gte('attendance_time', startOfDay.toIso8601String())
        .lt('attendance_time', endOfDay.toIso8601String());

    final data = response as List<dynamic>;

    return data.isNotEmpty;
  }

  // Simpan absensi baru
  Future<AttendanceModel> postAttendance({
    required int userId,
    String status = 'present',
    String? note,
  }) async {
    final now = DateTime.now();

    final insertData = {
      'user_id': userId,
      'attendance_time': now.toIso8601String(),
      'status': status,
    };

    final response =
        await supabase.from('attendances').insert(insertData).select();

    if ((response as List).isEmpty) {
      throw Exception('Attendance insert failed');
    }

    return AttendanceModel.fromJson((response as List)[0]);
  }

  // Ambil data absensi hari ini lengkap dengan data user (join)
  Future<List<Map<String, dynamic>>> getTodayAttendances() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await supabase
        .from('attendances')
        .select('*, users!inner(rfid, name)') // inner join ke tabel users
        .gte('attendance_time', startOfDay.toIso8601String())
        .lt('attendance_time', endOfDay.toIso8601String())
        .order('attendance_time', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }
}
