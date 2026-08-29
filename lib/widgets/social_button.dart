import 'package:flutter/material.dart';
import 'package:barberpro/theme/app_theme.dart';

/// Botón redondeado para accesos rápidos con proveedores externos (Google/Apple).
class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
