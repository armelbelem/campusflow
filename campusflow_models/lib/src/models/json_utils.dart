/// Lit le champ [cle] de [json] en vérifiant qu'il est du type [T].
///
/// Lance une [FormatException] si le champ est absent ou du mauvais type.
/// Avec un type nullable (ex. `String?`), un champ absent renvoie `null`.
T lireChamp<T>(Map<String, dynamic> json, String cle) {
  final valeur = json[cle];
  if (valeur is! T) {
    throw FormatException(
      'Champ "$cle" manquant ou invalide (attendu : $T)',
      json,
    );
  }
  return valeur;
}
