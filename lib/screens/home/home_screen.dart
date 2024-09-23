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
  TextEditingController rfidController = TextEditingController();
  bool isLoading = false;

  void _handleSubmit() async {
    final rfid = rfidController.text.trim();

    if (rfid.length < 3) {
      showErrorMessage("RFID minimal 3 karakter!");
      TextToSpeechService().queue('RFID minimal 3 karakter!');
      return;
    }

    setState(() {
      isLoading = true;
      showLoading();
    });

    final result = await AttendanceService().postAttendance(rfid);

    setState(() {
      isLoading = false;
      stopLoading();
    });

    if (result.code == 200) {
      showSuccessMessage(result.message.toString());
    } else {
      showErrorMessage(result.message.toString());
    }

    TextToSpeechService().queue(result.message.toString());
    rfidController.clear();
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
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset(
                      'assets/images/home.png',
                    ),
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
                            const SizedBox(
                              height: 12,
                            ),
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
                            const SizedBox(
                              height: 12,
                            ),
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
                      const SizedBox(
                        height: 80,
                      ),
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
