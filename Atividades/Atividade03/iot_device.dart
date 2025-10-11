// iot_device.dart
// Dispositivo que simula leituras de temperatura e as envia a cada 10s para o servidor
import 'dart:io';
import 'dart:convert';
import 'dart:math';

Future<void> main(List<String> args) async {
  final host = InternetAddress.loopbackIPv4.address;
  final port = 4567;
  final deviceId = args.isNotEmpty ? args[0] : 'device-01';
  final rng = Random();
  print('Dispositivo $deviceId iniciando. Enviando leituras para $host:$port a cada 10s...');
  try {
    final socket = await Socket.connect(host, port);
    socket.done.then((_) => print('Conexão encerrada pelo servidor.'));
    while (true) {
      final temp = (rng.nextDouble() * 15) + 15; // 15..30
      final payload = {
        'deviceId': deviceId,
        'temperature': double.parse(temp.toStringAsFixed(2)),
        'timestamp': DateTime.now().toIso8601String(),
      };
      final line = jsonEncode(payload);
      socket.writeln(line); // adiciona newline para o servidor separar
      print('[${DateTime.now().toIso8601String()}] Enviado: $line');
      await Future.delayed(Duration(seconds: 10));
    }
  } catch (e) {
    print('Erro conectando ao servidor: $e');
  }
}
