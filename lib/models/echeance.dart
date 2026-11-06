class Echeance {
  const Echeance({
    required this.id,
    required this.titre,
    required this.matiere,
    required this.date,
    this.description = '',
    this.fait = false,
  });

  final String id;
  final String titre;
  final String matiere;
  final DateTime date;
  final String description;
  final bool fait;

  Echeance copyWith({bool? fait}) => Echeance(
        id: id,
        titre: titre,
        matiere: matiere,
        date: date,
        description: description,
        fait: fait ?? this.fait,
      );

  int joursRestants([DateTime? maintenant]) {
    final n = maintenant ?? DateTime.now();
    final aujourdhui = DateTime.utc(n.year, n.month, n.day);
    final limite = DateTime.utc(date.year, date.month, date.day);
    return limite.difference(aujourdhui).inDays;
  }

  bool get enRetard => !fait && joursRestants() < 0;

  String get libelleDelai {
    if (fait) return 'Fait';
    return switch (joursRestants()) {
      < 0 => 'En retard',
      0 => "Aujourd'hui",
      1 => 'Demain',
      final j => 'J-$j',
    };
  }

  String get delaiEnClair {
    if (fait) return 'Terminée';
    return switch (joursRestants()) {
      -1 => "En retard d'un jour",
      < -1 && final j => 'En retard de ${-j} jours',
      0 => "À rendre aujourd'hui",
      1 => 'À rendre demain',
      final j => 'Dans $j jours',
    };
  }
}
