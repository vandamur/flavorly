import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  String selectedCategory = 'Alle';

  final List<String> categories = [
    'Alle',
    'Vorspeisen',
    'Hauptgerichte',
    'Dips',
    'Vegetarisch',
    'Fleisch',
    'Laktosefrei',
    'International',
  ];

  final List<Recipe> allRecipes = [
    Recipe('Baba Ganoush', 'BabaGanoush.jpeg', 'Vorspeisen'),
    Recipe('Barbacoa', 'Barbacoa.jpeg', 'Fleisch'),
    Recipe(
      'Brasilianisches Picadillo',
      'BrasilianischesPicadillo.webp',
      'International',
    ),
    Recipe('Cowboy Caviar', 'CowboyCaviar.jpeg', 'Vorspeisen'),
    Recipe('Feuertopf', 'Feuertopf.jpeg', 'Hauptgerichte'),
    Recipe('Ful Medames', 'FulMedames.jpeg', 'Vegetarisch'),
    Recipe('Gefüllte Auberginen', 'GefuellteAuberginen.jpeg', 'Vegetarisch'),
    Recipe('Gelbe Zucchini Pfanne', 'GelbeZucchiniPfanne.jpeg', 'Vegetarisch'),
    Recipe(
      'Italienische Tomatensoße',
      'ItalienischeTomatensoße.jpeg',
      'International',
    ),
    Recipe('Köfte', 'Koefte.jpeg', 'Fleisch'),
    Recipe('Kubanische Empanadas', 'KubanischeEmpanadas.jpeg', 'International'),
    Recipe('Muhammara', 'Muhammara.jpeg', 'Vorspeisen'),
    Recipe('Paprika Feta Dip', 'PaprikaFetaDip.jpeg', 'Vorspeisen'),
    Recipe('Pilz Döner', 'PilzDoener.jpeg', 'Vegetarisch'),
    Recipe('Puten Gyros', 'PutenGyros.jpeg', 'Fleisch'),
    Recipe('Ropa Vieja', 'RopaVieja.jpeg', 'International'),
    Recipe('Salsa Roja', 'SalsaRoja.jpeg', 'Vorspeisen'),
    Recipe('Tex Mex Auflauf', 'TexMexAuflauf.jpeg', 'Hauptgerichte'),
    Recipe('Tintenfisch', 'Tintenfisch.jpeg', 'Fleisch'),
    Recipe(
      'Würziger Feta Aufstrich',
      'WuerzigerFetaAufstrich.jpeg',
      'Vorspeisen',
    ),
  ];

  List<Recipe> get filteredRecipes {
    if (selectedCategory == 'Alle') {
      return allRecipes;
    }
    return allRecipes
        .where((recipe) => recipe.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header mit Suchfeld
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // App Logo/Titel
                  Row(
                    children: [
                      Image.asset('assets/flavorly.png', height: 40, width: 40),
                      const SizedBox(width: 12),
                      Text(
                        'Flavorly',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Suchfeld
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Rezept suchen...',
                      prefixIcon: const Icon(Icons.search, size: 28),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Kategorien
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.black87
                                  : Theme.of(context).colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      selectedColor: AppColors.accent,
                      elevation: isSelected ? 4 : 1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Rezepte Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return RecipeCard(recipe: recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final String name;
  final String imagePath;
  final String category;

  Recipe(this.name, this.imagePath, this.category);
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // TODO: Navigation zu Rezeptdetails
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  'assets/${recipe.imagePath}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Icon(
                        Icons.restaurant,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.support,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
