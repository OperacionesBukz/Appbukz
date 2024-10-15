import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Importa el paquete para la cámara
import 'package:logging/logging.dart'; // Importa el paquete de logging


void main() {
  _setupLogging(); // Configura el logging
  runApp(const MyApp());
}

// Configura el logging globalmente
void _setupLogging() {
  Logger.root.level = Level.ALL; // Nivel de registro (puedes cambiarlo según tus necesidades)
  Logger.root.onRecord.listen((record) {
    // Imprime el log de forma estructurada
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  final Logger _logger = Logger('MyHomePage'); // Logger específico para esta clase
  final ImagePicker _picker = ImagePicker(); // Instancia del selector de imágenes
  XFile? _image; // Variable para almacenar la imagen capturada

  // Método para abrir la cámara y tomar una foto
  Future<void> openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _image = photo; // Guarda la imagen seleccionada
        });
        _logger.info('Imagen capturada con éxito: ${photo.path}');
      }
    } catch (e) {
      setState(() {
        _image = null;
      });
      _logger.severe('Error al acceder a la cámara: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/LOGOBUKZ1.png',
          height: 40, // Ajusta el tamaño del logo según sea necesario
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Resultado del escaneo:',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 10),
            _image != null
                ? Image.network(_image!.path) // Muestra la imagen capturada
                : const Text('No se ha tomado ninguna foto.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: openCamera, // Llama al método para abrir la cámara
              child: const Text('Abrir Cámara'),
            ),
          ],
        ),
      ),
    );
  }
}
