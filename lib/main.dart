import 'dart:convert';

import 'package:codefast/data/models/torneio_model.dart';
import 'package:codefast/homepage.dart';
import 'package:codefast/operacao.dart';
import 'package:codefast/operacao_eliminatoria.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codefast - Operação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Codefast - Operação'),

        '/operacao': (context) => OperacaoTorneio(
            torneio:
                ModalRoute.of(context)?.settings.arguments as TorneioModel),

        '/operacao-eliminatoria': (context) => OperacaoEliminatoria(
            torneio: ModalRoute.of(context)?.settings.arguments
                as TorneioModel), // Adicione a rota para OperacaoEliminatoria

        '/operacao-mata-mata': (context) => OperacaoMataMata(
            torneio: ModalRoute.of(context)?.settings.arguments
                as TorneioModel), // Adicione a rota para OperacaoEliminatoria
      },
    );
  }
}
