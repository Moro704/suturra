

import 'package:flutter/material.dart';


class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const DashboardCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Center(
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            value,
            style: const TextStyle(fontSize: 20, color: Colors.deepPurple),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
