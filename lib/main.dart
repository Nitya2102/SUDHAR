import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_page.dart';
import 'screens/citizen_page.dart';
import 'screens/govt_official_page.dart';
import 'screens/citizen_home_page.dart';
import 'screens/citizen_dashboard.dart';
import 'screens/report_issue_page.dart';
import 'screens/report_issue_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/notifications_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SudharApp());
}

class SudharApp extends StatelessWidget {
  const SudharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SUDHAR',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFFC84C4C),
      ),

      /// 👇 ENTRY POINT
      initialRoute: '/',

      routes: {
        '/': (context) => const HomePage(),

        /// AUTH
        '/citizen': (context) => const CitizenPage(),
        '/govt': (context) => const GovtOfficialPage(),

        /// CITIZEN FLOW
        '/citizenHome': (context) => const CitizenHomePage(),
        '/citizenDashboard': (context) => const CitizenDashboard(),

        /// REPORTS
        '/reportIssue': (context) => const ReportedIssuesPage(),
        '/myReports': (context) => const ReportedIssuesPage(),

        /// PROFILE & SETTINGS
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}
