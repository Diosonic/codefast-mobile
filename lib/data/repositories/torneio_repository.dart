import 'dart:convert';

import 'package:codefast/data/http/http_client.dart';
import 'package:codefast/data/models/torneio_model.dart';

abstract class ITorneioRepository {
  Future<List<TorneioModel>> getTorneio();
}

class TorneioRepository implements ITorneioRepository {
  final IHttpClient client;

  TorneioRepository({required this.client});

  @override
  Future<List<TorneioModel>> getTorneio() async {
    final response = await client.get(url: 'http://localhost:5165/torneio');

    if (response.statusCode == 200) {
      final List<TorneioModel> torneios = [];

      final body = jsonDecode(response.body);

      body.map((item) {
        final TorneioModel torneio = TorneioModel.fromMap(item);
        torneios.add(torneio);
      }).toList();

      return torneios;
    } else if (response.statusCode == 404) {
        throw Exception('Nenhum torneio encontrado');
    } else {
      throw Exception("Não foi possível carregar os torneios");
    }
  }
}
