import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';

/// Écran de connexion (hors barre de navigation).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _motDePasse = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _motDePasse.dispose();
    super.dispose();
  }

  void _seConnecter() {
    if (!_formKey.currentState!.validate()) return;
    context.go('/taches');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(CampusSpacing.l),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 96,
                      semanticLabel: 'Logo CampusFlow',
                    ),
                    const SizedBox(height: CampusSpacing.m),
                    Text(
                      'CampusFlow',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      'Ne ratez plus aucun rendu',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: CampusSpacing.xl),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Saisissez une adresse e-mail valide'
                          : null,
                    ),
                    const SizedBox(height: CampusSpacing.m),
                    TextFormField(
                      controller: _motDePasse,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Saisissez votre mot de passe'
                          : null,
                      onFieldSubmitted: (_) => _seConnecter(),
                    ),
                    const SizedBox(height: CampusSpacing.l),
                    FilledButton(
                      onPressed: _seConnecter,
                      child: const Text('Se connecter'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
