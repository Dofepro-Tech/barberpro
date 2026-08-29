import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Envuelve las operaciones de autenticación de Supabase usadas por la app.
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  /// Esquema de deep link usado para volver a la app tras el login OAuth
  /// en Android/iOS. Debe coincidir con el configurado en Supabase Auth
  /// (Authentication → URL Configuration → Redirect URLs) y con el
  /// intent-filter / CFBundleURLTypes de cada plataforma.
  static const _mobileRedirect = 'io.dofepro.barberpro://login-callback';

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password}) async {
    await _client.auth.signUp(email: email, password: password);
  }

  /// Inicia sesión con Google. Requiere que el proveedor esté configurado
  /// en Supabase (Authentication → Providers → Google) con su Client ID/Secret.
  Future<void> signInWithGoogle() => _oauthSignIn(OAuthProvider.google);

  /// Inicia sesión con Apple. Requiere configurar el proveedor Apple en
  /// Supabase (Authentication → Providers → Apple) con tu Service ID/Key.
  Future<void> signInWithApple() => _oauthSignIn(OAuthProvider.apple);

  /// Obtiene la URL de login del proveedor y la abre en una pestaña nueva
  /// en web (en móvil se abre en el navegador externo del sistema).
  Future<void> _oauthSignIn(OAuthProvider provider) async {
    final response = await _client.auth.getOAuthSignInUrl(
      provider: provider,
      redirectTo: kIsWeb ? null : _mobileRedirect,
    );
    final uri = Uri.parse(response.url);
    await launchUrl(
      uri,
      mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Obtiene el rol del usuario (cliente/barbero/admin) desde la tabla
  /// `profiles`. El rol nunca se define desde el cliente: se asigna por
  /// defecto en 'cliente' mediante un trigger en la base de datos, y solo
  /// puede escalarse a 'admin' manualmente desde Supabase.
  Future<String> fetchRole(String userId) async {
    final row = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    return (row?['role'] as String?) ?? 'cliente';
  }
}
