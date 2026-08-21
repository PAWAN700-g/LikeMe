import 'package:flutter/material.dart';
import 'package:likeme/modelcard.dart';

class ModelFeed extends StatelessWidget {
  const ModelFeed({super.key});

  final List<Map<String, dynamic>> models = const [
    {
      'name': 'Ananya Sharma',
      'username': '@ananyasharma',
      'city': 'Mumbai',
      'rating': '4.9',
      'score': '92',
      'category': 'Fashion Model',
    },
    {
      'name': 'Riya Kapoor',
      'username': '@riyakapoor',
      'city': 'Delhi',
      'rating': '4.8',
      'score': '89',
      'category': 'Commercial Model',
    },
    {
      'name': 'Meera Singh',
      'username': '@meerasingh',
      'city': 'Bangalore',
      'rating': '4.7',
      'score': '86',
      'category': 'Lifestyle Model',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text(
              'LikeMe',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Text(
                'Discover opportunities',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search jobs, brands or people',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended models',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final model = models[index];

                return ModelCard(
                  name: model['name'],
                  username: model['username'],
                  city: model['city'],
                  rating: model['rating'],
                  score: model['score'],
                  category: model['category'],
                );
              },
              childCount: models.length,
            ),
          ),
        ],
      ),
    );
  }
}
