import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Importa la librería para escaneo automático
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
      title: 'Escáner ISBN Automático',
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
  String barcodeResult = "No se ha escaneado ningún código"; // Estado del código escaneado

  // Método que maneja el escaneo de códigos en tiempo real
  void _onDetect(BarcodeCapture barcodeCapture) {
    final String code = barcodeCapture.barcodes.first.rawValue ?? 'No se detectó un código';
    setState(() {
      barcodeResult = "Código escaneado: $code";
    });
    _logger.info('Código escaneado con éxito: $code');
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              onDetect: _onDetect, // Escanea el código automáticamente
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                barcodeResult, // Muestra el código escaneado en tiempo real
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
