// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure this is imported

import 'package:flutter_application_1/providers/app_state_provider.dart';
import 'package:flutter_application_1/screens/launch_screen.dart';
import 'package:flutter_application_1/screens/user_type_selection_screen.dart';
import 'package:flutter_application_1/screens/viewer_screen.dart';
import 'package:flutter_application_1/screens/uploader_screen.dart';

void main() {
  // THIS IS THE CRITICAL LINE: Ensures Flutter's core services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  print(
      'DEBUG main: WidgetsFlutterBinding initialized.'); // Debug print to confirm

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        print('DEBUG main: Creating AppStateProvider instance.'); // Debug print
        return AppStateProvider();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userType = prefs.getString('userType');
    print(
        'DEBUG Main: _getInitialRoute called. UserType from SharedPreferences: "$userType"');

    if (userType == null || userType.isEmpty) {
      print(
          'DEBUG Main: UserType is null/empty, redirecting to /userTypeSelection');
      return '/userTypeSelection';
    } else if (userType == 'viewer') {
      print('DEBUG Main: UserType is viewer, redirecting to /viewer');
      return '/viewer';
    } else if (userType == 'uploader') {
      print('DEBUG Main: UserType is uploader, redirecting to /uploader');
      return '/uploader';
    }
    print('DEBUG Main: Fallback - redirecting to /userTypeSelection');
    return '/userTypeSelection'; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certificate Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LaunchScreen(),
      routes: {
        '/launch': (context) => const LaunchScreen(),
        '/userTypeSelection': (context) => const UserTypeSelectionScreen(),
        '/viewer': (context) => const ViewerScreen(),
        '/uploader': (context) => const UploaderScreen(),
      },
      onGenerateRoute: (settings) {
        print('DEBUG Main: onGenerateRoute triggered for: ${settings.name}');
        if (settings.name == '/initialRedirect') {
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<String>(
              future: _getInitialRoute(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print(
                          'DEBUG Main: Navigating to ${snapshot.data!} via pushReplacementNamed');
                      Navigator.of(context)
                          .pushReplacementNamed(snapshot.data!);
                    });
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    print(
                        'DEBUG Main: FutureBuilder has no data, defaulting to /userTypeSelection');
                    return const UserTypeSelectionScreen();
                  }
                }
                print(
                    'DEBUG Main: FutureBuilder connectionState: ${snapshot.connectionState}');
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          );
        }
        return null;
      },
    );
  }
}
