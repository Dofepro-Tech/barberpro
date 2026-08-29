import 'package:flutter/material.dart';

import 'package:barberpro/theme/app_theme.dart';
import 'package:barberpro/theme/theme_controller.dart';

/// Idiomas soportados por BarberOS.
enum AppLanguage { es, en, fr, pt }

extension AppLanguageLabel on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.es:
        return 'ES';
      case AppLanguage.en:
        return 'EN';
      case AppLanguage.fr:
        return 'FR';
      case AppLanguage.pt:
        return 'PT';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.es:
        return 'Español';
      case AppLanguage.en:
        return 'English';
      case AppLanguage.fr:
        return 'Français';
      case AppLanguage.pt:
        return 'Português';
    }
  }
}

/// Controlador global y simple para alternar el idioma de la interfaz.
class LocaleController {
  LocaleController._();

  static final ValueNotifier<AppLanguage> language = ValueNotifier(
    AppLanguage.es,
  );

  static void toggle() {
    language.value = language.value == AppLanguage.es
        ? AppLanguage.en
        : AppLanguage.es;
  }

  static void select(AppLanguage value) {
    language.value = value;
  }
}

/// Textos traducidos usados en las pantallas de acceso.
class Strings {
  Strings._();

  static const Map<String, Map<AppLanguage, String>> _values = {
    'tagline': {
      AppLanguage.es: 'Tu barbería de confianza, en un toque.',
      AppLanguage.en: 'Your trusted barbershop, in one tap.',
      AppLanguage.fr: 'Votre salon de confiance, en un instant.',
      AppLanguage.pt: 'Sua barbearia de confiança, em um toque.',
    },
    'email': {
      AppLanguage.es: 'Correo Electrónico',
      AppLanguage.en: 'Email',
      AppLanguage.fr: 'E-mail',
      AppLanguage.pt: 'E-mail',
    },
    'password': {
      AppLanguage.es: 'Contraseña',
      AppLanguage.en: 'Password',
      AppLanguage.fr: 'Mot de passe',
      AppLanguage.pt: 'Senha',
    },
    'login': {
      AppLanguage.es: 'Ingresar',
      AppLanguage.en: 'Sign in',
      AppLanguage.fr: 'Se connecter',
      AppLanguage.pt: 'Entrar',
    },
    'orContinueWith': {
      AppLanguage.es: 'O accede con',
      AppLanguage.en: 'Or continue with',
      AppLanguage.fr: 'Ou continuer avec',
      AppLanguage.pt: 'Ou continue com',
    },
    'noAccount': {
      AppLanguage.es: '¿No tienes cuenta? ',
      AppLanguage.en: "Don't have an account? ",
      AppLanguage.fr: "Vous n'avez pas de compte ? ",
      AppLanguage.pt: 'Não tem uma conta? ',
    },
    'registerHere': {
      AppLanguage.es: 'Regístrate aquí',
      AppLanguage.en: 'Sign up here',
      AppLanguage.fr: "Inscrivez-vous ici",
      AppLanguage.pt: 'Cadastre-se aqui',
    },
    'enterEmail': {
      AppLanguage.es: 'Ingresa tu correo electrónico',
      AppLanguage.en: 'Enter your email',
      AppLanguage.fr: 'Entrez votre e-mail',
      AppLanguage.pt: 'Digite seu e-mail',
    },
    'invalidEmail': {
      AppLanguage.es: 'Correo electrónico inválido',
      AppLanguage.en: 'Invalid email',
      AppLanguage.fr: 'E-mail invalide',
      AppLanguage.pt: 'E-mail inválido',
    },
    'passwordLength': {
      AppLanguage.es: 'La contraseña debe tener al menos 6 caracteres',
      AppLanguage.en: 'Password must be at least 6 characters',
      AppLanguage.fr: 'Le mot de passe doit contenir au moins 6 caractères',
      AppLanguage.pt: 'A senha deve ter pelo menos 6 caracteres',
    },
    'createAccount': {
      AppLanguage.es: 'Crear cuenta',
      AppLanguage.en: 'Create account',
      AppLanguage.fr: 'Créer un compte',
      AppLanguage.pt: 'Criar conta',
    },
    'registerButton': {
      AppLanguage.es: 'Registrarme',
      AppLanguage.en: 'Register',
      AppLanguage.fr: "S'inscrire",
      AppLanguage.pt: 'Registrar',
    },
  };

  static String t(String key) {
    return _values[key]?[LocaleController.language.value] ?? key;
  }
}

/// Botón que alterna entre modo claro/oscuro.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          onPressed: ThemeController.toggle,
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: AppColors.gold,
          ),
          tooltip: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
        );
      },
    );
  }
}

/// Selector desplegable de idioma (ES/EN/FR/PT).
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LocaleController.language,
      builder: (context, language, _) {
        return PopupMenuButton<AppLanguage>(
          tooltip: 'Cambiar idioma',
          initialValue: language,
          onSelected: LocaleController.select,
          color: AppColors.surface,
          itemBuilder: (context) => AppLanguage.values
              .map(
                (lang) => PopupMenuItem(
                  value: lang,
                  child: Text(
                    lang.displayName,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(language.code, style: const TextStyle(color: Colors.white)),
              const Icon(Icons.arrow_drop_down, color: Colors.white70),
            ],
          ),
        );
      },
    );
  }
}
