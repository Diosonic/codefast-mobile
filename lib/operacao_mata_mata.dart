import 'dart:convert';
import 'package:codefast/data/http/http_client.dart';
import 'package:codefast/data/models/controle_mata_mata_model.dart';
import 'package:codefast/data/models/torneio_model.dart';
import 'package:codefast/data/repositories/controle_mata_mata_repository.dart';
import 'package:codefast/data/store/controle_mata_mata.store.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperacaoMataMata extends StatefulWidget {
  final TorneioModel torneio;

  OperacaoMataMata({required this.torneio});

  @override
  _OperacaoMataMataState createState() => _OperacaoMataMataState();
}

class _OperacaoMataMataState extends State<OperacaoMataMata> {
  final OperacaoMataMataStore store = OperacaoMataMataStore(
      repository: OperacaoMataMataRepository(client: HttpClient()));

  @override
  void initState() {
    super.initState();
    store.getOperacaoMataMata();
  }

  Future<void> _formarNovasChaves() async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://codefast-api-uninassau.azurewebsites.net/ControleMataMata/1/preparar-etapa-mata-mata'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getOperacaoMataMata();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _finalizarRodada() async {
    try {
      final response = await http.put(
          Uri.parse(
              'https://codefast-api-uninassau.azurewebsites.net/OperacaoMataMata/1/finalizarRodadaAtual'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getOperacaoMataMata();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _alterarStatusValidacao(int id) async {
    try {
      final response = await http.put(
          Uri.parse(
              'https://codefast-api-uninassau.azurewebsites.net/ControleMataMata/$id/alterar-status-validacao'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'statusValidacao': 'Validando',
          }));
      if (response.statusCode == 200) {
        store.getOperacaoMataMata();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _desclassificarEquipe(int id) async {
    try {
      final response = await http.put(
          Uri.parse(
              'https://codefast-api-uninassau.azurewebsites.net/ControleMataMata/$id/desclassificar-equipe'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'statusValidacao': 'Validando',
          }));
      if (response.statusCode == 200) {
        store.getOperacaoMataMata();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  void _showConfirmationDialog(ControleMataMataModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmação"),
          content: Text(
              'Deseja atualizar o status da equipe ${item.equipe.nome}? para "validando"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _alterarStatusValidacao(item.id);
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void _modalDesclassificacao(ControleMataMataModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Desclassificação"),
          content: Text('Deseja desclassificar a equipe ${item.equipe.nome}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _desclassificarEquipe(item.id);
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void _modalDeNovaRodada() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nova chave"),
          content: Text('Deseja formar uma nova chave?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _formarNovasChaves();
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operação mata-mata'),
      ),
      body: Container(
        color: Colors.grey[200],
        child: AnimatedBuilder(
          animation: Listenable.merge([store.isLoading]),
          builder: (context, child) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              padding: EdgeInsets.all(4),
              itemCount: store.state.value.length,
              itemBuilder: (_, index) {
                final item = store.state.value[index];
                return GestureDetector(
                  onTap: () {
                    _showConfirmationDialog(item);
                  },
                  onLongPress: () {
                    _modalDesclassificacao(item);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4), // Reduzido o padding interno aqui
                      child: Center(
                        child: Text(
                          item.equipe.nome,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _modalDeNovaRodada();
            },
            tooltip: 'Montar nova chave',
            child: Icon(Icons.play_arrow),
          )
        ],
      ),
    );
  }
}
