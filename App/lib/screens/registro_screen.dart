import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final contrasenaController = TextEditingController();
  final telefonoController = TextEditingController();

  bool cargando = false;

  Future<void> registrar() async {
    if (nombreController.text.isEmpty ||
        emailController.text.isEmpty ||
        contrasenaController.text.isEmpty ||
        telefonoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos'),
        ),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final resultado = await ApiService.registro(
        nombreController.text,
        emailController.text,
        contrasenaController.text,
        telefonoController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resultado['mensaje'] ?? 'Usuario registrado correctamente',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    contrasenaController.dispose();
    telefonoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.local_parking,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            const Text(
              'Crear cuenta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: cargando ? null : registrar,

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),

              child: cargando
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Crear cuenta',
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Ya tengo una cuenta',
              ),
            ),
          ],
        ),
      ),
    );
  }
}