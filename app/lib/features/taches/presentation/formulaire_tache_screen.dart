import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formats.dart';
import '../../../core/theme.dart';
import '../application/taches_notifier.dart';

/// Page de la route /taches/nouvelle : le formulaire écrit dans l'état partagé.
class NouvelleTachePage extends ConsumerWidget {
  const NouvelleTachePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormulaireTacheScreen(
      cours: ref.watch(coursProvider).value ?? const [],
      onEnregistrer: (tache) =>
          ref.read(tachesProvider.notifier).ajouter(tache),
    );
  }
}

/// Écran Nouvelle tâche : seul le titre est obligatoire.
class FormulaireTacheScreen extends StatefulWidget {
  const FormulaireTacheScreen({
    super.key,
    required this.cours,
    required this.onEnregistrer,
  });

  final List<Course> cours;

  /// Reçoit la tâche validée. Renvoie un Future pour pouvoir attendre un
  /// enregistrement distant (séance 7).
  final Future<void> Function(Task tache) onEnregistrer;

  @override
  State<FormulaireTacheScreen> createState() => _FormulaireTacheScreenState();
}

class _FormulaireTacheScreenState extends State<FormulaireTacheScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titre = TextEditingController();
  final _description = TextEditingController();
  String? _coursId;
  late DateTime _echeance;
  var _enCours = false;

  @override
  void initState() {
    super.initState();
    final demain = DateTime.now().add(const Duration(days: 1));
    _echeance = DateTime(demain.year, demain.month, demain.day, 18);
  }

  @override
  void dispose() {
    // Toujours libérer les contrôleurs de texte.
    _titre.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _echeance,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;
    final heure = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_echeance),
    );
    setState(() {
      _echeance = DateTime(
        date.year,
        date.month,
        date.day,
        heure?.hour ?? _echeance.hour,
        heure?.minute ?? _echeance.minute,
      );
    });
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    final description = _description.text.trim();
    final tache = Task(
      id: 't${DateTime.now().millisecondsSinceEpoch}',
      titre: _titre.text.trim(),
      echeance: _echeance,
      coursId: _coursId,
      description: description.isEmpty ? null : description,
    );

    setState(() => _enCours = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await widget.onEnregistrer(tache);
      messenger.showSnackBar(
        SnackBar(content: Text('Tâche « ${tache.titre} » ajoutée')),
      );
      navigator.pop(tache);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("La tâche n'a pas pu être enregistrée : $e")),
      );
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Nouvelle tâche'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          // Défilant : le clavier ne bloque jamais le bouton Enregistrer.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(CampusSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titre,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Titre *'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Le titre est obligatoire'
                      : null,
                ),
                const SizedBox(height: CampusSpacing.m),
                DropdownButtonFormField<String>(
                  initialValue: _coursId,
                  // Un intitulé long se coupe au lieu de déborder.
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Cours'),
                  items: [
                    for (final c in widget.cours)
                      DropdownMenuItem(value: c.id, child: Text(c.intitule)),
                  ],
                  onChanged: (v) => setState(() => _coursId = v),
                ),
                const SizedBox(height: CampusSpacing.m),
                InkWell(
                  onTap: _choisirDate,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Échéance',
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                    child: Text(formatEcheance(_echeance)),
                  ),
                ),
                const SizedBox(height: CampusSpacing.m),
                TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Description (facultative)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: CampusSpacing.l),
                FilledButton(
                  onPressed: _enCours ? null : _enregistrer,
                  child: Text(_enCours ? 'Enregistrement…' : 'Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
