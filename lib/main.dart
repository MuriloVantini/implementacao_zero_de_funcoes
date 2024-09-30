import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Implementação de Cálculo Numérico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 22, 195, 140)),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Colors.red)),
          focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          focusedErrorBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Colors.red[700]!, strokeAlign: 2.0)),
        ),
      ),
      home: const MyHomePage(title: 'Zero de Funções'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController x0Controller = TextEditingController();
  TextEditingController x1Controller = TextEditingController();
  TextEditingController erroController = TextEditingController();
  String result = '';

  double secante(Function f, double x0, double x1, {double tol = 1e-5, int maxIter = 100}) {
    double f0 = f(x0);
    double f1 = f(x1);

    for (int i = 0; i < maxIter; i++) {
      if ((f1 - f0).abs() < tol) {
        return double.nan; // Divisão por zero iminente
      }

      double x2 = x1 - f1 * (x1 - x0) / (f1 - f0); // Fórmula da secante

      if ((x2 - x1).abs() < tol) {
        return x2; // Encontrou a raiz dentro da tolerância
      }

      x0 = x1;
      f0 = f1;
      x1 = x2;
      f1 = f(x1);
    }
    return double.nan; // Não convergiu
  }

  void _calculateRoot() {
    final double x0 = double.parse(x0Controller.text);
    final double x1 = double.parse(x1Controller.text);
    final double tol = double.parse(erroController.text);

    // Função seno f(x) = sin(x)
    double f(double x) => sin(x);

    // Chamando o método da secante com os valores fornecidos pelo usuário
    double raiz = secante(f, x0, x1, tol: tol);

    setState(() {
      if (raiz.isNaN) {
        result = 'Não foi possível encontrar a raiz.';
      } else {
        result = 'Resultado: $raiz';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: x0Controller,
                decoration: const InputDecoration(labelText: 'Valor inicial (x1)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um valor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: x1Controller,
                decoration: const InputDecoration(labelText: 'Valor final (x2)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um valor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: erroController,
                decoration: const InputDecoration(labelText: 'Tolerância'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um valor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(result, style: Theme.of(context).textTheme.headlineSmall)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _calculateRoot;
          }
        },
        tooltip: 'Calcular',
        child: const Icon(Icons.send),
      ),
    );
  }
}
