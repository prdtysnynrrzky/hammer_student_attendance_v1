import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showSuccessMessage(String message) {
  BotToast.showCustomText(
    align: Alignment.center,
    toastBuilder: (close) {
      return Container(
        color: Colors.black.withOpacity(0.45),
        alignment: Alignment.center,
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Success",
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: double.infinity,
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF525252),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
    duration: const Duration(seconds: 1),
    onClose: () {},
    onlyOne: false,
  );
}
