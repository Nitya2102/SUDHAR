import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC84C4C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              "lib/assets/S.U.D.H.A.R (2).png",
              height: 300,
              width: 300,
            ),

            const SizedBox(height: 10),

            const Text(
              "SUDHAR",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Text(
              "Smart Urban Detection Handling\n& Action Reporting",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 25),

            const Text(
              "spot.report.improve",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Please choose to continue",
              style: TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 30),

            // -------- Citizen --------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/Citizen.png",
                  height: 70,
                  width: 70,
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/citizen'),
                  child: const Text("Citizen"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // -------- Govt Official --------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/Govt Official.png",
                  height: 70,
                  width: 70,
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/govt'),
                  child: const Text("Govt. Official"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
