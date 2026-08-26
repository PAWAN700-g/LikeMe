import 'package:flutter/material.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning 👋',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Find your next model',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search models, skills, location...',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Quick categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CategoryChip(
                    icon: Icons.checkroom,
                    title: 'Fashion',
                  ),
                  _CategoryChip(
                    icon: Icons.camera_alt_outlined,
                    title: 'Commercial',
                  ),
                  _CategoryChip(
                    icon: Icons.directions_walk,
                    title: 'Runway',
                  ),
                  _CategoryChip(
                    icon: Icons.fitness_center,
                    title: 'Fitness',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // AI recommendation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7B2CBF),
                    Color(0xFFE056FD),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Recommended',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Find models matching your project requirements.',
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Models',
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

            const SizedBox(height: 10),

            _ModelCard(
              name: 'Ananya Sharma',
              category: 'Fashion • Commercial',
              location: 'Mumbai',
              rating: '4.9',
              aiScore: '94',
              followers: '125K',
              imageUrl:
                  'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500',
            ),

            const SizedBox(height: 16),

            _ModelCard(
              name: 'Priya Singh',
              category: 'Runway • Fashion',
              location: 'Delhi',
              rating: '4.8',
              aiScore: '91',
              followers: '98K',
              imageUrl:
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
            ),

            const SizedBox(height: 16),

            _ModelCard(
              name: 'Riya Mehta',
              category: 'Commercial • Fitness',
              location: 'Bangalore',
              rating: '4.7',
              aiScore: '89',
              followers: '76K',
              imageUrl:
                  'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=500',
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryChip({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF7B2CBF),
          ),
          const SizedBox(width: 7),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String name;
  final String category;
  final String location;
  final String rating;
  final String aiScore;
  final String followers;
  final String imageUrl;

  const _ModelCard({
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.aiScore,
    required this.followers,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Container(
                  height: 230,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person,
                    size: 70,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.star,
                size: 18,
                color: Colors.amber,
              ),
              const SizedBox(width: 3),
              Text(
                rating,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            category,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.black45,
              ),
              const SizedBox(width: 3),
              Text(
                location,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Text(
                '$followers followers',
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'AI Score $aiScore',
                  style: const TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}