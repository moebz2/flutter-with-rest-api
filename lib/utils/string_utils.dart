class StringUtils {
  static String getNombre(String name) {
    return name
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // PokeAPI provee un endpoint de traducción,
  // pero son muy pocos tipos para andar llamando a un endpoint más,
  // entonces se traduce localmente nomás.
  static final Map<String, String> typeTranslations = {
    'normal': 'Normal',
    'fire': 'Fuego',
    'water': 'Agua',
    'electric': 'Eléctrico',
    'grass': 'Planta',
    'ice': 'Hielo',
    'fighting': 'Lucha',
    'poison': 'Veneno',
    'ground': 'Tierra',
    'flying': 'Volador',
    'psychic': 'Psíquico',
    'bug': 'Bicho', // xD
    'rock': 'Roca',
    'ghost': 'Fantasma',
    'dragon': 'Dragón',
    'dark': 'Siniestro',
    'steel': 'Acero',
    'fairy': 'Hada',
  };

  static String traducirTipo(String englishType) {
    return StringUtils.typeTranslations[englishType] ?? englishType;
  }
}
