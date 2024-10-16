import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Paquete para escaneo de QR y códigos de barras
import 'dart:io'; // Para verificar la plataforma

void main() {
  runApp(const MyApp());
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
  String barcodeResult = "No se ha escaneado ningún código"; // Estado del código escaneado
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Clave del QRView
  QRViewController? controller; // Controlador para QRView

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Método que maneja el escaneo de códigos en tiempo real
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    // Escuchar el flujo de datos escaneados
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        barcodeResult = "Código escaneado: ${scanData.code}";
      });
    });

    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escáner de Códigos de Barras"),
        centerTitle: true, // Centra el título en el AppBar
      ),
      body: Column(
        children: <Widget>[
          // QRView que se encarga de mostrar la vista previa de la cámara y escanear códigos
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape( // Añadir una forma de overlay
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300, // Tamaño del área de escaneo
              ),
            ),
          ),
          // Resultado del código escaneado
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
