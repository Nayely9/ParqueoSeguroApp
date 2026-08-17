import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  List<dynamic> vehiculos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarVehiculos();
  }

  // ============================================================
  // CARGAR VEHÍCULOS
  // ============================================================

  Future<void> cargarVehiculos() async {
    try {
      final resultado = await ApiService.listarVehiculos();

      if (!mounted) return;

      setState(() {
        vehiculos = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      final mensaje = e.toString().replaceFirst(
        'Exception: ',
        '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    }
  }

  // ============================================================
  // FORMULARIO AGREGAR / EDITAR
  // ============================================================

  void mostrarFormulario({
    Map<String, dynamic>? vehiculo,
  }) {
    final placaController = TextEditingController(
      text: vehiculo?['placa'] ?? '',
    );

    final marcaController = TextEditingController(
      text: vehiculo?['marca_modelo'] ?? '',
    );

    final bool editando = vehiculo != null;

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool guardando = false;

        return StatefulBuilder(
          builder: (
            dialogContext,
            setDialogState,
          ) {
            return AlertDialog(
              title: Text(
                editando
                    ? 'Editar vehículo'
                    : 'Agregar vehículo',
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ==================================================
                  // PLACA
                  // ==================================================

                  TextField(
                    controller: placaController,
                    textCapitalization:
                        TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Placa',
                      prefixIcon: Icon(
                        Icons.confirmation_number,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================================================
                  // MARCA Y MODELO
                  // ==================================================

                  TextField(
                    controller: marcaController,
                    decoration: const InputDecoration(
                      labelText: 'Marca y modelo',
                      prefixIcon: Icon(
                        Icons.directions_car,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              actions: [
                // ==================================================
                // CANCELAR
                // ==================================================

                TextButton(
                  onPressed: guardando
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('Cancelar'),
                ),

                // ==================================================
                // GUARDAR
                // ==================================================

                ElevatedButton(
                  onPressed: guardando
                      ? null
                      : () async {
                          final placa =
                              placaController.text.trim();

                          final marca =
                              marcaController.text.trim();

                          // ------------------------------------------
                          // VALIDAR CAMPOS
                          // ------------------------------------------

                          if (placa.isEmpty ||
                              marca.isEmpty) {
                            ScaffoldMessenger.of(
                              dialogContext,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Completa todos los campos',
                                ),
                              ),
                            );

                            return;
                          }

                          // ------------------------------------------
                          // GUARDAR REFERENCIAS ANTES DEL AWAIT
                          // ------------------------------------------

                          final navigator =
                              Navigator.of(dialogContext);

                          final messenger =
                              ScaffoldMessenger.of(context);

                          setDialogState(() {
                            guardando = true;
                          });

                          try {
                            // ----------------------------------------
                            // ACTUALIZAR
                            // ----------------------------------------

                            if (editando) {
                              final idVehiculo =
                                  vehiculo['id'];

                              await ApiService
                                  .actualizarVehiculo(
                                idVehiculo,
                                placa,
                                marca,
                              );
                            }

                            // ----------------------------------------
                            // CREAR
                            // ----------------------------------------

                            else {
                              await ApiService.crearVehiculo(
                                placa,
                                marca,
                              );
                            }

                            // ----------------------------------------
                            // COMPROBAR PANTALLA
                            // ----------------------------------------

                            if (!mounted) return;

                            // ----------------------------------------
                            // CERRAR DIÁLOGO
                            // ----------------------------------------

                            navigator.pop();

                            // ----------------------------------------
                            // RECARGAR VEHÍCULOS
                            // ----------------------------------------

                            await cargarVehiculos();

                            if (!mounted) return;

                            // ----------------------------------------
                            // MENSAJE
                            // ----------------------------------------

                            final mensaje = editando
                                ? 'Vehículo actualizado correctamente'
                                : 'Vehículo registrado correctamente';

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(mensaje),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;

                            final mensaje = e
                                .toString()
                                .replaceFirst(
                                  'Exception: ',
                                  '',
                                );

                            // Cerramos el diálogo mediante
                            // NavigatorState guardado antes
                            // del await.

                            navigator.pop();

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(mensaje),
                              ),
                            );
                          }
                        },
                  child: guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          editando
                              ? 'Guardar'
                              : 'Agregar',
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ELIMINAR VEHÍCULO
  // ============================================================

  Future<void> eliminarVehiculo(
    Map<String, dynamic> vehiculo,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Eliminar vehículo',
          ),

          content: Text(
            '¿Deseas eliminar el vehículo '
            '${vehiculo['placa']}?',
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
                'Cancelar',
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
                'Eliminar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {
      final idVehiculo = vehiculo['id'];

      await ApiService.eliminarVehiculo(
        idVehiculo,
      );

      if (!mounted) return;

      await cargarVehiculos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vehículo eliminado correctamente',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst(
        'Exception: ',
        '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    }
  }

  // ============================================================
  // INTERFAZ
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis vehículos',
        ),
      ),

      body: cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : vehiculos.isEmpty
              ? _pantallaSinVehiculos()
              : _listaVehiculos(),

      floatingActionButton: vehiculos.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                mostrarFormulario();
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
    );
  }

  // ============================================================
  // PANTALLA SIN VEHÍCULOS
  // ============================================================

  Widget _pantallaSinVehiculos() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: 80,
              color: Colors.grey,
            ),

            const SizedBox(height: 20),

            const Text(
              'No tienes vehículos registrados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Agrega tu primer vehículo para '
              'poder realizar reservas.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                mostrarFormulario();
              },
              icon: const Icon(
                Icons.add,
              ),
              label: const Text(
                'Agregar vehículo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LISTA DE VEHÍCULOS
  // ============================================================

  Widget _listaVehiculos() {
    return RefreshIndicator(
      onRefresh: cargarVehiculos,

      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehiculos.length,

        itemBuilder: (context, index) {
          final vehiculo = vehiculos[index];

          return Card(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),

            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.directions_car,
                ),
              ),

              title: Text(
                vehiculo['marca_modelo'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                'Placa: ${vehiculo['placa'] ?? ''}',
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ----------------------------------------------
                  // EDITAR
                  // ----------------------------------------------

                  IconButton(
                    tooltip: 'Editar',
                    icon: const Icon(
                      Icons.edit,
                    ),
                    onPressed: () {
                      mostrarFormulario(
                        vehiculo: vehiculo,
                      );
                    },
                  ),

                  // ----------------------------------------------
                  // ELIMINAR
                  // ----------------------------------------------

                  IconButton(
                    tooltip: 'Eliminar',
                    icon: const Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      eliminarVehiculo(
                        vehiculo,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}