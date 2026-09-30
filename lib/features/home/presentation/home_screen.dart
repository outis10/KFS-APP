import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfs/features/app_info/presentation/about_screen.dart';
import 'package:kfs/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routePath = '/';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.homeTemplateNotice,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.info_outline),
                label: Text(l10n.homeAboutButton),
                onPressed: () => context.push(AboutScreen.routePath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
