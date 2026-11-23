import 'json_utils.dart';

/// Une tâche à rendre : TP, projet, QCM…
class Task {
  final String id;
  final String titre;
  final DateTime echeance;
  final bool terminee;
  final String? description;
  final String? coursId;

  const Task({
    required this.id,
    required this.titre,
    required this.echeance,
    this.terminee = false,
    this.description,
    this.coursId,
  });

  /// Lance une [FormatException] si un champ obligatoire manque.
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: lireChamp<String>(json, 'id'),
    titre: lireChamp<String>(json, 'titre'),
    echeance: DateTime.parse(lireChamp<String>(json, 'echeance')),
    terminee: lireChamp<bool?>(json, 'terminee') ?? false,
    description: lireChamp<String?>(json, 'description'),
    coursId: lireChamp<String?>(json, 'coursId'),
  );

  /// Objet vers JSON (séance 7 : envoi au serveur). Date en ISO 8601.
  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'echeance': echeance.toIso8601String(),
    'terminee': terminee,
    'description': description,
    'coursId': coursId,
  };

  /// Copie de la tâche, avec seulement les champs fournis remplacés.
  Task copyWith({
    String? id,
    String? titre,
    DateTime? echeance,
    bool? terminee,
    String? description,
    String? coursId,
  }) => Task(
    id: id ?? this.id,
    titre: titre ?? this.titre,
    echeance: echeance ?? this.echeance,
    terminee: terminee ?? this.terminee,
    description: description ?? this.description,
    coursId: coursId ?? this.coursId,
  );

  bool get enRetard => !terminee && echeance.isBefore(DateTime.now());

  @override
  String toString() =>
      'Task($titre, echeance: ${echeance.toIso8601String()}, terminee: $terminee)';
}
