import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Importa la librería para escaneo automático
import 'package:logging/logging.dart'; // Importa logging para registrar eventos
import 'dart:io'; // Para verificar plataforma
import 'package:permission_handler/permission_handler.dart'; // Para manejar permisos de cámara

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
  String barcodeResult = "No se ha escaneado ningún código"; // Estado del código escaneado
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Clave del QRView
  QRViewController? controller; // Controlador para QRView
  bool isCameraInitialized = false; // Variable para verificar si la cámara se inicializó correctamente

  @override
  void initState() {
    super.initState();
    _askCameraPermission(); // Pedir permiso de cámara en tiempo de ejecución
  }

  Future<void> _askCameraPermission() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      setState(() {
        barcodeResult = "Permiso de cámara denegado";
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble(); // Llamamos al método padre como es requerido por @mustCallSuper
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

    // Verificar si la cámara se inicializa correctamente
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        barcodeResult = "Código escaneado: ${scanData.code}";
      });
    });

    controller.getSystemFeatures().then((value) {
      if (value.hasFlash) {
        debugPrint("La cámara tiene flash");
      }
    });

    controller.resumeCamera().then((_) {
      setState(() {
        isCameraInitialized = true;
      });
    }).catchError((error) {
      setState(() {
        barcodeResult = "Error al inicializar la cámara: $error";
      });
    });
  }

  @override
  Widget build(BuildContext context) { // Implementación obligatoria del método build()
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
          if (!isCameraInitialized)
            const Center(child: CircularProgressIndicator())
          else
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
