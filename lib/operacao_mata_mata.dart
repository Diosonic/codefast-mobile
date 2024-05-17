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
              'http://localhost:5165/ControleMataMata/1/preparar-etapa-mata-mata'),
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
              'http://localhost:5165/OperacaoMataMata/1/finalizarRodadaAtual'),
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
              'http://localhost:5165/ControleMataMata/$id/alterar-status-validacao'),
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
              'http://localhost:5165/ControleMataMata/$id/desclassificar-equipe'),
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

  Future<void> _transformarEquipeEmTerceiro(int id) async {
    try {
      final response = await http.put(
          Uri.parse(
              'http://localhost:5165/ControleMataMata/$id/disputar-terceiro-lugar'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'novaCondicao': 'TerceiroLugar',
          }));
      if (response.statusCode == 200) {
        store.getOperacaoMataMata();
      } else {
        throw Exception('Failed to transform team to third place');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _prepararDisputaTerceiroLugar() async {
    try {
      final response = await http.post(
          Uri.parse(
              'http://localhost:5165/ControleMataMata/1/preparar-disputa-terceiro-lugar'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getOperacaoMataMata();
      } else {
        throw Exception('Failed to prepare third place match');
      }
    } catch (error) {
      print(error);
    }
  }

  void _showDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
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
                    _showDialog(
                      title: "Confirmação",
                      content:
                          'Deseja atualizar o status da equipe ${item.equipe.nome}? para "validando"?',
                      onConfirm: () async {
                        await _alterarStatusValidacao(item.id);
                      },
                    );
                  },
                  onLongPress: () {
                    _showDialog(
                      title: "Desclassificação",
                      content:
                          'Deseja desclassificar a equipe ${item.equipe.nome}?',
                      onConfirm: () async {
                        await _desclassificarEquipe(item.id);
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.equipe.nome,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDialog(
                                      title: "Desclassificação",
                                      content:
                                          'Deseja desclassificar a equipe ${item.equipe.nome}?',
                                      onConfirm: () async {
                                        await _desclassificarEquipe(item.id);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.emoji_events,
                              color: Colors.amberAccent),
                          onPressed: () {
                            _showDialog(
                              title: "Transformar em Terceiro Lugar",
                              content:
                                  'Deseja transformar a equipe ${item.equipe.nome} em terceiro lugar?',
                              onConfirm: () async {
                                await _transformarEquipeEmTerceiro(item.id);
                              },
                            );
                          },
                        ),
                      ),
                    ],
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
              _showDialog(
                title: "Nova chave",
                content: 'Deseja formar uma nova chave?',
                onConfirm: () async {
                  await _formarNovasChaves();
                },
              );
            },
            tooltip: 'Montar nova chave',
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _showDialog(
                title: "Disputa Terceiro Lugar",
                content: 'Deseja preparar a disputa pelo terceiro lugar?',
                onConfirm: () async {
                  await _prepararDisputaTerceiroLugar();
                },
              );
            },
            tooltip: 'Preparar disputa terceiro lugar',
            child: Icon(Icons.military_tech),
          ),
        ],
      ),
    );
  }
}
