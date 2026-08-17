import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  // Token del usuario que inició sesión
  static String? accessToken;

  // =========================
  // LOGIN
  // =========================

  static Future<Map<String, dynamic>> login(
    String email,
    String contrasena,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'contrasena': contrasena,
      }),
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      accessToken = datos['access_token'];
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al iniciar sesión',
      );
    }
  }

  // =========================
  // REGISTRO
  // =========================

  static Future<Map<String, dynamic>> registro(
    String nombre,
    String email,
    String contrasena,
    String telefono,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/registro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'contrasena': contrasena,
        'telefono': telefono,
      }),
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al registrarse',
      );
    }
  }

  // =========================
  // LISTAR VEHÍCULOS
  // =========================

  static Future<List<dynamic>> listarVehiculos() async {
    if (accessToken == null) {
      throw Exception('No hay sesión iniciada');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/vehiculos/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al obtener vehículos',
      );
    }
  }

  // =========================
  // CREAR VEHÍCULO
  // =========================

  static Future<Map<String, dynamic>> crearVehiculo(
    String placa,
    String marcaModelo,
  ) async {
    if (accessToken == null) {
      throw Exception('No hay sesión iniciada');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/vehiculos/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'placa': placa,
        'marca_modelo': marcaModelo,
      }),
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al agregar vehículo',
      );
    }
  }

  // =========================
  // ACTUALIZAR VEHÍCULO
  // =========================

  static Future<Map<String, dynamic>> actualizarVehiculo(
    int idVehiculo,
    String placa,
    String marcaModelo,
  ) async {
    if (accessToken == null) {
      throw Exception('No hay sesión iniciada');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/vehiculos/$idVehiculo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'placa': placa,
        'marca_modelo': marcaModelo,
      }),
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al actualizar vehículo',
      );
    }
  }

  // =========================
  // ELIMINAR VEHÍCULO
  // =========================

  static Future<Map<String, dynamic>> eliminarVehiculo(
    int idVehiculo,
  ) async {
    if (accessToken == null) {
      throw Exception('No hay sesión iniciada');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/vehiculos/$idVehiculo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al eliminar vehículo',
      );
    }
  }

  // =========================
  // LISTAR PARQUEADEROS
  // =========================

  static Future<List<dynamic>> listarParqueaderos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/parqueaderos/'),
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al obtener parqueaderos',
      );
    }
  }

  // =========================
  // LISTAR ZONAS
  // =========================

  static Future<List<dynamic>> listarZonas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/zonas/'),
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al obtener zonas',
      );
    }
  }
    // =========================
  // CREAR RESERVA
  // =========================

  static Future<Map<String, dynamic>> crearReserva({
    required int idVehiculo,
    required int idZona,
    required String fechaReserva,
    required String horaInicio,
    required String horaFin,
    required double montoTotal,
  }) async {
    if (accessToken == null) {
      throw Exception('No hay sesión iniciada');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/reservas/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'id_vehiculo': idVehiculo,
        'id_zona': idZona,
        'fecha_reserva': fechaReserva,
        'hora_inicio': horaInicio,
        'hora_fin': horaFin,
        'monto_total': montoTotal,
      }),
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al crear reserva',
      );
    }
  }

  // =========================
  // LISTAR MIS RESERVAS
  // =========================

  static Future<List<dynamic>> listarReservas() async {
    if (accessToken == null) {
      throw Exception('No hay sesión iniciada');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/reservas/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al obtener reservas',
      );
    }
  }

  // =========================
  // CANCELAR RESERVA
  // =========================

  static Future<Map<String, dynamic>> cancelarReserva(
    int idReserva,
  ) async {
    if (accessToken == null) {
      throw Exception('No hay sesión iniciada');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/reservas/$idReserva'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final datos = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return datos;
    } else {
      throw Exception(
        datos['mensaje'] ?? 'Error al cancelar reserva',
      );
    }
  }
}