import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flavourly',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

// Main Screen für 11" Tablet
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flavourly')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Titel
              Text(
                'Flavourly',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Willkommenstext
              Text(
                'Willkommen',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onBackground.withOpacity(0.7),
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
