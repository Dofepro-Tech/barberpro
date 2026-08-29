import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberpro/screens/home_screen.dart';
import 'package:barberpro/screens/register_screen.dart';
import 'package:barberpro/services/auth_service.dart';
import 'package:barberpro/theme/app_theme.dart';
import 'package:barberpro/widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService(Supabase.instance.client);

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('No se pudo iniciar sesión. Intenta nuevamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Selector de Idioma (Soporte Multi-idioma superior)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton.icon(
                    onPressed: () => _showSnack('Soporte multi-idioma (ES / EN) en desarrollo'),
                    icon: const Icon(Icons.language, color: AppColors.gold),
                    label: const Text('ES', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Logotipo e Identidad Visual
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold, width: 2),
                          color: AppColors.surface,
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          size: 50,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('BARBER OS', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Tu barbería de confianza, en un toque.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // 3. Campo de Entrada: Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.gold),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa tu correo electrónico';
                    }
                    if (!value.contains('@')) return 'Correo electrónico inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. Campo de Entrada: Contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.gold),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white54,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // 5. Botón de Acción Principal (Ingresar)
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text('Ingresar'),
                ),
                const SizedBox(height: 24),

                // 6. Botones de Acceso Rápido (Google / Apple)
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('O accede con', style: TextStyle(color: Colors.white30, fontSize: 12)),
                    ),
                    const Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(
                      icon: Icons.g_mobiledata,
                      onTap: () => _showSnack('Acceso rápido con Google (próximamente)'),
                    ),
                    const SizedBox(width: 20),
                    SocialButton(
                      icon: Icons.apple,
                      onTap: () => _showSnack('Acceso rápido con Apple (próximamente)'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 7. Registro de Usuarios Nuevos
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: '¿No tienes cuenta? ',
                        style: TextStyle(color: Colors.white54),
                        children: [
                          TextSpan(
                            text: 'Regístrate aquí',
                            style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
