import 'dart:convert';

import 'package:codefast/data/http/http_client.dart';
import 'package:codefast/data/models/controle_mata_mata_model.dart';

abstract class IOperacaoMataMataRepository {
  Future<List<ControleMataMataModel>> getOperacaoMataMata();
}

class OperacaoMataMataRepository implements IOperacaoMataMataRepository {
  final IHttpClient client;

  OperacaoMataMataRepository({required this.client});

  @override
  Future<List<ControleMataMataModel>> getOperacaoMataMata() async {
    final response = await client.get(
        url: 'http://localhost:5165/OperacaoMataMata/1/equipes');

    if (response.statusCode == 200) {
      final List<ControleMataMataModel> operacaoMataMata = [];

      final body = jsonDecode(response.body);

      body.map((item) {
        final ControleMataMataModel operacao =
            ControleMataMataModel.fromMap(item);
        operacaoMataMata.add(operacao);
      }).toList();

      return operacaoMataMata;
    } else if (response.statusCode == 404) {
      throw Exception('Nenhum torneio encontrado');
    } else {
      throw Exception("Não foi possível carregar os torneios");
    }
  }
}
