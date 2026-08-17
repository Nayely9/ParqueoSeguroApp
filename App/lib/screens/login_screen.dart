import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool cargando = false;

  Future<void> iniciarSesion() async {
    final email = emailController.text.trim();
    final contrasena = passwordController.text;

    if (email.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresa tu correo y contraseña',
          ),
        ),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final respuesta = await ApiService.login(
        email,
        contrasena,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
     context,
  MaterialPageRoute(
    builder: (context) => HomeScreen(
      usuario: respuesta['usuario'],
    ),
  ),
);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParqueoSeguroApp'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Icon(
                  Icons.local_parking,
                  size: 90,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Bienvenido a ParqueoSeguroApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Inicia sesión para gestionar tus reservas',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: cargando ? null : iniciarSesion,

                    child: cargando
                        ? const CircularProgressIndicator()
                        : const Text(
                            'INICIAR SESIÓN',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}