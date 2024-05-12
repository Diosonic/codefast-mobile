import 'package:codefast/data/models/controle_eliminatoria_model.dart';
import 'package:codefast/data/repositories/controle_eliminatoria_repository.dart';
import 'package:flutter/material.dart';

class ControleEliminatoriaStore {
  final IControleEliminatoriaRepository repository;

  // variável retiva para loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // variável retiva para state
  final ValueNotifier<List<ControleEliminatoriaModel>> state =
      ValueNotifier<List<ControleEliminatoriaModel>>([]);

  // variável retiva para erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  ControleEliminatoriaStore({required this.repository});

  Future getControleEliminatoria() async {
    isLoading.value = true;

    try {
      final result = await repository.getControleEliminatoria();
      state.value = result;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
