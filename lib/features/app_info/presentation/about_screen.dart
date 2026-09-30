import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfs/features/app_info/domain/app_info.dart';
import 'package:kfs/features/app_info/presentation/app_info_providers.dart';
import 'package:kfs/l10n/app_localizations.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const routePath = '/about';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final info = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: info.when(
        loading: () => Center(child: Text(l10n.loading)),
        error: (_, _) => _ErrorView(
          message: l10n.errorGeneric,
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(appInfoProvider),
        ),
        data: (data) => _AppInfoList(info: data),
      ),
    );
  }
}

class _AppInfoList extends StatelessWidget {
  const _AppInfoList({required this.info});

  final AppInfo info;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      children: [
        ListTile(title: Text(l10n.aboutVersion), subtitle: Text(info.version)),
        ListTile(
          title: Text(l10n.aboutBuild),
          subtitle: Text(info.buildNumber),
        ),
        ListTile(
          title: Text(l10n.aboutFlavor),
          subtitle: Text(info.flavor.name),
        ),
        ListTile(
          title: Text(l10n.aboutServer),
          subtitle: Text(info.studioBaseUrl),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}
