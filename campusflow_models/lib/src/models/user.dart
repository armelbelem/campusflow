import 'json_utils.dart';

/// L'utilisateur connecté (un étudiant).
class User {
  final String id;
  final String nom;
  final String email;

  /// Identifiants des cours suivis. Liste non modifiable : une liste `final`
  /// pourrait sinon encore changer de contenu.
  final List<String> coursIds;

  User({
    required this.id,
    required this.nom,
    required this.email,
    List<String> coursIds = const [],
  }) : coursIds = List.unmodifiable(coursIds);

  /// Lance une [FormatException] si un champ obligatoire manque.
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: lireChamp<String>(json, 'id'),
    nom: lireChamp<String>(json, 'nom'),
    email: lireChamp<String>(json, 'email'),
    coursIds: List<String>.from(
      lireChamp<List<dynamic>?>(json, 'coursIds') ?? const [],
    ),
  );

  /// Copie de l'utilisateur, avec seulement les champs fournis remplacés.
  User copyWith({
    String? id,
    String? nom,
    String? email,
    List<String>? coursIds,
  }) => User(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    email: email ?? this.email,
    coursIds: coursIds ?? this.coursIds,
  );

  @override
  String toString() => 'User($nom, $email, ${coursIds.length} cours)';
}
