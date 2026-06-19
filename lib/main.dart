import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Aplicación de Pagos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormularioPagoScreen(),
    );
  }
}

class FormularioPagoScreen extends StatefulWidget {
  const FormularioPagoScreen({super.key});

  @override
  State<FormularioPagoScreen> createState() =>
      _FormularioPagoScreenState();
}

class _FormularioPagoScreenState
    extends State<FormularioPagoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _productoCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _titularCtrl = TextEditingController();
  final _tarjetaCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _productoCtrl.dispose();
    _totalCtrl.dispose();
    _titularCtrl.dispose();
    _tarjetaCtrl.dispose();
    _fechaCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> registrarPagoEnFirebase({
    required String producto,
    required double total,
    required String titular,
    required String tarjeta,
    required String estado,
  }) async {
    try {
      debugPrint("Guardando pago...");

      await FirebaseFirestore.instance
          .collection('pagos_simulados')
          .add({
        'producto': producto,
        'total': total,
        'titular': titular,
        'ultimos4': tarjeta.length >= 4
            ? tarjeta.substring(tarjeta.length - 4)
            : tarjeta,
        'estado': estado,
        'fecha': FieldValue.serverTimestamp(),
      });

      debugPrint("Pago guardado correctamente");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Pago registrado correctamente'),
        ),
      );

      _productoCtrl.clear();
      _totalCtrl.clear();
      _titularCtrl.clear();
      _tarjetaCtrl.clear();
      _fechaCtrl.clear();
      _cvvCtrl.clear();
    } catch (e) {
      debugPrint("ERROR FIREBASE: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al guardar: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _productoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese el producto';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _totalCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Monto Total',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el monto';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Monto inválido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _titularCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Titular',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _tarjetaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de Tarjeta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }

                  if (!RegExp(r'^\d{16,}$').hasMatch(value)) {
                    return 'Debe tener mínimo 16 dígitos';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fechaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'MM/AA',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatorio';
                        }

                        if (!RegExp(r'^\d{2}/\d{2}$')
                            .hasMatch(value)) {
                          return 'MM/AA';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatorio';
                        }

                        if (!RegExp(r'^\d{3}$')
                            .hasMatch(value)) {
                          return '3 dígitos';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  debugPrint("Botón presionado");

                  if (!_formKey.currentState!.validate()) {
                    debugPrint("Formulario inválido");
                    return;
                  }

                  debugPrint("Formulario válido");

                  await registrarPagoEnFirebase(
                    producto: _productoCtrl.text.trim(),
                    total: double.parse(
                      _totalCtrl.text.trim(),
                    ),
                    titular: _titularCtrl.text.trim(),
                    tarjeta: _tarjetaCtrl.text.trim(),
                    estado: 'Completado',
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: Text(
                    'Procesar Pago',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}