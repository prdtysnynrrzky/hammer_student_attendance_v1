import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hammer_student_attendance/services/attendance_service.dart';
import 'package:hammer_student_attendance/services/text_to_speech_service.dart';
import 'package:hammer_student_attendance/widgets/loading.dart';
import 'package:hammer_student_attendance/widgets/message/errorMessage.dart';
import 'package:hammer_student_attendance/widgets/message/successMessage.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController rfidController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  List<Map<String, dynamic>> todayAttendances = [];
  String searchQuery = '';

  List<Map<String, dynamic>> get filteredAttendances {
    if (searchQuery.isEmpty) return todayAttendances;
    return todayAttendances.where((item) {
      final user = item['users'];
      final name = user?['name']?.toString().toLowerCase() ?? '';
      final rfid = user?['rfid']?.toString().toLowerCase() ?? '';
      final q = searchQuery.toLowerCase();
      return name.contains(q) || rfid.contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadTodayAttendances();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    rfidController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayAttendances() async {
    try {
      final attendanceService = AttendanceService();
      final data = await attendanceService.getTodayAttendances();
      setState(() {
        todayAttendances = data;
      });
    } catch (e) {
      print('Gagal load data absensi: $e');
      showErrorMessage("Gagal load data absensi: $e");
      TextToSpeechService().queue('Gagal load data absensi: $e');
    }
  }

  void _handleSubmit() async {
    final rfid = rfidController.text.trim();

    if (rfid.length < 3) {
      showErrorMessage("RFID minimal 7 karakter!");
      TextToSpeechService().queue('RFID minimal 7 karakter!');
      return;
    }

    setState(() {
      isLoading = true;
      showLoading();
    });

    try {
      final attendanceService = AttendanceService();

      final user = await attendanceService.getUserByRfid(rfid);

      if (user == null) {
        showErrorMessage("RFID tidak terdaftar");
        TextToSpeechService().queue('RFID tidak terdaftar');
        return;
      }

      final alreadyAttended =
          await attendanceService.hasUserAttendedToday(user.id!);

      if (alreadyAttended) {
        showErrorMessage("Anda sudah absen hari ini");
        TextToSpeechService().queue('Anda sudah absen hari ini');
        return;
      }

      final attendance =
          await attendanceService.postAttendance(userId: user.id!);

      showSuccessMessage(
          "Absensi berhasil pada pukul ${attendance.attendanceTime?.toLocal().toString().substring(11, 16)}");
      TextToSpeechService().queue('Absensi berhasil');

      await _loadTodayAttendances();
    } catch (e) {
      showErrorMessage("Terjadi kesalahan: $e");
      TextToSpeechService().queue('Terjadi kesalahan');
    } finally {
      setState(() {
        isLoading = false;
        stopLoading();
        rfidController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: todayAttendances.isEmpty
                    ? Center(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.asset('assets/images/home.png'),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.grey[100],
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Daftar Absensi Hari Ini",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _loadTodayAttendances,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Cari nama atau RFID peserta didik',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // List Absensi
                            Expanded(
                              child: filteredAttendances.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Tidak ada peserta didik yang cocok dengan pencarian.',
                                        style: GoogleFonts.poppins(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: filteredAttendances.length,
                                      itemBuilder: (context, index) {
                                        final item = filteredAttendances[index];
                                        final user = item['users'];
                                        final name =
                                            user?['name'] ?? 'Tidak Diketahui';
                                        final rfid = user?['rfid'] ?? '-';
                                        final statusRaw = (item['status'] ?? '')
                                            .toString()
                                            .toLowerCase();
                                        final statusText =
                                            statusRaw == 'present'
                                                ? 'Hadir'
                                                : statusRaw == 'late'
                                                    ? 'Terlambat'
                                                    : 'Tidak Diketahui';
                                        final timeStr =
                                            item['attendance_time'] != null
                                                ? DateTime.parse(
                                                        item['attendance_time'])
                                                    .toString()
                                                    .substring(11, 16)
                                                : '-';
                                        return ListTile(
                                          leading: Icon(
                                            statusRaw == 'present'
                                                ? Icons.check_circle_outline
                                                : Icons.access_time,
                                            color: statusRaw == 'present'
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                          title: Text(
                                            name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('RFID: $rfid'),
                                              Text('Status: $statusText'),
                                            ],
                                          ),
                                          trailing: Text('$timeStr WIB'),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: Image.asset(
                                'assets/logo/logo-hammerschool.png',
                                height: 60,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Selamat Datang",
                                style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tab Kartu anda untuk melakukan absensi",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              autofocus: true,
                              controller: rfidController,
                              onEditingComplete: _handleSubmit,
                              cursorColor: const Color(0xFFEEEEEE),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFEEEEEE),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        "${DateTime.now().year} SMKPGRIWLINGI All Rights Reserved",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF525252)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
