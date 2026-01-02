import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CitizenPage extends StatefulWidget {
  const CitizenPage({super.key});

  @override
  State<CitizenPage> createState() => _CitizenPageState();
}

class _CitizenPageState extends State<CitizenPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;
  bool locationEnabled = false;
  bool loading = false;

  String verificationId = "";

  // ---------------- SEND OTP ----------------
  void sendOtp() async {
    String phone = phoneController.text.trim();

    // Check length
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number")),
      );
      return;
    }

    // Auto-add country code if missing
    if (!phone.startsWith("+")) {
      phone = "+91$phone"; // Change '+91' to your default country code
    }

    setState(() => loading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        redirect();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          otpSent = true;
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP sent!")),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  // ---------------- VERIFY OTP ----------------
  void verifyOtp() async {
    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 6-digit OTP")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      redirect();
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  void redirect() {
    Navigator.pushReplacementNamed(context, '/citizenHome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0DB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Citizen",
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFFC84C4C),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Enter phone number",
              style: TextStyle(color: Color(0xFFC84C4C)),
            ),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Enter number with or without +91",
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: loading ? null : sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC84C4C),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Send OTP",style: TextStyle(color:Color(0xFFF8F0DB)),),
            ),

            if (otpSent) ...[
              const SizedBox(height: 30),

              const Text(
                "Enter OTP",
                style: TextStyle(color: Color(0xFFC84C4C)),
              ),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC84C4C),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify"),
              ),
            ],

            const SizedBox(height: 30),

            const Text(
              "Enable device location",
              style: TextStyle(color: Color(0xFFC84C4C)),
            ),

            Switch(
              value: locationEnabled,
              activeColor: const Color(0xFFC84C4C),
              onChanged: (value) {
                setState(() => locationEnabled = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
