import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/api_service.dart';
import 'zonas_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final MapController _mapController = MapController();

  List<dynamic> parqueaderos = [];

  bool cargando = true;

  // ==========================================
  // UBICACIÓN INICIAL
  // ==========================================

  static const LatLng ubicacionInicial = LatLng(
    -0.180653,
    -78.467834,
  );

  @override
  void initState() {
    super.initState();
    cargarParqueaderos();
  }

  // ==========================================
  // CARGAR PARQUEADEROS
  // ==========================================

  Future<void> cargarParqueaderos() async {
    try {
      final resultado =
          await ApiService.listarParqueaderos();

      if (!mounted) {
        return;
      }

      setState(() {
        parqueaderos = resultado.where((parqueadero) {
          return parqueadero['latitud'] != null &&
              parqueadero['longitud'] != null;
        }).toList();

        cargando = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  // ==========================================
  // MOSTRAR INFORMACIÓN DEL PARQUEADERO
  // ==========================================

  void mostrarParqueadero(
    Map<String, dynamic> parqueadero,
  ) {
    final id = parqueadero['id'];

    final nombre =
        parqueadero['nombre'] ?? 'Parqueadero';

    final direccion =
        parqueadero['direccion'] ?? 'Sin dirección';

    final capacidad =
        parqueadero['capacidad'] ?? 0;

    final tarifa =
        parqueadero['tarifa'] ?? '0.00';

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ==================================
                // NOMBRE
                // ==================================

                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      child: Icon(
                        Icons.local_parking,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================
                // DIRECCIÓN
                // ==================================

                ListTile(
                  contentPadding:
                      EdgeInsets.zero,

                  leading: const Icon(
                    Icons.location_on,
                  ),

                  title: const Text(
                    'Dirección',
                  ),

                  subtitle: Text(
                    direccion,
                  ),
                ),

                // ==================================
                // CAPACIDAD
                // ==================================

                ListTile(
                  contentPadding:
                      EdgeInsets.zero,

                  leading: const Icon(
                    Icons.local_parking,
                  ),

                  title: const Text(
                    'Capacidad',
                  ),

                  subtitle: Text(
                    '$capacidad espacios',
                  ),
                ),

                // ==================================
                // TARIFA
                // ==================================

                ListTile(
                  contentPadding:
                      EdgeInsets.zero,

                  leading: const Icon(
                    Icons.attach_money,
                  ),

                  title: const Text(
                    'Tarifa',
                  ),

                  subtitle: Text(
                    '\$$tarifa por hora',
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // ==================================
                // BOTÓN VER ZONAS
                // ==================================

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(
                        bottomSheetContext,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ZonasScreen(
                            idParqueadero: id,
                            nombreParqueadero:
                                nombre,
                          ),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.event_available,
                    ),

                    label: const Text(
                      'Ver zonas disponibles',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // CREAR MARCADORES
  // ==========================================

  List<Marker> construirMarcadores() {
    return parqueaderos.map<Marker>(
      (parqueadero) {
        final latitud =
            double.tryParse(
                  parqueadero['latitud']
                      .toString(),
                ) ??
                ubicacionInicial.latitude;

        final longitud =
            double.tryParse(
                  parqueadero['longitud']
                      .toString(),
                ) ??
                ubicacionInicial.longitude;

        return Marker(
          point: LatLng(
            latitud,
            longitud,
          ),

          width: 80,

          height: 80,

          child: GestureDetector(
            onTap: () {
              mostrarParqueadero(
                parqueadero,
              );
            },

            child: const Column(
              children: [
                Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.red,
                ),

                Text(
                  'Parking',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  // ==========================================
  // INTERFAZ
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Zonas disponibles',
        ),

        actions: [
          IconButton(
            onPressed: cargarParqueaderos,
            icon: const Icon(
              Icons.refresh,
            ),
            tooltip: 'Actualizar',
          ),
        ],
      ),

      body: cargando
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : parqueaderos.isEmpty
              ? const Center(
                  child: Padding(
                    padding:
                        EdgeInsets.all(24),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.location_off,
                          size: 80,
                          color: Colors.grey,
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          'No hay parqueaderos '
                          'con ubicación registrada.',

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              : FlutterMap(
                  mapController:
                      _mapController,

                  options:
                      const MapOptions(
                    initialCenter:
                        ubicacionInicial,

                    initialZoom: 14,

                    minZoom: 5,

                    maxZoom: 19,
                  ),

                  children: [
                    // ==================================
                    // MAPA OPENSTREETMAP
                    // ==================================

                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                      userAgentPackageName:
                          'com.example.parqueoseguroapp',
                    ),

                    // ==================================
                    // MARCADORES
                    // ==================================

                    MarkerLayer(
                      markers:
                          construirMarcadores(),
                    ),
                  ],
                ),
    );
  }
}