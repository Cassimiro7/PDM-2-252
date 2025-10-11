// iot_server.dart
// Servidor que recebe leituras de temperatura via TCP socket
import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  final host = InternetAddress.loopbackIPv4;
  final port = 4567;
  final server = await ServerSocket.bind(host, port);
  print('Servidor IOT ouvindo em ${host.address}:$port');
  server.listen((Socket client) {
    print('Conexão de ${client.remoteAddress.address}:${client.remotePort}');
    // corrigido: usar bind em vez de transform(utf8.decoder) para evitar erro de tipos
    utf8.decoder
        .bind(client)
        .transform(const LineSplitter())
        .listen((line) {
      try {
        final data = jsonDecode(line);
        final device = data['deviceId'] ?? 'unknown';
        final temp = data['temperature'];
        final ts = data['timestamp'];
        print('[${DateTime.now().toIso8601String()}] Recebido do $device -> temperatura: $temp °C (timestamp: $ts)');
      } catch (e) {
        print('Erro ao parsear: $e — linha: $line');
      }
    }, onDone: () {
      print('Conexão fechada: ${client.remoteAddress.address}:${client.remotePort}');
      client.destroy();
    }, onError: (err) {
      print('Erro na conexão: $err');
      client.destroy();
    });
  });
}
