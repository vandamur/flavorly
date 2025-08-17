// Jedes Rezept enthält die Gewürze mit ihren jeweiligen Mengen in Gramm

const Map<String, Map<String, double>> recipes = {
  "muhammara": {
    "paprika": 1.0,
    "kreuzkummel": 1.0,
    "koriander": 0.5,
    "pfeffer": 0.5,
    "oregano": 0.0,
    "chili": 0.5,
  },

  "paprika_feta_dip": {
    "paprika": 1.0,
    "pfeffer": 0.5,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "oregano": 0.0,
    "chili": 0.0,
  },

  "feta_aufstrich": {
    "oregano": 1.0,
    "pfeffer": 0.5,
    "paprika": 0.0,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "tomatensosse": {
    "oregano": 3.0,
    "paprika": 1.0,
    "pfeffer": 0.5,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "chili": 0.0,
  },
};

// Hilfsfunktionen für den Zugriff auf Rezepte
class RecipeCatalog {
  /// Gibt alle verfügbaren Rezeptnamen zurück
  static List<String> getAllRecipeNames() {
    return recipes.keys.toList();
  }

  /// Gibt ein spezifisches Rezept zurück
  static Map<String, double>? getRecipe(String recipeName) {
    return recipes[recipeName];
  }
}
