import 'package:flutter/material.dart';
import 'package:likeme/modelprofile.dart';
import 'package:likeme/services/api_service.dart';

class DiscoverModelsScreen extends StatefulWidget {
  const DiscoverModelsScreen({super.key});

  @override
  State<DiscoverModelsScreen> createState() => _DiscoverModelsScreenState();
}

class _DiscoverModelsScreenState extends State<DiscoverModelsScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  bool isLoading = true;

  final List<String> categories = [
    'All',
    'Fashion',
    'Commercial',
    'Runway',
    'Fitness',
    'Beauty',
  ];

  List<ModelData> models = [];

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  Future<void> _loadModels() async {
    try {
      final list = await ApiService.instance.fetchModels();
      if (!mounted) return;
      setState(() {
        models = list.map((json) => ModelData.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      // Fallback fallback models if offline
      setState(() {
        models = [
          ModelData(
            name: 'Ananya Sharma',
            username: '@ananya',
            category: 'Fashion',
            location: 'Mumbai',
            rating: 4.9,
            aiScore: 94,
            followers: '125K',
            experience: '4 years',
            imageUrl:
                'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600',
          ),
          ModelData(
            name: 'Priya Singh',
            username: '@priyasingh',
            category: 'Runway',
            location: 'Delhi',
            rating: 4.8,
            aiScore: 91,
            followers: '98K',
            experience: '3 years',
            imageUrl:
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600',
          ),
        ];
        isLoading = false;
      });
    }
  }

  List<ModelData> get filteredModels {
    return models.where((model) {
      final matchesCategory =
          selectedCategory == 'All' || model.category == selectedCategory;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          model.name.toLowerCase().contains(query) ||
          model.username.toLowerCase().contains(query) ||
          model.location.toLowerCase().contains(query) ||
          model.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void showFilters() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        double minRating = 4.0;
        double minAiScore = 80;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Models',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Minimum Rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Slider(
                    value: minRating,
                    min: 1,
                    max: 5,
                    divisions: 8,
                    label: minRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setSheetState(() {
                        minRating = value;
                      });
                    },
                  ),

                  Text(
                    '${minRating.toStringAsFixed(1)} ⭐ and above',
                    style: const TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Minimum AI Score',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Slider(
                    value: minAiScore,
                    min: 50,
                    max: 100,
                    divisions: 10,
                    label: minAiScore.round().toString(),
                    onChanged: (value) {
                      setSheetState(() {
                        minAiScore = value;
                      });
                    },
                  ),

                  Text(
                    '${minAiScore.round()}+ AI Score',
                    style: const TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2CBF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleModels = filteredModels;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Discover Models',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: showFilters,
            icon: const Icon(Icons.tune_rounded, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search models, categories, city...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 45,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = selectedCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF7B2CBF) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF7B2CBF)
                            : Colors.black12,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: visibleModels.isEmpty
                ? const Center(
                    child: Text(
                      'No models found',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    itemCount: visibleModels.length,
                    itemBuilder: (context, index) {
                      return ModelCard(model: visibleModels[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ModelCard extends StatelessWidget {
  final ModelData model;

  const ModelCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: Image.network(
                  model.imageUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return Container(
                      height: 280,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 15,
                        color: Color(0xFF7B2CBF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${model.aiScore}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B2CBF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      model.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  model.username,
                  style: const TextStyle(color: Colors.black45),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(model.location),
                    const SizedBox(width: 15),
                    Text(
                      model.category,
                      style: const TextStyle(
                        color: Color(0xFF7B2CBF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _InfoItem(title: 'Followers', value: model.followers),
                    _InfoItem(title: 'Experience', value: model.experience),
                    _InfoItem(title: 'AI Score', value: '${model.aiScore}/100'),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ModelProfileScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B2CBF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class ModelData {
  final String name;
  final String username;
  final String category;
  final String location;
  final double rating;
  final int aiScore;
  final String followers;
  final String experience;
  final String imageUrl;

  ModelData({
    required this.name,
    required this.username,
    required this.category,
    required this.location,
    required this.rating,
    required this.aiScore,
    required this.followers,
    required this.experience,
    required this.imageUrl,
  });

  factory ModelData.fromJson(Map<String, dynamic> json) => ModelData(
        name: json['name'] as String,
        username: json['username'] as String,
        category: json['category'] as String,
        location: json['location'] as String,
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
        aiScore: (json['aiScore'] as num?)?.toInt() ?? 90,
        followers: json['followers'] as String? ?? '100K',
        experience: json['experience'] as String? ?? '2 years',
        imageUrl: json['imageUrl'] as String,
      );
}
