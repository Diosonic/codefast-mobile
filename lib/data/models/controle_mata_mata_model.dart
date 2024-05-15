class EquipeModel {
  final int id;
  final String nome;

  EquipeModel({required this.id, required this.nome});

  factory EquipeModel.fromMap(Map<String, dynamic> map) {
    return EquipeModel(
      id: map['id'],
      nome: map['nome'],
    );
  }
}

class ControleMataMataModel {
  final int id;
  final String statusValidacao;
  final EquipeModel equipe;

  ControleMataMataModel({
    required this.id,
    required this.statusValidacao,
    required this.equipe,
  });

  factory ControleMataMataModel.fromMap(Map<String, dynamic> map) {
    return ControleMataMataModel(
      id: map['id'],
      statusValidacao: map['statusValidacao'],
      equipe: EquipeModel.fromMap(map['equipe']),
    );
  }
}
