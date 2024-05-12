import 'package:codefast/data/models/torneio_model.dart';
import 'package:codefast/data/repositories/torneio_repository.dart';
import 'package:flutter/material.dart';

class TorneioStore {
  final ITorneioRepository repository;

  // variável retiva para loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // variável retiva para state
  final ValueNotifier<List<TorneioModel>> state =
      ValueNotifier<List<TorneioModel>>([]);

  // variável retiva para erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  TorneioStore({required this.repository});

  Future getTorneios() async {
    isLoading.value = true;

    try {
      final result = await repository.getTorneio();
      state.value = result;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
