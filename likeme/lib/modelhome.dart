import 'package:flutter/material.dart';
import 'package:likeme/jobscreen.dart';
import 'package:likeme/modelfeed.dart';
import 'package:likeme/modelprofile.dart';
import 'package:likeme/myapplication.dart';
import 'package:likeme/reels.dart';

class ModelHomeScreen extends StatefulWidget {
  const ModelHomeScreen({super.key});

  @override
  State<ModelHomeScreen> createState() => _ModelHomeScreenState();
}

class _ModelHomeScreenState extends State<ModelHomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    ModelFeed(),
    JobsScreen(),
    MyApplicationsScreen(),
    ReelsScreen(canUpload: true),
    ModelProfileScreen(isOwner: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_collection_outlined),
            selectedIcon: Icon(Icons.video_collection),
            label: 'Reels',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
