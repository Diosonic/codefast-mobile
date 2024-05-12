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

class ControleEliminatoriaModel {
  final int id;
  final String statusValidacao;
  final EquipeModel equipe;

  ControleEliminatoriaModel({
    required this.id,
    required this.statusValidacao,
    required this.equipe,
  });

  factory ControleEliminatoriaModel.fromMap(Map<String, dynamic> map) {
    return ControleEliminatoriaModel(
      id: map['id'],
      statusValidacao: map['statusValidacao'],
      equipe: EquipeModel.fromMap(map['equipe']),
    );
  }
}
