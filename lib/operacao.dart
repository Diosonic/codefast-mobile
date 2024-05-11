import 'dart:convert';
import 'package:codefast/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Operacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Receber os argumentos passados para a rota
    final Map<String, dynamic>? data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Verificar se os dados são válidos
    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Dados inválidos'),
        ),
      );
    }

    // Extrair o nome e outras informações do post
    final String title = data['title'];
    final String body = data['body'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                  Navigator.pushNamed(context, '/operacao-eliminatoria');
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
                  Navigator.pushNamed(context, '/operacao-mata-mata');
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

class OperacaoEliminatoria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operação Eliminatória'),
      ),
      body: Center(
        child: Text('Conteúdo da Operação Eliminatória'),
      ),
    );
  }
}

class OperacaoMataMata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operação Mata-Mata'),
      ),
      body: Center(
        child: Text('Conteúdo da Operação Mata-Mata'),
      ),
    );
  }
}
