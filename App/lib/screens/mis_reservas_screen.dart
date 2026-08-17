import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});

  @override
  State<MisReservasScreen> createState() =>
      _MisReservasScreenState();
}

class _MisReservasScreenState
    extends State<MisReservasScreen> {
  List<dynamic> reservas = [];

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarReservas();
  }

  // ==========================================
  // CARGAR RESERVAS
  // ==========================================

  Future<void> cargarReservas() async {
    try {
      final resultado =
          await ApiService.listarReservas();

      if (!mounted) return;

      setState(() {
        reservas = resultado;
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
  // CANCELAR RESERVA
  // ==========================================

  Future<void> cancelarReserva(
    int idReserva,
  ) async {
    // ------------------------------------------
    // CONFIRMAR CANCELACIÓN
    // ------------------------------------------

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Cancelar reserva',
          ),

          content: const Text(
            '¿Estás seguro de que deseas cancelar '
            'esta reserva?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'NO',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'SÍ, CANCELAR',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    // ------------------------------------------
    // CANCELAR EN EL BACKEND
    // ------------------------------------------

    try {
      await ApiService.cancelarReserva(
        idReserva,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Reserva cancelada correctamente',
          ),
        ),
      );

      // ----------------------------------------
      // VOLVER A CARGAR LAS RESERVAS
      // ----------------------------------------

      await cargarReservas();
    } catch (e) {
      if (!mounted) return;

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
  // CONSTRUIR TARJETA DE RESERVA
  // ==========================================

  Widget construirReserva(
    Map<String, dynamic> reserva,
  ) {
    final vehiculo =
        reserva['vehiculo'] ?? {};

    final zona =
        reserva['zona'] ?? {};

    final int idReserva =
        reserva['id'];

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================
            // ENCABEZADO
            // ==================================

            Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  size: 30,
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: Text(
                    'Reserva #$idReserva',
                    style:
                        const TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(),

            // ==================================
            // VEHÍCULO
            // ==================================

            ListTile(
              contentPadding:
                  EdgeInsets.zero,

              leading: const Icon(
                Icons.directions_car,
              ),

              title: const Text(
                'Vehículo',
              ),

              subtitle: Text(
                '${vehiculo['placa'] ?? 'Sin placa'}'
                ' - '
                '${vehiculo['marca_modelo'] ?? 'Sin modelo'}',
              ),
            ),

            // ==================================
            // PLAZA
            // ==================================

            ListTile(
              contentPadding:
                  EdgeInsets.zero,

              leading: const Icon(
                Icons.local_parking,
              ),

              title: const Text(
                'Plaza',
              ),

              subtitle: Text(
                zona['codigo_plaza'] ??
                    'Sin plaza',
              ),
            ),

            // ==================================
            // ESTADO
            // ==================================

            ListTile(
              contentPadding:
                  EdgeInsets.zero,

              leading: Icon(
                Icons.lock,
                color: Colors.red,
              ),

              title: const Text(
                'Estado',
              ),

              subtitle: Text(
                zona['estado'] ??
                    'Ocupado',
              ),
            ),

            // ==================================
            // FECHA
            // ==================================

            ListTile(
              contentPadding:
                  EdgeInsets.zero,

              leading: const Icon(
                Icons.calendar_today,
              ),

              title: const Text(
                'Fecha de reserva',
              ),

              subtitle: Text(
                reserva['fecha'] ??
                    'Sin fecha',
              ),
            ),

            // ==================================
            // HORARIO
            // ==================================

            ListTile(
              contentPadding:
                  EdgeInsets.zero,

              leading: const Icon(
                Icons.access_time,
              ),

              title: const Text(
                'Horario',
              ),

              subtitle: Text(
                '${reserva['hora_inicio'] ?? ''}'
                ' - '
                '${reserva['hora_fin'] ?? ''}',
              ),
            ),

            // ==================================
            // TOTAL
            // ==================================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(12),

              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(8),

                border: Border.all(
                  color: Colors.grey,
                ),
              ),

              child: Text(
                'Total: \$${reserva['total'] ?? '0.00'}',

                style:
                    const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            // ==================================
            // CANCELAR
            // ==================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  cancelarReserva(
                    idReserva,
                  );
                },

                icon: const Icon(
                  Icons.cancel,
                ),

                label: const Text(
                  'CANCELAR RESERVA',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // INTERFAZ
  // ==========================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis reservas',
        ),
      ),

      body: cargando

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : reservas.isEmpty

              ? RefreshIndicator(
                  onRefresh:
                      cargarReservas,

                  child: ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),

                    children: const [
                      SizedBox(
                        height: 180,
                      ),

                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons
                                  .event_busy,
                              size: 60,
                            ),

                            SizedBox(
                              height: 15,
                            ),

                            Text(
                              'No tienes reservas',
                              style:
                                  TextStyle(
                                fontSize:
                                    18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )

              : RefreshIndicator(
                  onRefresh:
                      cargarReservas,

                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    itemCount:
                        reservas.length,

                    itemBuilder:
                        (context, index) {
                      final reserva =
                          reservas[index]
                              as Map<String,
                                  dynamic>;

                      return construirReserva(
                        reserva,
                      );
                    },
                  ),
                ),
    );
  }
}