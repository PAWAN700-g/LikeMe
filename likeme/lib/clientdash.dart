import 'package:flutter/material.dart';
import 'package:likeme/profilestats.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          const Text(
            'Hello, Rahul 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Find the perfect talent for your project.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7B2CBF),
                  Color(0xFFE056FD),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need a model?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create a job and discover suitable talent.',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 18),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7B2CBF),
                  ),
                  child: const Text('Create Job'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Popular categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              CategoryChip(title: 'Fashion'),
              CategoryChip(title: 'Commercial'),
              CategoryChip(title: 'E-commerce'),
              CategoryChip(title: 'Lifestyle'),
              CategoryChip(title: 'Fitness'),
              CategoryChip(title: 'Beauty'),
            ],
          ),
        ],
      ),
    );
  }
}