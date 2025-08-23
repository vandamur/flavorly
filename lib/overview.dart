import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/recipe_detail_screen.dart';
import 'data/recipes.dart';

class OverviewScreen extends StatefulWidget {
  final bool isDebugMode;

  const OverviewScreen({super.key, this.isDebugMode = false});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  String selectedCategory = 'Alle';

  final Map<String, String> filterCategories = {
    'Alle': '🍽️',
    'Dips': '🫙',
    'Fleisch': '🥩',
    'Glutenfrei': '🌽',
    'Hauptgerichte': '🍲',
    'International': '🌍',
    'Laktosefrei': '🥛',
    'Sauce': '🧂',
    'Vegan': '🥗',
  };

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

    return allRecipes.where((recipe) {
      // Rezept-Key aus dem Namen ermitteln
      String recipeKey = _getRecipeKey(recipe.name);

      // Kategorien für dieses Rezept aus der Map holen (aus data/recipes.dart)
      List<String>? categories = recipeCategories[recipeKey];

      // Prüfen ob die ausgewählte Kategorie in den Rezept-Kategorien enthalten ist
      return categories?.contains(selectedCategory) ?? false;
    }).toList();
  }

  // Hilfsfunktion zum Mapping von UI-Namen zu Rezept-Keys
  String _getRecipeKey(String recipeName) {
    const Map<String, String> recipeKeyMapping = {
      'Baba Ganoush': 'baba_ganoush',
      'Barbacoa': 'barbacoa',
      'Brasilianisches Picadillo': 'picadillo',
      'Cowboy Caviar': 'cowboy_caviar',
      'Feuertopf': 'feuertopf',
      'Ful Medames': 'ful_medames',
      'Gefüllte Auberginen': 'auberginen',
      'Gelbe Zucchini Pfanne': 'zucchini_pfanne',
      'Italienische Tomatensoße': 'tomatensosse',
      'Köfte': 'koefte',
      'Kubanische Empanadas': 'empanadas',
      'Muhammara': 'muhammara',
      'Paprika Feta Dip': 'paprika_feta_dip',
      'Pilz Döner': 'doener',
      'Puten Gyros': 'puten_gyros',
      'Ropa Vieja': 'ropa_vieja',
      'Salsa Roja': 'salsa_roja',
      'Tex Mex Auflauf': 'tex_mex',
      'Tintenfisch': 'tintenfisch',
      'Würziger Feta Aufstrich': 'feta_aufstrich',
    };
    return recipeKeyMapping[recipeName] ??
        recipeName.toLowerCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'flavorly',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.white),
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
                itemCount: filterCategories.length,
                itemBuilder: (context, index) {
                  final category = filterCategories.keys.elementAt(index);
                  final emoji = filterCategories[category]!;
                  final isSelected = category == selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            category,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.black87
                                      : Theme.of(context).colorScheme.onSurface,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
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
                  return RecipeCard(
                    recipe: recipe,
                    recipeKey: _getRecipeKey(recipe.name),
                    isDebugMode: widget.isDebugMode,
                  );
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
  final String recipeKey;
  final bool isDebugMode;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.recipeKey,
    required this.isDebugMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Navigation zur Rezeptdetailseite
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => RecipeDetailScreen(
                    recipeName: recipe.name,
                    imagePath: recipe.imagePath,
                    category: recipe.category,
                    recipeKey: recipeKey,
                    isDebugMode: isDebugMode,
                  ),
            ),
          );
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
