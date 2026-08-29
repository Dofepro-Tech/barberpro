import 'package:flutter/material.dart';

/// Botón redondeado para accesos rápidos con proveedores externos (Google/Apple).
class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface, size: 28),
      ),
    );
  }
}
