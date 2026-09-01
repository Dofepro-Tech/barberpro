import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const _links = [
    (Icons.language_outlined, 'https://dofepro.do', 'Sitio web de Dofepro'),
    (Icons.code, 'https://github.com/dofepro', 'GitHub de Dofepro'),
    (Icons.business, 'https://linkedin.com/in/domingo-feliz-dofepro-tech', 'LinkedIn de Domingo Feliz'),
  ];

  Future<void> _openLink(String address) async {
    await launchUrl(Uri.parse(address), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(color: colors.outlineVariant),
            const SizedBox(height: 8),
            Text(
              '© 2026 Dofepro-Tech',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _links
                  .map(
                    (link) => IconButton(
                      icon: Icon(link.$1),
                      tooltip: link.$3,
                      onPressed: () => _openLink(link.$2),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}