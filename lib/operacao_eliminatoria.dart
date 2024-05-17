import 'dart:convert';
import 'package:codefast/data/http/http_client.dart';
import 'package:codefast/data/models/controle_eliminatoria_model.dart';
import 'package:codefast/data/models/torneio_model.dart';
import 'package:codefast/data/repositories/controle_eliminatoria_repository.dart';
import 'package:codefast/data/store/controle_eliminatoria_store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperacaoEliminatoria extends StatefulWidget {
  final TorneioModel torneio;

  OperacaoEliminatoria({required this.torneio});

  @override
  _OperacaoEliminatoriaState createState() => _OperacaoEliminatoriaState();
}

class _OperacaoEliminatoriaState extends State<OperacaoEliminatoria> {
  final ControleEliminatoriaStore store = ControleEliminatoriaStore(
      repository: ControleEliminatoriaRepository(client: HttpClient()));

  @override
  void initState() {
    super.initState();
    store.getControleEliminatoria();
  }

  Future<void> _comecarRodada() async {
    try {
      final response = await http.put(
          Uri.parse(
              'http://localhost:5165/ControleEliminatoria/1/iniciarRodada'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getControleEliminatoria();
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
              'http://localhost:5165/ControleEliminatoria/1/finalizarRodadaAtual'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getControleEliminatoria();
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
              'http://localhost:5165/ControleEliminatoria/1/finalizarEtapaEliminatoria'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        store.getControleEliminatoria();
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
          Uri.parse('http://localhost:5165/ControleEliminatoria/$id/equipes'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'statusValidacao': 'Validando',
          }));
      if (response.statusCode == 200) {
        store.getControleEliminatoria();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  void _showConfirmationDialog(ControleEliminatoriaModel item) {
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
          title: Text("Fianlizar rodada"),
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

  void modalDeFinalizarEtapa() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nova etapa"),
          content: Text('Deseja começar uma nova etapa?'),
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
        title: const Text('Operação eliminatória'),
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
              modalDeFinalizarEtapa();
            },
            tooltip: 'Finalizar etapa',
            child:
                Icon(Icons.check), // Alterado para o ícone de finalizar etapa
          ),
        ],
      ),
    );
  }
}
