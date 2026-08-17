import 'package:flutter/material.dart';

import 'vehiculos_screen.dart';
import 'parqueaderos_screen.dart';
import 'mis_reservas_screen.dart';
import 'mapa_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const HomeScreen({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ==========================================
      // BARRA SUPERIOR
      // ==========================================

      appBar: AppBar(
        title: const Text(
          'ParqueoSeguroApp',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      // ==========================================
      // CUERPO
      // ==========================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),

              // ==================================
              // ICONO PRINCIPAL
              // ==================================

              const Icon(
                Icons.local_parking,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(
                height: 20,
              ),

              // ==================================
              // BIENVENIDA
              // ==================================

              Text(
                'Bienvenido, ${usuario['nombre'] ?? ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // ==================================
              // EMAIL
              // ==================================

              Text(
                usuario['email'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              // ==================================
              // 1. MIS VEHÍCULOS
              // ==================================

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const VehiculosScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.directions_car,
                ),
                label: const Text(
                  'Mis vehículos',
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================
              // 2. PARQUEADEROS
              // ==================================

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ParqueaderosScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.local_parking,
                ),
                label: const Text(
                  'Parqueaderos',
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================
              // 3. MIS RESERVAS
              // ==================================

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MisReservasScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.calendar_month,
                ),
                label: const Text(
                  'Mis reservas',
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================
              // 4. ZONAS DISPONIBLES
              // ==================================

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MapaScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.location_on,
                ),
                label: const Text(
                  'Zonas disponibles',
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}