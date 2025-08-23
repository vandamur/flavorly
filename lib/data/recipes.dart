// Jedes Rezept enthält die Gewürze mit ihren jeweiligen Mengen in Gramm

const Map<String, Map<String, double>> recipes = {
  "auberginen": {
    "oregano": 0.0,
    "paprika": 0.0,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.5,
  },

  "baba_ganoush": {
    "oregano": 0.0,
    "paprika": 0.25,
    "pfeffer": 0.25,
    "kreuzkummel": 0.25,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "barbacoa": {
    "oregano": 0.5,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.5,
    "chili": 0.0,
  },

  "cowboy_caviar": {
    "oregano": 0.0,
    "paprika": 0.0,
    "pfeffer": 0.25,
    "kreuzkummel": 0.25,
    "koriander": 0.25,
    "chili": 0.25,
  },

  "doener": {
    "oregano": 0.5,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "empanadas": {
    "oregano": 0.5,
    "paprika": 0.0,
    "pfeffer": 0.0,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "feta_aufstrich": {
    "oregano": 0.5,
    "pfeffer": 0.25,
    "paprika": 0.0,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "feuertopf": {
    "oregano": 0.5,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.25,
  },

  "ful_medames": {
    "oregano": 0.0,
    "paprika": 0.0,
    "pfeffer": 0.0,
    "kreuzkummel": 2.0,
    "koriander": 0.0,
    "chili": 1.0,
  },

  "koefte": {
    "oregano": 0.0,
    "paprika": 0.0,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.5,
    "chili": 0.5,
  },

  "muhammara": {
    "paprika": 0.5,
    "kreuzkummel": 0.5,
    "koriander": 0.25,
    "pfeffer": 0.25,
    "oregano": 0.0,
    "chili": 0.25,
  },

  "paprika_feta_dip": {
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "oregano": 0.0,
    "chili": 0.0,
  },

  "picadillo": {
    "oregano": 0.5,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "puten_gyros": {
    "oregano": 0.5,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.25,
  },

  "ropa_vieja": {
    "oregano": 0.5,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "salsa_roja": {
    "oregano": 0.0,
    "paprika": 0.0,
    "pfeffer": 0.25,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.5,
  },

  "tex_mex": {
    "oregano": 0.0,
    "paprika": 0.5,
    "pfeffer": 0.0,
    "kreuzkummel": 0.5,
    "koriander": 0.0,
    "chili": 0.5,
  },

  "tintenfisch": {
    "oregano": 0.5,
    "paprika": 0.0,
    "pfeffer": 0.25,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "chili": 0.25,
  },

  "tomatensosse": {
    "oregano": 1.5,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "chili": 0.0,
  },

  "zucchini_pfanne": {
    "oregano": 0.0,
    "paprika": 0.5,
    "pfeffer": 0.25,
    "kreuzkummel": 0.0,
    "koriander": 0.0,
    "chili": 0.25,
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
