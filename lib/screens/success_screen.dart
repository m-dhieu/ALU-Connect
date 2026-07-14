import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// show application success confirmation & reset nav to explore screen
class SuccessScreen extends StatelessWidget {
  final String companyName;

  const SuccessScreen({
    super.key,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    const Color aluDeepGreen = Color(0xFF0C4E33);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // show success celebration graphic
              const Center(
                child: Text(
                  '🎉',
                  style: TextStyle(
                    fontSize: 64,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // show application status confirmation
              Text(
                'Application sent!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900, 
                ),
              ),
              const SizedBox(height: 12),

              // show company feedback information
              Text(
                '$companyName will review your application and get back to you.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // navigate back to dashboard
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: aluDeepGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back to Explore',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
