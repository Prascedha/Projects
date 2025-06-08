// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user_type_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/app_state_provider.dart'; // IMPORTANT: Use your project name here
import 'package:flutter_application_1/screens/uploader_screen.dart'; // IMPORTANT: Use your project name here
import 'package:flutter_application_1/screens/viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        if (appState.userType == 'uploader') {
          return const UploaderScreen();
        } else if (appState.userType == 'viewer') {
          return const ViewerScreen();
        } else {
          // Fallback: If userType becomes null somehow, go back to AuthScreen
          return const UserTypeSelectionScreen();
        }
      },
    );
  }
}
