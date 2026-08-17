import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ZonasScreen extends StatefulWidget {
  final int idParqueadero;
  final String nombreParqueadero;

  const ZonasScreen({
    super.key,
    required this.idParqueadero,
    required this.nombreParqueadero,
  });

  @override
  State<ZonasScreen> createState() => _ZonasScreenState();
}

class _ZonasScreenState extends State<ZonasScreen> {
  List<dynamic> zonas = [];
  List<dynamic> vehiculos = [];

  bool cargando = true;

  // ==========================================
  // TARIFA POR HORA
  // ==========================================

  static const double tarifaPorHora = 1.50;

  // ==========================================
  // INICIALIZAR
  // ==========================================

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  // ==========================================
  // CARGAR ZONAS Y VEHÍCULOS
  // ==========================================

  Future<void> cargarDatos() async {
    try {
      final resultadoZonas =
          await ApiService.listarZonas();

      final resultadoVehiculos =
          await ApiService.listarVehiculos();

      final zonasParqueadero =
          resultadoZonas.where((zona) {
        return zona['parqueadero'] ==
            widget.idParqueadero;
      }).toList();

      if (!mounted) return;

      setState(() {
        zonas = zonasParqueadero;
        vehiculos = resultadoVehiculos;
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
  // CALCULAR HORAS
  // ==========================================

  double calcularHoras(
    TimeOfDay inicio,
    TimeOfDay fin,
  ) {
    final minutosInicio =
        inicio.hour * 60 + inicio.minute;

    final minutosFin =
        fin.hour * 60 + fin.minute;

    final diferencia =
        minutosFin - minutosInicio;

    if (diferencia <= 0) {
      return 0;
    }

    // Cada hora iniciada se cobra completa.
    return (diferencia / 60).ceilToDouble();
  }

  // ==========================================
  // MOSTRAR FORMULARIO DE RESERVA
  // ==========================================

  void mostrarFormularioReserva(
    Map<String, dynamic> zona,
  ) {
    // ==========================================
    // VERIFICAR DISPONIBILIDAD
    // ==========================================

    if (zona['estado'] != 'Disponible') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Esta zona no está disponible',
          ),
        ),
      );

      return;
    }

    // ==========================================
    // VERIFICAR VEHÍCULOS
    // ==========================================

    if (vehiculos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Primero debes registrar un vehículo',
          ),
        ),
      );

      return;
    }

    // ==========================================
    // VARIABLES DEL FORMULARIO
    // ==========================================

    int? vehiculoSeleccionado;

    DateTime fechaSeleccionada =
        DateTime.now();

    TimeOfDay horaInicio =
        const TimeOfDay(
      hour: 8,
      minute: 0,
    );

    TimeOfDay horaFin =
        const TimeOfDay(
      hour: 9,
      minute: 0,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            dialogContext,
            setDialogState,
          ) {
            // ==================================
            // CALCULAR HORAS
            // ==================================

            final horas = calcularHoras(
              horaInicio,
              horaFin,
            );

            // ==================================
            // CALCULAR TOTAL
            // ==================================

            final double montoTotal =
                horas * tarifaPorHora;

            return AlertDialog(
              title: Text(
                'Reservar ${zona['codigo']}',
              ),

              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    // ==========================
                    // VEHÍCULO
                    // ==========================

                    DropdownButtonFormField<int>(
                      decoration:
                          const InputDecoration(
                        labelText: 'Vehículo',
                        border:
                            OutlineInputBorder(),
                      ),

                      initialValue:
                          vehiculoSeleccionado,

                      items:
                          vehiculos.map(
                        (vehiculo) {
                          return DropdownMenuItem<
                              int>(
                            value:
                                vehiculo['id'],

                            child: Text(
                              '${vehiculo['placa']} - '
                              '${vehiculo['marca_modelo']}',
                            ),
                          );
                        },
                      ).toList(),

                      onChanged: (valor) {
                        setDialogState(() {
                          vehiculoSeleccionado =
                              valor;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // ==========================
                    // FECHA
                    // ==========================

                    ListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      title: const Text(
                        'Fecha de reserva',
                      ),

                      subtitle: Text(
                        '${fechaSeleccionada.day}/'
                        '${fechaSeleccionada.month}/'
                        '${fechaSeleccionada.year}',
                      ),

                      trailing:
                          const Icon(
                        Icons.calendar_today,
                      ),

                      onTap: () async {
                        final fecha =
                            await showDatePicker(
                          context:
                              dialogContext,

                          initialDate:
                              fechaSeleccionada,

                          firstDate:
                              DateTime.now(),

                          lastDate:
                              DateTime.now().add(
                            const Duration(
                              days: 365,
                            ),
                          ),
                        );

                        if (fecha != null) {
                          setDialogState(() {
                            fechaSeleccionada =
                                fecha;
                          });
                        }
                      },
                    ),

                    // ==========================
                    // HORA INICIO
                    // ==========================

                    ListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      title: const Text(
                        'Hora de inicio',
                      ),

                      subtitle: Text(
                        horaInicio.format(
                          dialogContext,
                        ),
                      ),

                      trailing:
                          const Icon(
                        Icons.access_time,
                      ),

                      onTap: () async {
                        final hora =
                            await showTimePicker(
                          context:
                              dialogContext,

                          initialTime:
                              horaInicio,
                        );

                        if (hora != null) {
                          setDialogState(() {
                            horaInicio = hora;
                          });
                        }
                      },
                    ),

                    // ==========================
                    // HORA FIN
                    // ==========================

                    ListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      title: const Text(
                        'Hora de fin',
                      ),

                      subtitle: Text(
                        horaFin.format(
                          dialogContext,
                        ),
                      ),

                      trailing:
                          const Icon(
                        Icons.access_time,
                      ),

                      onTap: () async {
                        final hora =
                            await showTimePicker(
                          context:
                              dialogContext,

                          initialTime:
                              horaFin,
                        );

                        if (hora != null) {
                          setDialogState(() {
                            horaFin = hora;
                          });
                        }
                      },
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // ==========================
                    // RESUMEN DEL COSTO
                    // ==========================

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        14,
                      ),

                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),

                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Duración: '
                            '${horas.toStringAsFixed(0)} '
                            'hora(s)',
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            'Tarifa: '
                            '\$${tarifaPorHora.toStringAsFixed(2)}'
                            '/hora',
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            'Monto total: '
                            '\$${montoTotal.toStringAsFixed(2)}',

                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================
              // BOTONES
              // ==================================

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },

                  child: const Text(
                    'Cancelar',
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    // ==========================
                    // VALIDAR VEHÍCULO
                    // ==========================

                    if (vehiculoSeleccionado ==
                        null) {
                      ScaffoldMessenger.of(
                        dialogContext,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Selecciona un vehículo',
                          ),
                        ),
                      );

                      return;
                    }

                    // ==========================
                    // VALIDAR HORARIO
                    // ==========================

                    final horas =
                        calcularHoras(
                      horaInicio,
                      horaFin,
                    );

                    if (horas <= 0) {
                      ScaffoldMessenger.of(
                        dialogContext,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'La hora de fin debe ser '
                            'posterior a la hora de inicio',
                          ),
                        ),
                      );

                      return;
                    }

                    // ==========================
                    // FORMATO FECHA
                    // ==========================

                    final fecha =
                        '${fechaSeleccionada.year}-'
                        '${fechaSeleccionada.month.toString().padLeft(2, '0')}-'
                        '${fechaSeleccionada.day.toString().padLeft(2, '0')}';

                    // ==========================
                    // FORMATO HORA INICIO
                    // ==========================

                    final inicio =
                        '${horaInicio.hour.toString().padLeft(2, '0')}:'
                        '${horaInicio.minute.toString().padLeft(2, '0')}:00';

                    // ==========================
                    // FORMATO HORA FIN
                    // ==========================

                    final fin =
                        '${horaFin.hour.toString().padLeft(2, '0')}:'
                        '${horaFin.minute.toString().padLeft(2, '0')}:00';

                    // ==========================
                    // CALCULAR TOTAL
                    // ==========================

                    final total =
                        horas * tarifaPorHora;

                    // ==================================
                    // REFERENCIAS ANTES DEL AWAIT
                    // ==================================

                    final messenger =
                        ScaffoldMessenger.of(
                      context,
                    );

                    final navigator =
                        Navigator.of(
                      dialogContext,
                    );

                    // ==========================
                    // CREAR RESERVA
                    // ==========================

                    try {
                      await ApiService.crearReserva(
                        idVehiculo:
                            vehiculoSeleccionado!,

                        idZona:
                            zona['id'],

                        fechaReserva:
                            fecha,

                        horaInicio:
                            inicio,

                        horaFin:
                            fin,

                        montoTotal:
                            total,
                      );

                      if (!mounted) {
                        return;
                      }

                      // ==========================
                      // CERRAR FORMULARIO
                      // ==========================

                      navigator.pop();

                      // ==========================
                      // RECARGAR ZONAS
                      // ==========================

                      await cargarDatos();

                      if (!mounted) {
                        return;
                      }

                      // ==========================
                      // MOSTRAR MENSAJE
                      // ==========================

                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Reserva creada correctamente. '
                            'La zona ahora está ocupada.',
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) {
                        return;
                      }

                      messenger.showSnackBar(
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
                  },

                  child: const Text(
                    'RESERVAR',
                  ),
                ),
              ],
            );
          },
        );
      },
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
          'Zonas disponibles',
        ),
      ),

      body: cargando
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : zonas.isEmpty
              ? const Center(
                  child: Text(
                    'No hay zonas registradas '
                    'para este parqueadero',

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: cargarDatos,

                  child: ListView.builder(
                    padding:
                        const EdgeInsets.all(16),

                    itemCount:
                        zonas.length,

                    itemBuilder:
                        (context, index) {
                      final zona =
                          zonas[index];

                      final bool disponible =
                          zona['estado'] ==
                              'Disponible';

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: ListTile(
                          // ==========================
                          // SOLO DISPONIBLES
                          // ==========================

                          onTap: disponible
                              ? () {
                                  mostrarFormularioReserva(
                                    zona,
                                  );
                                }
                              : null,

                          // ==========================
                          // ICONO
                          // ==========================

                          leading: Icon(
                            disponible
                                ? Icons.local_parking
                                : Icons.block,

                            size: 40,

                            color: disponible
                                ? Colors.green
                                : Colors.red,
                          ),

                          // ==========================
                          // PLAZA
                          // ==========================

                          title: Text(
                            'Plaza ${zona['codigo']}',

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          // ==========================
                          // ESTADO
                          // ==========================

                          subtitle: Text(
                            'Estado: '
                            '${zona['estado']}',
                          ),

                          // ==========================
                          // ICONO DERECHO
                          // ==========================

                          trailing: disponible
                              ? const Icon(
                                  Icons
                                      .arrow_forward_ios,
                                )
                              : const Icon(
                                  Icons.lock,
                                  color:
                                      Colors.red,
                                ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}