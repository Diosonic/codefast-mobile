import 'dart:convert';

import 'package:codefast/homepage.dart';
import 'package:codefast/operacao.dart';
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
        '/operacao': (context) => Operacao(),
        '/operacao-eliminatoria': (context) =>
            OperacaoEliminatoria(), // Adicione a rota para OperacaoEliminatoria
        '/operacao-mata-mata': (context) =>
            OperacaoMataMata(), // Adicione a rota para OperacaoEliminatoriaF
      },
    );
  }
}
