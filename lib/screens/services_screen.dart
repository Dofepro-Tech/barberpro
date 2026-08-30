import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberpro/models/service_model.dart';
import 'package:barberpro/services/services_repository.dart';
import 'package:barberpro/theme/app_theme.dart';

/// Catálogo de servicios de la barbería. Los admins pueden agregar,
/// desactivar o eliminar servicios; el resto de usuarios solo los ve.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _repository = ServicesRepository(Supabase.instance.client);
  late Future<List<ServiceModel>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _repository.fetchServices();
  }

  void _reload() {
    setState(() => _servicesFuture = _repository.fetchServices());
  }

  Future<void> _showCreateDialog() async {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final precioController = TextEditingController();
    final duracionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final creado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo servicio'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                ),
                TextFormField(
                  controller: precioController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Precio (RD\$)'),
                  validator: (v) => double.tryParse(v ?? '') == null ? 'Precio inválido' : null,
                ),
                TextFormField(
                  controller: duracionController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Duración (minutos)'),
                  validator: (v) => int.tryParse(v ?? '') == null ? 'Duración inválida' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (creado != true || !mounted) return;

    try {
      await _repository.createService(
        ServiceModel(
          id: '',
          nombre: nombreController.text.trim(),
          descripcion: descripcionController.text.trim().isEmpty
              ? null
              : descripcionController.text.trim(),
          precio: double.parse(precioController.text),
          duracionMinutos: int.parse(duracionController.text),
        ),
      );
      _reload();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo crear el servicio.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: _showCreateDialog,
              child: const Icon(Icons.add),
            )
          : null,
      body: FutureBuilder<List<ServiceModel>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final services = snapshot.data!;
          if (services.isEmpty) {
            return const Center(child: Text('Aún no hay servicios registrados.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                child: ListTile(
                  title: Text(service.nombre),
                  subtitle: Text(
                    '${service.duracionMinutos} min'
                    '${service.descripcion != null ? ' · ${service.descripcion}' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RD\$${service.precio.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.isAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await _repository.deleteService(service.id);
                            _reload();
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
