import 'package:flutter/material.dart';
import 'package:likeme/rolecard.dart';
import 'package:likeme/signin.dart';
import 'package:likeme/signup.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join LikeMe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Text(
              'How will you use LikeMe?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Choose your account type. You can change some details later.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 40),

            RoleCard(
              icon: Icons.camera_alt_rounded,
              title: 'I am a Model',
              subtitle:
                  'Build your portfolio, find jobs and connect with clients.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(
                      role: 'MODEL',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            RoleCard(
              icon: Icons.business_center_rounded,
              title: 'I need Models',
              subtitle:
                  'Find talented models and hire them for your projects.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(
                      role: 'CLIENT',
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Already have an account? Login',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
