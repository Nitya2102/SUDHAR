import 'package:flutter/material.dart';

class GovtOfficialPage extends StatelessWidget {
  const GovtOfficialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0DB),
      body: const Center(
        child: Text(
          "Govt. Official Page",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC84C4C),
          ),
        ),
      ),
    );
  }
}
