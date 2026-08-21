import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;

  const CategoryChip({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(title),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
    );
  }
}