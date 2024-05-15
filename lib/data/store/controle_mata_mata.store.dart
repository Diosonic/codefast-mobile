import 'package:codefast/data/models/controle_mata_mata_model.dart';
import 'package:codefast/data/repositories/operacao_mata_mata_repository.dart';
import 'package:flutter/material.dart';

class OperacaoMataMataStore {
  final IOperacaoMataMataRepository repository;

  // Variável relativa ao carregamento
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável relativa ao estado
  final ValueNotifier<List<ControleMataMataModel>> state =
      ValueNotifier<List<ControleMataMataModel>>([]);

  // Variável relativa ao erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  OperacaoMataMataStore({required this.repository});

  Future<void> getOperacaoMataMata() async {
    isLoading.value = true;

    try {
      final result = await repository.getOperacaoMataMata();
      state.value = result;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
