import 'package:flutter/material.dart';
import 'package:likeme/profilestats.dart';

class ClientJobsScreen extends StatelessWidget {
  const ClientJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'My Jobs',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          JobStatusCard(
            title: 'Fashion Campaign',
            status: 'OPEN',
            applicants: '12 applicants',
          ),

          JobStatusCard(
            title: 'E-commerce Shoot',
            status: 'COMPLETED',
            applicants: '8 applicants',
          ),
        ],
      ),
    );
  }
}
