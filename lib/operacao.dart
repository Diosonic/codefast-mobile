import 'package:codefast/data/models/torneio_model.dart';
import 'package:codefast/operacao_eliminatoria.dart';
import 'package:codefast/operacao_mata_mata.dart';
import 'package:flutter/material.dart';

class OperacaoTorneio extends StatelessWidget {
  final TorneioModel torneio;

  OperacaoTorneio({required this.torneio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(torneio.titulo),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OperacaoEliminatoria(torneio: torneio),
                    ),
                  );
                },
                icon: Icon(Icons.access_alarms),
                label: Text('Eliminatória'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Ajuste o valor conforme necessário
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OperacaoMataMata(torneio: torneio),
                    ),
                  );
                },
                icon: Icon(Icons.account_tree_outlined),
                label: Text('Mata-Mata'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Ajuste o valor conforme necessário
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class OperacaoMataMata extends StatelessWidget {
//   final TorneioModel torneio;

//   OperacaoMataMata({required this.torneio});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Operação Mata-Mata'),
//       ),
//       body: Center(
//         child: Text('Conteúdo da Operação Mata-Mata'),
//       ),
//     );
//   }
// }
