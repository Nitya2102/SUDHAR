import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_page.dart';
import 'notifications_page.dart';
import 'report_issue_page.dart';

class CitizenHomePage extends StatelessWidget {
  const CitizenHomePage({super.key});

  User? get user => FirebaseAuth.instance.currentUser;

  bool hasProfileName() {
    return user != null &&
        user!.displayName != null &&
        user!.displayName!.trim().isNotEmpty;
  }

  String get displayName {
    return hasProfileName() ? user!.displayName! : "Citizen";
  }

  /// 🔽 Bottom icon widget with border (NO size change)
  Widget bottomIcon({
    required String path,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: Container(
            width: 110, // circle size (smaller than tap area)
            height: 110,

            alignment: Alignment.center,
            child: Image.asset(
              path,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC84C4C),
      body: SafeArea(
        child: Column(
          children: [

            /// 🔝 PROFILE SECTION
            const SizedBox(height: 48),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC84C4C),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      'lib/assets/9.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 📝 TAGLINE TEXT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "See something wrong in your community?\nYour report helps make it better.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🚨 REPORT ISSUE BUTTON
            ElevatedButton(
              onPressed: () {
                if (!hasProfileName()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please complete your profile before reporting",
                      ),
                    ),
                  );
                  return;
                }
                Navigator.pushNamed(context, '/citizenDashboard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8F0DB),
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 44,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Report an issue",
                style: TextStyle(
                  color: Color(0xFFC84C4C),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Spacer(),

            /// 🔽 BOTTOM NAV
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  /// 📄 MY REPORTED ISSUES
                  bottomIcon(
                    path: 'lib/assets/10.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportedIssuesPage(),
                        ),
                      );
                    },
                  ),

                  /// 🔔 NOTIFICATIONS
                  bottomIcon(
                    path: 'lib/assets/11.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
