// lib/iot_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

class IoTClient {
  final String deviceId;
  final String serverIp;
  final int port;
  Socket? _socket;
  Timer? _timer;
  final Random _rng = Random();

  IoTClient({required this.deviceId, required this.serverIp, required this.port});

  Future<void> start() async {
    _socket = await Socket.connect(serverIp, port, timeout: const Duration(seconds: 5));
    print('Conectado ao servidor: ${_socket!.remoteAddress.address}:$port');

    // opcional: ouvir mensagens do servidor
    utf8.decoder.bind(_socket!).listen((line) {
      print('Do servidor: $line');
    }, onError: (e) {
      print('Erro ao ler do servidor: $e');
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      final temperature = 15 + _rng.nextDouble() * 15; // 15..30
      final payload = {
        'deviceId': deviceId,
        'temperature': double.parse(temperature.toStringAsFixed(2)),
        'timestamp': DateTime.now().toIso8601String(),
      };
      final line = jsonEncode(payload);
      _socket!.writeln(line);
      print('[${DateTime.now().toIso8601String()}] Enviado: $line');
    });
  }

  Future<void> stop() async {
    _timer?.cancel();
    await _socket?.close();
    _socket = null;
  }
}
