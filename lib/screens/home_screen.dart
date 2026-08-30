import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberpro/screens/services_screen.dart';
import 'package:barberpro/services/auth_service.dart';

/// Pantalla principal mostrada tras iniciar sesión. Muestra el rol del
/// usuario (cliente/barbero/admin) consultado desde la tabla `profiles`.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService(Supabase.instance.client);
  late final Future<String> _roleFuture = _loadRole();

  Future<String> _loadRole() {
    final userId = _authService.currentUser?.id;
    if (userId == null) return Future.value('cliente');
    return _authService.fetchRole(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BARBER OS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _roleFuture,
          builder: (context, snapshot) {
            final role = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bienvenido a BarberOS 💈\nPróximamente: gestión de citas y clientes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                if (role != null) ...[
                  const SizedBox(height: 16),
                  Chip(label: Text('Rol: $role')),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ServicesScreen(isAdmin: role == 'admin'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.content_cut),
                    label: const Text('Ver servicios'),
                  ),
                  if (role == 'admin') ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Panel de administración (próximamente)',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
