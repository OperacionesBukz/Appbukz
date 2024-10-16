import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Importa la librería para escaneo automático
import 'package:logging/logging.dart'; // Importa logging para registrar eventos
import 'dart:io'; // Para verificar plataforma

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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Clave del QRView
  QRViewController? controller; // Controlador para QRView

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Método que maneja el escaneo de códigos en tiempo real
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    // Escuchar el flujo de datos escaneados y filtrar solo códigos de barras EAN-13
    controller.scannedDataStream.listen((scanData) {
      // Filtrar solo códigos del formato EAN-13 (ISBN-13)
      if (scanData.format == BarcodeFormat.ean13) {
        setState(() {
          barcodeResult = "Código escaneado: ${scanData.code}";
        });
        _logger.info('Código escaneado con éxito: ${scanData.code}');
      } else {
        setState(() {
          barcodeResult = "Formato no soportado: ${scanData.format}";
        });
        _logger.warning('Se detectó un formato no soportado: ${scanData.format}');
      }
    });
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
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
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
