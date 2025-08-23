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

class RecipeCategories {
  static const String vegan = "Vegan";
  static const String sauce = "Sauce";
  static const String international = "International";
  static const String glutenfrei = "Glutenfrei";
  static const String laktosefrei = "Laktosefrei";
  static const String vegetarisch = "Vegetarisch";
  static const String vorspeisen = "Vorspeisen";
  static const String hauptgerichte = "Hauptgerichte";
  static const String dips = "Dips";
  static const String fleisch = "Fleisch";
}

const Map<String, List<String>> recipeCategories = {
  "auberginen": [
    RecipeCategories.international,
    RecipeCategories.glutenfrei,
    RecipeCategories.hauptgerichte,
  ],

  "baba_ganoush": [
    RecipeCategories.vegan,
    RecipeCategories.international,
    RecipeCategories.vorspeisen,
    RecipeCategories.glutenfrei,
    RecipeCategories.dips,
  ],

  "barbacoa": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.fleisch,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
  ],

  "cowboy_caviar": [
    RecipeCategories.vegan,
    RecipeCategories.international,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
    RecipeCategories.vegetarisch,
    RecipeCategories.dips,
  ],

  "doener": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
  ],

  "empanadas": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
  ],

  "feta_aufstrich": [
    RecipeCategories.vegetarisch,
    RecipeCategories.dips,
    RecipeCategories.vorspeisen,
  ],

  "feuertopf": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.fleisch,
  ],

  "ful_medames": [
    RecipeCategories.vegan,
    RecipeCategories.international,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
    RecipeCategories.vegetarisch,
    RecipeCategories.hauptgerichte,
  ],

  "koefte": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.fleisch,
  ],

  "muhammara": [
    RecipeCategories.vegan,
    RecipeCategories.international,
    RecipeCategories.dips,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
  ],

  "paprika_feta_dip": [
    RecipeCategories.dips,
    RecipeCategories.vegetarisch,
    RecipeCategories.vorspeisen,
  ],

  "picadillo": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.fleisch,
  ],

  "puten_gyros": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.fleisch,
  ],

  "ropa_vieja": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.fleisch,
  ],

  "salsa_roja": [
    RecipeCategories.sauce,
    RecipeCategories.vegan,
    RecipeCategories.international,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
    RecipeCategories.dips,
    RecipeCategories.vegetarisch,
  ],

  "tex_mex": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.fleisch,
  ],

  "tintenfisch": [
    RecipeCategories.international,
    RecipeCategories.hauptgerichte,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
  ],

  "tomatensosse": [
    RecipeCategories.sauce,
    RecipeCategories.vegan,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
  ],

  "zucchini_pfanne": [
    RecipeCategories.vegan,
    RecipeCategories.hauptgerichte,
    RecipeCategories.glutenfrei,
    RecipeCategories.laktosefrei,
  ],
};

class RecipeCatalog {
  static List<String> getAllRecipeNames() {
    return recipes.keys.toList();
  }

  static Map<String, double>? getRecipe(String recipeName) {
    return recipes[recipeName];
  }

  static List<String> getRecipeCategories(String recipeName) {
    return recipeCategories[recipeName] ?? [];
  }

  static List<String> getRecipesByCategory(String category) {
    return recipeCategories.entries
        .where((entry) => entry.value.contains(category))
        .map((entry) => entry.key)
        .toList();
  }

  static bool isRecipeInCategory(String recipeName, String category) {
    return recipeCategories[recipeName]?.contains(category) ?? false;
  }

  static List<String> getAllCategories() {
    final Set<String> allCategories = {};
    for (final categoryList in recipeCategories.values) {
      allCategories.addAll(categoryList);
    }
    return allCategories.toList()..sort();
  }

  static List<String> getRecipesByMultipleCategories(List<String> categories) {
    return recipeCategories.entries
        .where((entry) => categories.every((cat) => entry.value.contains(cat)))
        .map((entry) => entry.key)
        .toList();
  }
}
