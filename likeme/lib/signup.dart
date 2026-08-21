import 'package:flutter/material.dart';
import 'package:likeme/appfield.dart';
import 'package:likeme/clienthome.dart';
import 'package:likeme/modelhome.dart';
import 'package:likeme/signin.dart';

class SignupScreen extends StatefulWidget {
  final String role;

  const SignupScreen({
    super.key,
    required this.role,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isModel = widget.role == 'MODEL';

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isModel ? 'Create your model profile' : 'Create your account',
                style: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                isModel
                    ? 'Start building your professional profile.'
                    : 'Find and hire amazing talent.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              AppTextField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: usernameController,
                label: 'Username',
                icon: Icons.alternate_email,
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => isModel
                            ? const ModelHomeScreen()
                            : const ClientHomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
                  child: const Text('Already have an account? Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}