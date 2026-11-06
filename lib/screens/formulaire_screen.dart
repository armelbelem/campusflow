import 'package:flutter/material.dart';

import '../data/echeance_store.dart';
import '../models/echeance.dart';

class FormulaireScreen extends StatefulWidget {
  const FormulaireScreen({super.key, required this.store});

  final EcheanceStore store;

  @override
  State<FormulaireScreen> createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titre = TextEditingController();
  final _matiere = TextEditingController();
  final _date = TextEditingController();
  final _description = TextEditingController();
  DateTime? _dateLimite;

  @override
  void dispose() {
    _titre.dispose();
    _matiere.dispose();
    _date.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final aujourdhui = DateUtils.dateOnly(DateTime.now());
    final choix = await showDatePicker(
      context: context,
      initialDate: _dateLimite ?? aujourdhui,
      firstDate: aujourdhui,
      lastDate: DateTime(aujourdhui.year + 2, 12, 31),
      helpText: 'Date limite',
    );
    if (choix == null || !mounted) return;
    setState(() {
      _dateLimite = choix;
      _date.text = MaterialLocalizations.of(context).formatFullDate(choix);
    });
  }

  void _enregistrer() {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    if (!_formKey.currentState!.validate()) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Corrigez les champs signalés en rouge.')),
      );
      return;
    }

    final echeance = Echeance(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      titre: _titre.text.trim(),
      matiere: _matiere.text.trim(),
      date: _dateLimite!,
      description: _description.text.trim(),
    );
    widget.store.ajouter(echeance);

    messenger.showSnackBar(
      SnackBar(content: Text('« ${echeance.titre} » ajoutée')),
    );
    Navigator.of(context).pop(echeance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle échéance')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titre,
                    decoration: _decoration('Titre', Icons.title),
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    validator: (valeur) {
                      final texte = valeur?.trim() ?? '';
                      if (texte.isEmpty) return 'Le titre est obligatoire';
                      if (texte.length < 3) return 'Au moins 3 caractères';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _matiere,
                    decoration: _decoration('Matière', Icons.school_outlined),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (valeur) => (valeur?.trim() ?? '').isEmpty
                        ? 'La matière est obligatoire'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _date,
                    readOnly: true,
                    onTap: _choisirDate,
                    decoration: _decoration('Date limite', Icons.event_outlined)
                        .copyWith(suffixIcon: const Icon(Icons.arrow_drop_down)),
                    validator: (valeur) => (valeur ?? '').isEmpty
                        ? 'Choisissez une date limite'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _description,
                    decoration:
                        _decoration('Description (facultatif)', Icons.notes)
                            .copyWith(alignLabelWithHint: true),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 3,
                    maxLines: 6,
                    maxLength: 300,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _enregistrer,
                    icon: const Icon(Icons.check),
                    label: const Text('Enregistrer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _decoration(String label, IconData icone) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icone),
        border: const OutlineInputBorder(),
      );
}
