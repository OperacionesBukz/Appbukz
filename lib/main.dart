import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart'; // Librería de escaneo de códigos
import 'package:logging/logging.dart'; // Logging para eventos

void main() {
  _setupLogging(); // Configura logging globalmente
  runApp(const MyApp());
}

// Configura logging global
void _setupLogging() {
  Logger.root.level = Level.ALL; // Configura el nivel de logging
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escáner ISBN',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFF1E800), // Color del botón
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF1E800), // Color del AppBar
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Logger _logger = Logger('MyHomePage'); // Logger para esta clase
  String barcode = "No se ha escaneado ningún código"; // Estado del código escaneado

  // Método para iniciar el escaneo de código de barras
  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan(); // Escanea el código
      setState(() {
        barcode = result.rawContent.isNotEmpty
            ? "Código ISBN: ${result.rawContent}"
            : "No se detectó ningún código";
      });
      _logger.info('Código escaneado: $barcode');
    } catch (e) {
      setState(() {
        barcode = "Error en el escaneo: $e";
      });
      _logger.severe('Error durante el escaneo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/LOGOBUKZ1.png',
          height: 40, // Tamaño del logo
        ),
        centerTitle: true, // Centra el logo en el AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              barcode, // Muestra el resultado del escaneo
              style: const TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode, // Inicia el escaneo al presionar
              child: const Text('Escanear Código ISBN'),
            ),
          ],
        ),
      ),
    );
  }
}
