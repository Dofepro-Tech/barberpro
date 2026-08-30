import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberpro/models/service_model.dart';

/// Acceso a la tabla `services` de Supabase. Las reglas de RLS ya
/// restringen la escritura a usuarios con rol admin (ver 002_services.sql).
class ServicesRepository {
  ServicesRepository(this._client);

  final SupabaseClient _client;

  Future<List<ServiceModel>> fetchServices() async {
    final rows = await _client
        .from('services')
        .select()
        .order('created_at');
    return (rows as List)
        .map((row) => ServiceModel.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> createService(ServiceModel service) {
    return _client.from('services').insert(service.toInsertMap());
  }

  Future<void> setActive(String id, bool activo) {
    return _client.from('services').update({'activo': activo}).eq('id', id);
  }

  Future<void> deleteService(String id) {
    return _client.from('services').delete().eq('id', id);
  }
}
