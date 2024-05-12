import 'dart:convert';

import 'package:codefast/data/http/http_client.dart';
import 'package:codefast/data/models/controle_eliminatoria_model.dart';

abstract class IControleEliminatoriaRepository {
  Future<List<ControleEliminatoriaModel>> getControleEliminatoria();
}

class ControleEliminatoriaRepository
    implements IControleEliminatoriaRepository {
  final IHttpClient client;

  ControleEliminatoriaRepository({required this.client});

  @override
  Future<List<ControleEliminatoriaModel>> getControleEliminatoria() async {
    final response = await client.get(
        url: 'http://localhost:5165/ControleEliminatoria/1/equipes');

    if (response.statusCode == 200) {
      final List<ControleEliminatoriaModel> controleEliminatorias = [];

      final body = jsonDecode(response.body);

      body.map((item) {
        final ControleEliminatoriaModel controleEliminatoria =
            ControleEliminatoriaModel.fromMap(item);
        controleEliminatorias.add(controleEliminatoria);
      }).toList();

      return controleEliminatorias;
    } else if (response.statusCode == 404) {
      throw Exception('Nenhum torneio encontrado');
    } else {
      throw Exception("Não foi possível carregar os torneios");
    }
  }
}
