import 'package:flutter/material.dart';
import 'package:likeme/modelcard.dart';

class DiscoverModelsScreen extends StatelessWidget {
  const DiscoverModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Discover Models',
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: InputDecoration(
              hintText: 'Search models',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const ModelCard(
            name: 'Ananya Sharma',
            username: '@ananyasharma',
            city: 'Mumbai',
            rating: '4.9',
            score: '92',
            category: 'Fashion Model',
          ),

          const ModelCard(
            name: 'Riya Kapoor',
            username: '@riyakapoor',
            city: 'Delhi',
            rating: '4.8',
            score: '89',
            category: 'Commercial Model',
          ),

          const ModelCard(
            name: 'Meera Singh',
            username: '@meerasingh',
            city: 'Bangalore',
            rating: '4.7',
            score: '86',
            category: 'Lifestyle Model',
          ),
        ],
      ),
    );
  }
}


