import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hammer_student_attendance/services/attendance_service.dart';
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
  @override
  Widget build(BuildContext context) {
    TextEditingController rfidController = TextEditingController();

    // Getting device width and height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Adjust image width dynamically based on screen width
                      Image.asset(
                        'assets/illustrations/attendance.png',
                        fit: BoxFit.contain,
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
                            const SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tab Kartu anda untuk absen hari ini",
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
                              onEditingComplete: () {
                                final rfid = rfidController.text;

                                if (rfid.length < 3) {
                                  showErrorMessage("RFID minimal 3 karakter");
                                  return;
                                }

                                showLoading();
                                AttendanceService()
                                    .postAttendance(rfid)
                                    .then((value) {
                                  stopLoading();
                                  if (value.code == 200) {
                                    showSuccessMessage(
                                        value.message.toString());
                                    rfidController.clear();
                                  } else if (value.code == 400) {
                                    showSuccessMessage(
                                        value.message.toString());
                                    rfidController.clear();
                                  } else {
                                    showErrorMessage(value.message.toString());
                                    rfidController.clear();
                                  }
                                });
                              },
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
                        "${DateTime.now().year} SMKPGRIWLINGI All Rights Reversed",
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
