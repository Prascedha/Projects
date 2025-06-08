import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for SystemChrome (status bar styling)
// Import your UserTypeSelectionScreen. Ensure the path is correct for your project name.
import 'package:flutter_application_1/screens/user_type_selection_screen.dart';

class LaunchScreen extends StatelessWidget {
  // IMPORTANT: This constructor MUST be 'const' for the screen to be used with 'const' in main.dart.
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Optional: Sets the style of the system status bar (e.g., time, battery icons).
    // This makes the status bar icons dark, fitting a light background.
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Transparent status bar background
        statusBarIconBrightness: Brightness.dark, // Dark icons on status bar
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white, // White background for the screen
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top illustration (the interconnected circles)
              // Ensure 'assets/top_illustration.png' exists in your assets folder
              // and is declared in pubspec.yaml.
              Image.asset(
                'assets/Screenshot 2025-06-06 235548.png', // <-- Verify this asset path and filename
                height: 80, // Adjust size as needed
              ),
              const SizedBox(height: 50),

              // "Welcome to" text
              const Text(
                'Welcome to Certificate Hub',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Descriptive text
              const Text(
                'Discover, access, and manage your certificates effortlessly.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Central certificate icon/illustration
              // Ensure 'assets/certificate_icon.png' exists in your assets folder
              // and is declared in pubspec.yaml.
              Image.asset(
                'assets/Screenshot 2025-06-06 235650.png', // <-- Verify this asset path and filename
                height: 200, // Adjust size as needed
                width: 200,
              ),
              const SizedBox(height: 40),

              // Second descriptive text
              const Text(
                'Your digital certificate management solution.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Tap to Enter Button
              SizedBox(
                width: double
                    .infinity, // Makes the button take full available width
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the UserTypeSelectionScreen and replace the current route.
                    // 'pushReplacement' means the user cannot go back to the LaunchScreen via the back button.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UserTypeSelectionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFF6A5ACD), // A shade of purple/blue for the button
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18), // Button height
                    elevation: 5, // Shadow effect
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Tap to Enter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10), // Space between text and icon
                      Icon(Icons.arrow_forward,
                          color: Colors.white, size: 20), // Arrow icon
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
