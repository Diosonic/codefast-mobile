import 'dart:convert';
import 'package:codefast/data/http/http_client.dart';
import 'package:codefast/data/models/controle_mata_mata_model.dart';
import 'package:codefast/data/models/torneio_model.dart';
import 'package:codefast/data/repositories/operacao_mata_mata_repository.dart';
import 'package:codefast/data/store/controle_mata_mata_store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperacaoMataMata extends StatefulWidget {
  final TorneioModel torneio;

  OperacaoMataMata({required this.torneio});

  @override
  _OperacaoMataMataState createState() => _OperacaoMataMataState();
}

class _OperacaoMataMataState extends State<OperacaoMataMata> {
  final ControleMataMataStore store = ControleMataMataStore(
      repository: ControleMataMataRepository(client: HttpClient()));

  @override
  void initState() {
    super.initState();
    store.getControleMataMata();
  }

  Future<void> _comecarRodada() async {
    try {
      final response = await http.put(
          Uri.parse(
              'http://localhost:5165/OperacaoMataMata/1/iniciarRodada'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getControleMataMata();
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
        store.getControleMataMata();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _finalizarEtapa() async {
    try {
      final response = await http.put(
          Uri.parse(
              'http://localhost:5165/OperacaoMataMata/1/finalizarEtapaMataMata'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getControleMataMata();
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
          Uri.parse('http://localhost:5165/OperacaoMataMata/$id/equipes'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'statusValidacao': 'Validando',
          }));
      if (response.statusCode == 200) {
        store.getControleMataMata();
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

  void _modalDeNovaRodada() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nova rodada"),
          content: Text('Deseja começar uma nova rodada?'),
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
                await _comecarRodada();
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void _modalDeFinalizarRodada() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Finalizar rodada"),
          content: Text('Deseja finalizar a rodada?'),
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
                await _finalizarRodada();
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void _modalDeFinalizarEtapa() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Finalizar etapa"),
          content: Text('Deseja finalizar a etapa?'),
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
                await _finalizarEtapa();
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
            tooltip: 'Começar rodada',
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(height: 16), // Espaçamento entre os botões
          FloatingActionButton(
            onPressed: () {
              _modalDeFinalizarRodada();
            },
            tooltip: 'Finalizar rodada',
            child: Icon(Icons.stop),
          ),
          SizedBox(height: 16), // Espaçamento entre os botões
          FloatingActionButton(
            onPressed: () {
              _modalDeFinalizarEtapa();
            },
            tooltip: 'Finalizar etapa',
            child: Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
