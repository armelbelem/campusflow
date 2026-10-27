import 'json_utils.dart';

/// Un cours suivi par l'étudiant.
class Course {
  final String id;
  final String intitule;
  final String enseignant;
  final int credits;
  final String? salle;

  const Course({
    required this.id,
    required this.intitule,
    required this.enseignant,
    this.credits = 0,
    this.salle,
  });

  /// Lance une [FormatException] si un champ obligatoire manque.
  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: lireChamp<String>(json, 'id'),
    intitule: lireChamp<String>(json, 'intitule'),
    enseignant: lireChamp<String>(json, 'enseignant'),
    credits: lireChamp<int?>(json, 'credits') ?? 0,
    salle: lireChamp<String?>(json, 'salle'),
  );

  /// Copie du cours, avec seulement les champs fournis remplacés.
  Course copyWith({
    String? id,
    String? intitule,
    String? enseignant,
    int? credits,
    String? salle,
  }) => Course(
    id: id ?? this.id,
    intitule: intitule ?? this.intitule,
    enseignant: enseignant ?? this.enseignant,
    credits: credits ?? this.credits,
    salle: salle ?? this.salle,
  );

  @override
  String toString() => 'Course($intitule, $enseignant, $credits crédits)';
}
