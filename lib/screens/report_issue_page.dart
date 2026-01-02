import 'package:flutter/material.dart';

class ReportedIssuesPage extends StatelessWidget {
  const ReportedIssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reported Issues",style: TextStyle(color:Color(0xFFF8F0DB))),
        backgroundColor: const Color(0xFFC84C4C),
      ),
      body: ListView.builder(
        itemCount: 3, // Replace with Firestore count later
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.report),
              title: Text("Issue #${index + 1}"),
              subtitle: const Text("Status: Pending"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Open issue details
              },
            ),
          );
        },
      ),
    );
  }
}
