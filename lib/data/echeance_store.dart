import 'package:flutter/foundation.dart';

import '../models/echeance.dart';

class EcheanceStore extends ChangeNotifier {
  EcheanceStore([List<Echeance> initiales = const []])
      : _items = [...initiales] {
    _trier();
  }

  factory EcheanceStore.avecExemples() {
    final n = DateTime.now();
    DateTime dans(int jours) => DateTime(n.year, n.month, n.day + jours);

    return EcheanceStore([
      Echeance(
        id: 'e1',
        titre: "QCM d'algorithmique",
        matiere: 'Algorithmique',
        date: dans(-1),
        description: 'QCM en ligne sur les arbres et les graphes : '
            '20 questions, 30 minutes.',
      ),
      Echeance(
        id: 'e2',
        titre: 'Rendu TP Flutter',
        matiere: 'Développement mobile',
        date: dans(2),
        description: "Déposer l'archive du projet CampusFlow : trois écrans "
            'et la version tablette.',
      ),
      Echeance(
        id: 'e3',
        titre: 'Examen SQL',
        matiere: 'Bases de données',
        date: dans(5),
        description: 'Jointures, sous-requêtes et agrégats. Salle B204, '
            'calculatrice interdite.',
      ),
      Echeance(
        id: 'e4',
        titre: 'Rapport de projet réseau',
        matiere: 'Réseaux',
        date: dans(9),
        description: 'Rapport de 10 pages sur la maquette VLAN, en PDF.',
      ),
      Echeance(
        id: 'e5',
        titre: "Oral d'anglais",
        matiere: 'Anglais',
        date: dans(14),
        description: 'Présentation de 5 minutes sur une innovation '
            'technologique.',
      ),
      Echeance(
        id: 'e6',
        titre: 'Lecture du chapitre 3',
        matiere: 'Génie logiciel',
        date: dans(-3),
        description: 'Patrons de conception : Observer et Strategy.',
        fait: true,
      ),
    ]);
  }

  final List<Echeance> _items;

  List<Echeance> get echeances => List.unmodifiable(_items);

  int get nbAFaire => _items.where((e) => !e.fait).length;

  Echeance? parId(String id) {
    for (final e in _items) {
      if (e.id == id) return e;
    }
    return null;
  }

  void ajouter(Echeance echeance) {
    _items.add(echeance);
    _trier();
    notifyListeners();
  }

  void basculerFait(String id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return;
    _items[i] = _items[i].copyWith(fait: !_items[i].fait);
    notifyListeners();
  }

  void _trier() => _items.sort((a, b) => a.date.compareTo(b.date));
}
