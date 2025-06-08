// lib/screens/user_type_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/viewer_screen.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:flutter_application_1/providers/app_state_provider.dart'; // Import your AppStateProvider
import 'package:flutter_application_1/screens/uploader_screen.dart'; // Make sure this is imported if AuthScreen navigates there

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the AppStateProvider (listen: false because we only call methods, not react to changes here)
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        title: const Text(
          'User Type Selection',
          style: TextStyle(
            color: Colors.black54, // Adjust color as needed
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0, // No shadow
        automaticallyImplyLeading:
            false, // Prevents a back button from appearing here if it's the initial screen
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Image (Choose Your Role Icon)
              Image.asset(
                'assets/Screenshot 2025-06-06 204420.png', // <-- VERIFY THIS PATH AND FILENAME!
                height: 100, // Adjust size as needed
                width: 100,
              ),
              const SizedBox(height: 30),
              // Choose Your Role Title
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Descriptive Text
              const Text(
                'Select your user type to access tailored functionalities within the Certificate Hub.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Certificate Uploader Card
              _buildRoleCard(
                context,
                icon: Icons.cloud_upload_outlined, // Using a Material icon
                title: 'Certificate Uploader',
                description:
                    'Empowering you to securely upload, manage, and distribute new certificates.',
                onTap: () async {
                  // Make this async!
                  print('DEBUG UserTypeSelection: Tapped Uploader card.');
                  await appState
                      .setUserType('uploader'); // <-- IMPORTANT: Set user type
                  print(
                      'DEBUG UserTypeSelection: User type set to "uploader". Navigating to AuthScreen.');

                  // Push AuthScreen. After auth, AuthScreen should navigate to UploaderScreen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploaderScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Certificate Viewer Card
              _buildRoleCard(
                context,
                icon: Icons.visibility_outlined, // Using a Material icon
                title: 'Certificate Viewer',
                description:
                    'Providing seamless access to view, search, and download existing certificates securely.',
                onTap: () async {
                  // Make this async!
                  print('DEBUG UserTypeSelection: Tapped Viewer card.');
                  await appState
                      .setUserType('viewer'); // <-- IMPORTANT: Set user type
                  print(
                      'DEBUG UserTypeSelection: User type set to "viewer". Navigating to AuthScreen.');

                  // Push AuthScreen. After auth, AuthScreen should navigate to ViewerScreen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ViewerScreen()),
                  );
                },
              ),
              const SizedBox(height: 50),

              // Copyright Text
              const Text(
                '© 2024 Certificate Hub. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the role cards (defined within this file for simplicity)
  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context)
                    .primaryColor, // Uses your app's primary color
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
