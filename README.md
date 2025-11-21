# Funcionalidades
## Pantalla principal
 - Mostrar lista de pokemones
 - Mostrar número, sprite, nombre, un icono de corazón si es favorito
 - Permitir desplazarse con scroll
 - Mostrar un indicador de carga (CircularProgressIndicator)
## Búsqueda
 - Buscar por nombre exacto. Si no hay coincidencias, mostrar un mensaje “No se encontraron resultados”.
## Detalle
 - Imagen grande
 - Nombre y número
 - Tipo(s)
 - Altura
 - Peso
# Diseño
 - Utilizar colores de fondo suaves y tarjetas (Card) para cada Pokémon.
 - Implementar íconos y tipografía
# Bonus
 - Implementar un modo oscuro / claro.
 - Guardar pokemon “favoritos” con SharedPreferences.
 - Usar GridView.builder para mostrar los Pokémon en formato de cuadrícula.
 - Animar la transición entre pantallas con Hero.
# Desafíos
- Aprender sobre funciones async y futures, setState.
- Aprender cómo detectar el scroll para traer más items automáticamente.
- Aprender cómo usar un input de texto (TextEditingController).
- Aprender cómo organizar código en diferentes archivos.
- Aprender sobre SharedPreferences, consumers y providers para al agregar un favorito poder mostrar en la lista.
- Implementar también consumers y providers para poder cambiar de tema (light/dark).
- La API de Pokemons no provee búsqueda parcial, pero sí provee GET de un Pokemon por ID o por nombre exacto, entonces decidí implementar búsqueda por nombre exacto.
