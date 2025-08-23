import 'package:flutter/material.dart';
import '../overview.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF701539),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '👋 Willkommen beim Gewürzautomaten!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 40),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'So funktioniert\'s:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _buildStepText(
                            '🥘 Rezepte entdecken',
                            'lass dich inspirieren',
                          ),

                          const SizedBox(height: 12),

                          _buildStepText(
                            '🥄 Portion wählen',
                            'so viel, wie du brauchst',
                          ),

                          const SizedBox(height: 12),

                          _buildStepText(
                            '🌿 Mischung frisch mahlen',
                            'direkt hier am Automaten',
                          ),

                          const SizedBox(height: 12),

                          _buildStepText(
                            '📱 QR-Code scannen',
                            'Rezept & Einkaufsliste auf dem Handy',
                          ),

                          const SizedBox(height: 60),

                          const Text(
                            'So hast du Idee, Zutaten und Gewürze perfekt abgestimmt – ohne Umwege.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),

                          const SizedBox(height: 40),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 450,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const OverviewScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFB238),
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 20),
                                    const Text(
                                      'Jetzt ausprobieren',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepText(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: '$title – ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: description,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
