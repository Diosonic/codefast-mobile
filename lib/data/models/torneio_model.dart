class TorneioModel {
  final int id;
  final String titulo;

  TorneioModel({required this.id, required this.titulo});

  factory TorneioModel.fromMap(Map<String, dynamic> map) {
    return TorneioModel(
      id: map['id'],
      titulo: map['titulo'],
    );
  }
}
