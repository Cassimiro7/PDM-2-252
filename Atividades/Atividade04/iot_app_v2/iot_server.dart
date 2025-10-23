// iot_server.dart
import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  final host = InternetAddress.anyIPv4; // aceita conexões de rede local
  final port = 4567;
  final server = await ServerSocket.bind(host, port);
  print('Servidor IOT ouvindo em ${host.address}:$port');
  server.listen((Socket client) {
    print('Conexão de ${client.remoteAddress.address}:${client.remotePort}');
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
