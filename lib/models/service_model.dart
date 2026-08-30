/// Representa un servicio del catálogo de la barbería (corte, barba, etc.).
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.duracionMinutos,
    this.descripcion,
    this.activo = true,
  });

  final String id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int duracionMinutos;
  final bool activo;

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String?,
      precio: (map['precio'] as num).toDouble(),
      duracionMinutos: map['duracion_minutos'] as int,
      activo: map['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'duracion_minutos': duracionMinutos,
      'activo': activo,
    };
  }
}
