
import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  final List<Map<String, String>> jobs = const [
    {
      'title': 'Fashion Campaign',
      'company': 'Urban Style',
      'location': 'Mumbai',
      'budget': '₹15,000',
    },
    {
      'title': 'E-commerce Shoot',
      'company': 'StyleHub',
      'location': 'Delhi',
      'budget': '₹8,000',
    },
    {
      'title': 'Brand Promotion',
      'company': 'Nova Brands',
      'location': 'Bangalore',
      'budget': '₹12,000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Find Jobs',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Opportunities matching your profile',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 25),

          ...jobs.map(
            (job) => Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title']!,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    job['company']!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(job['location']!),
                      const Spacer(),
                      Text(
                        job['budget']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('View Job'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}