import 'package:intl/intl.dart';

/// « aujourd'hui », « demain », « hier » ou « ven. 28 nov. », suivi de l'heure.
String formatEcheance(DateTime date, {DateTime? maintenant}) {
  final now = maintenant ?? DateTime.now();
  final ecart = DateTime(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime(now.year, now.month, now.day)).inDays;
  final jour = switch (ecart) {
    0 => "aujourd'hui",
    1 => 'demain',
    -1 => 'hier',
    _ => DateFormat('EEE d MMM', 'fr_FR').format(date),
  };
  return '$jour · ${DateFormat('HH:mm').format(date)}';
}

/// « vendredi 28 novembre 2026 à 17:00 ».
String formatDateLongue(DateTime date) =>
    DateFormat("EEEE d MMMM yyyy 'à' HH:mm", 'fr_FR').format(date);
