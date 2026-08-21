import 'package:flutter/material.dart';

class ModelCard extends StatelessWidget {
  final String name;
  final String username;
  final String city;
  final String rating;
  final String score;
  final String category;

  const ModelCard({
    super.key,
    required this.name,
    required this.username,
    required this.city,
    required this.rating,
    required this.score,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 42,
              color: Colors.grey,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.verified,
                      size: 17,
                      color: Colors.blue,
                    ),
                  ],
                ),

                Text(
                  username,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '$category • $city',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 17,
                      color: Colors.amber,
                    ),
                    Text(
                      ' $rating',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.auto_awesome,
                      size: 17,
                    ),
                    Text(
                      ' $score AI',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}