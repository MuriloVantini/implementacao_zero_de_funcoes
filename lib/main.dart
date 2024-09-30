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
  TextEditingController aController = TextEditingController();
  TextEditingController bController = TextEditingController();
  TextEditingController cController = TextEditingController();
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

  void get _calculateRoot {
    final double a = double.parse(aController.text);
    final double b = double.parse(bController.text);
    final double c = double.parse(cController.text);

    // Definindo a função quadrática f(x) = Ax^2 + Bx + C
    double f(double x) => a * pow(x, 2) + b * x + c;

    // Usando aproximações iniciais
    double raiz = secante(f, 0.0, 1.0);

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
                controller: aController,
                decoration: const InputDecoration(labelText: 'Valor de A'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um valor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: bController,
                decoration: const InputDecoration(labelText: 'Valor de B'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um valor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: cController,
                decoration: const InputDecoration(labelText: 'Valor de C'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
