import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/recipes.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeName;
  final String imagePath;
  final String category;
  final String recipeKey; // Key für recipes.dart Mapping

  const RecipeDetailScreen({
    super.key,
    required this.recipeName,
    required this.imagePath,
    required this.category,
    required this.recipeKey,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int portions = 2; // Standard-Portionsgröße

  // Mapping von UI-Namen zu Rezept-Keys
  static const Map<String, String> recipeKeyMapping = {
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

  // Beschreibungen für Rezepte
  static const Map<String, String> recipeDescriptions = {
    'Baba Ganoush':
        'Ein cremiger orientalischer Auberginendip mit Tahini, perfekt zu Fladenbrot oder als Vorspeise.',
    'Barbacoa':
        'Zartes, würzig mariniertes Rindfleisch nach mexikanischer Art, langsam geschmort bis zur Perfektion.',
    'Brasilianisches Picadillo':
        'Ein herzhaftes brasilianisches Gericht mit Hackfleisch, Gemüse und exotischen Gewürzen.',
    'Cowboy Caviar':
        'Eine frische, proteinreiche Salsa mit schwarzen Bohnen, Mais und buntem Gemüse.',
    'Feuertopf':
        'Ein scharfer, würziger Eintopf der Sinne erweckt und perfekt für kalte Tage ist.',
    'Ful Medames':
        'Traditionelle ägyptische Saubohnen, gewürzt mit Kreuzkümmel und serviert mit Olivenöl.',
    'Gefüllte Auberginen':
        'Zarte Auberginen gefüllt mit einer würzigen Mischung aus Gemüse und orientalischen Gewürzen.',
    'Gelbe Zucchini Pfanne':
        'Eine sommerlich-leichte Zucchinipfanne mit Feta, Tomaten und frischen Kräutern - schnell gemacht und voller mediterranem Geschmack.',
    'Italienische Tomatensoße':
        'Eine klassische, aromatische Tomatensoße mit Oregano - die Basis für unzählige italienische Gerichte.',
    'Köfte':
        'Würzige türkische Fleischbällchen mit einer perfekten Mischung aus orientalischen Gewürzen.',
    'Kubanische Empanadas':
        'Knusprige Teigtaschen gefüllt mit würzigem Fleisch nach kubanischer Tradition.',
    'Muhammara':
        'Ein würzig-süßer syrischer Dip aus Walnüssen und Paprika mit einem Hauch von Chili.',
    'Paprika Feta Dip':
        'Ein cremiger griechischer Dip mit gerösteten Paprika und würzigem Feta-Käse.',
    'Pilz Döner':
        'Eine vegetarische Alternative zum klassischen Döner mit würzig marinierten Pilzen.',
    'Puten Gyros':
        'Zartes Putenfleisch nach griechischer Art mit einer aromatischen Gewürzmischung.',
    'Ropa Vieja':
        'Das Nationalgericht Kubas - zartes Rindfleisch in einer würzigen Tomaten-Paprika-Sauce.',
    'Salsa Roja':
        'Eine feurige mexikanische Salsa mit Tomaten, Zwiebeln und einer perfekten Chili-Schärfe.',
    'Tex Mex Auflauf':
        'Ein herzhafter Auflauf mit mexikanischen Aromen - perfekt für die ganze Familie.',
    'Tintenfisch':
        'Mediterraner Tintenfisch mit Oregano und Pfeffer - ein Geschmack des Mittelmeers.',
    'Würziger Feta Aufstrich':
        'Ein cremiger griechischer Aufstrich mit Feta und Oregano - perfekt zu frischem Brot.',
  };

  // Zubereitungszeiten
  static const Map<String, int> cookingTimes = {
    'Baba Ganoush': 30,
    'Barbacoa': 180,
    'Brasilianisches Picadillo': 45,
    'Cowboy Caviar': 15,
    'Feuertopf': 60,
    'Ful Medames': 90,
    'Gefüllte Auberginen': 75,
    'Gelbe Zucchini Pfanne': 25,
    'Italienische Tomatensoße': 45,
    'Köfte': 30,
    'Kubanische Empanadas': 60,
    'Muhammara': 20,
    'Paprika Feta Dip': 25,
    'Pilz Döner': 35,
    'Puten Gyros': 40,
    'Ropa Vieja': 120,
    'Salsa Roja': 20,
    'Tex Mex Auflauf': 50,
    'Tintenfisch': 30,
    'Würziger Feta Aufstrich': 15,
  };

  String get recipeKey {
    return recipeKeyMapping[widget.recipeName] ??
        widget.recipeName.toLowerCase().replaceAll(' ', '_');
  }

  Map<String, double>? get recipeData {
    return RecipeCatalog.getRecipe(recipeKey);
  }

  List<String> get tags {
    List<String> tags = [widget.category];

    // Zusätzliche Tags basierend auf Gewürzen
    final recipe = recipeData;
    if (recipe != null) {
      bool hasChili = (recipe['chili'] ?? 0.0) > 0;
      bool isVegetarian =
          widget.category == 'Vegetarisch' || widget.category == 'Vorspeisen';

      if (hasChili) tags.add('SCHARF');
      if (isVegetarian) tags.add('VEGETARISCH');
      if (widget.recipeName.contains('Feta') ||
          widget.recipeName.contains('Käse')) {
        // tags.add('GLUTENFREI'); // Falls gewünscht
      } else {
        tags.add('GLUTENFREI');
      }
    }

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final recipe = recipeData;
    final description =
        recipeDescriptions[widget.recipeName] ??
        'Ein köstliches Rezept mit perfekt abgestimmten Gewürzen.';
    final cookingTime = cookingTimes[widget.recipeName] ?? 30;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar mit Bild
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 40, // deutlich größer für Tablet
              ),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.only(left: 24), // mehr Abstand zum Rand
              iconSize: 48, // optional, falls noch größer gewünscht
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                child: Image.asset(
                  'assets/${widget.imagePath}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.primary,
                      child: const Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card (mit Theme-Farben)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.accent, // Gelb aus dem Theme
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titel
                          Text(
                            widget.recipeName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary, // Rot aus dem Theme
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tags
                          Wrap(
                            spacing: 8,
                            children:
                                tags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors
                                                  .support, // Grün aus dem Theme
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                AppColors
                                                    .support, // Grün aus dem Theme
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            color:
                                                Colors.white, // Weiße Textfarbe
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),

                          const SizedBox(height: 16),

                          // Zeit
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white, // Weiße Iconfarbe
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$cookingTime min',
                                style: const TextStyle(
                                  color: Colors.white, // Weiße Textfarbe
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Beschreibung
                          Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white, // Weiße Textfarbe
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Portionen Sektion
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PORTIONEN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.support,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              // Minus Button
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.support, // Grün aus dem Theme
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed:
                                      portions > 1
                                          ? () {
                                            setState(() {
                                              portions--;
                                            });
                                          }
                                          : null,
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Portionen Anzeige
                              Text(
                                portions.toString(),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      AppColors.support, // Grün aus dem Theme
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Plus Button
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.support, // Grün aus dem Theme
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed:
                                      portions < 10
                                          ? () {
                                            setState(() {
                                              portions++;
                                            });
                                          }
                                          : null,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Mahlen Button
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary, // Rot aus dem Theme
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed:
                                      recipe != null
                                          ? () {
                                            // TODO: Implementierung des Mahlvorgangs
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Mahlvorgang für $portions Portionen wird gestartet...',
                                                ),
                                                backgroundColor:
                                                    AppColors.primary,
                                              ),
                                            );
                                          }
                                          : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'GEWÜRZMISCHUNG MAHLEN!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Gewürze Übersicht (optional, falls gewünscht)
                    if (recipe != null) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'INHALT ($portions Portion${portions == 1 ? '' : 'en'})',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),

                            ...recipe.entries
                                .where((entry) => entry.value > 0)
                                .map((entry) {
                                  final amount = entry.value * portions;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key.toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${amount.toStringAsFixed(1)}g',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                                .toList(),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
