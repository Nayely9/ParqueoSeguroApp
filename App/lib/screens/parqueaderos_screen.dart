import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'zonas_screen.dart';

class ParqueaderosScreen extends StatefulWidget {
  const ParqueaderosScreen({super.key});

  @override
  State<ParqueaderosScreen> createState() => _ParqueaderosScreenState();
}

class _ParqueaderosScreenState extends State<ParqueaderosScreen> {
  List<dynamic> parqueaderos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarParqueaderos();
  }

  Future<void> cargarParqueaderos() async {
    try {
      final resultado = await ApiService.listarParqueaderos();

      if (!mounted) return;

      setState(() {
        parqueaderos = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parqueaderos'),
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : parqueaderos.isEmpty
              ? const Center(
                  child: Text(
                    'No hay parqueaderos registrados',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: parqueaderos.length,
                  itemBuilder: (context, index) {
                    final parqueadero = parqueaderos[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZonasScreen(
                                idParqueadero: parqueadero['id'],
                                nombreParqueadero:
                                    parqueadero['nombre'],
                              ),
                            ),
                          );
                        },

                        leading: const Icon(
                          Icons.local_parking,
                          size: 40,
                        ),

                        title: Text(
                          parqueadero['nombre'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),

                            Text(
                              'Dirección: ${parqueadero['direccion']}',
                            ),

                            Text(
                              'Capacidad: ${parqueadero['capacidad']}',
                            ),

                            Text(
                              'Tarifa por hora: \$${parqueadero['tarifa']}',
                            ),
                          ],
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}