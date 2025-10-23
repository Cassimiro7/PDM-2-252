// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'iot_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // GlobalKey para mostrar SnackBars sem depender do BuildContext do State
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _deviceController = TextEditingController(text: 'android-001');
  final TextEditingController _serverController = TextEditingController(text: '10.10.0.118'); // troque conforme sua rede
  final TextEditingController _portController = TextEditingController(text: '4567');

  bool _running = false;
  IoTClient? _client;

  @override
  void dispose() {
    _deviceController.dispose();
    _serverController.dispose();
    _portController.dispose();
    // Se o seu IoTClient tiver método de parada, chame aqui (ex.: _client?.stop();)
    super.dispose();
  }

  void _showSnack(String msg) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _startClient() async {
    final rawServer = _serverController.text.trim();
    final rawPort = _portController.text.trim();

    String serverIp = rawServer;
    int port = 4567;

    // Suporta entrada "host:port" caso o usuário coloque assim
    if (rawServer.contains(':')) {
      final parts = rawServer.split(':');
      serverIp = parts[0];
      if (parts.length > 1) {
        final p = int.tryParse(parts[1]);
        if (p != null) port = p;
      }
    } else {
      final p = int.tryParse(rawPort);
      if (p != null) port = p;
    }

    final deviceId = _deviceController.text.trim();
    if (deviceId.isEmpty || serverIp.isEmpty) {
      _showSnack('Preencha Device ID e Server IP corretamente.');
      return;
    }

    _client = IoTClient(deviceId: deviceId, serverIp: serverIp, port: port);

    _showSnack('Conectando a $serverIp:$port ...');
    print('Tentando conectar: device=$deviceId server=$serverIp port=$port');

    try {
      // Timeout evita travar indefinidamente
      await _client!.start().timeout(const Duration(seconds: 10));
      if (!mounted) return;
      setState(() => _running = true);
      _showSnack('Conectado — enviando leituras');
      print('IoTClient.start() retornou com sucesso');
    } on TimeoutException {
      print('Timeout ao conectar ao servidor $serverIp:$port');
      _showSnack('Tempo de conexão esgotado (timeout)');
    } catch (e, s) {
      print('Erro ao iniciar IoTClient: $e\n$s');
      _showSnack('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Device',
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('IoT Device - Simulador')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text('Clique para iniciar o envio de leituras a cada 10s.'),
              const SizedBox(height: 20),
              TextField(
                controller: _deviceController,
                decoration: const InputDecoration(labelText: 'Device ID'),
                enabled: !_running,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _serverController,
                decoration: const InputDecoration(
                  labelText: 'Server IP (ex: 192.168.0.100 or 192.168.0.100:4567)',
                ),
                enabled: !_running,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'Porta (ex: 4567)'),
                keyboardType: TextInputType.number,
                enabled: !_running,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _running ? null : () => _startClient(),
                child: Text(_running ? 'Enviando...' : 'Iniciar IoT'),
              ),
              const SizedBox(height: 12),
              // Dica visual / debug
              Text(
                _running ? 'Status: Enviando leituras' : 'Status: Inativo',
                style: TextStyle(color: _running ? Colors.green : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
