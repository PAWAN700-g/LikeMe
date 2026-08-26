import 'package:flutter/material.dart';
import 'package:likeme/clientdash.dart';
import 'package:likeme/clientjob.dart';
import 'package:likeme/discovermodel.dart';
import 'package:likeme/reels.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int selectedIndex = 0;

  final screens = const [
    ClientDashboard(),
    DiscoverModelsScreen(),
    ReelsScreen(),
    ClientJobsScreen(),
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
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Models',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_collection_outlined),
            selectedIcon: Icon(Icons.video_collection),
            label: 'Reels',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'My Jobs',
          ),
        ],
      ),
    );
  }
}
