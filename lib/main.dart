import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberpro/screens/home_screen.dart';
import 'package:barberpro/screens/login_screen.dart';
import 'package:barberpro/theme/app_theme.dart';
import 'package:barberpro/theme/theme_controller.dart';

/// Punto de entrada de BarberOS: carga la configuración de entorno,
/// inicializa Supabase y arranca la app en Modo Oscuro Premium.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw StateError(
      'Faltan las variables SUPABASE_URL / SUPABASE_ANON_KEY. '
      'Copia .env.example a .env y completa tus credenciales de Supabase.',
    );
  }

  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);

  runApp(const BarberOSApp());
}

class BarberOSApp extends StatelessWidget {
  const BarberOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'BarberOS',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const AuthGate(),
        );
      },
    );
  }
}

/// Decide si mostrar la pantalla de login o la app principal según la sesión.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      initialData: AuthState(
        AuthChangeEvent.initialSession,
        Supabase.instance.client.auth.currentSession,
      ),
      builder: (context, snapshot) {
        final session = snapshot.data?.session;
        return session != null ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
