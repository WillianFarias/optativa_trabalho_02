class Disciplina {
  final int _codigo;
  final String _descricao;
  final int _cargaHoraria;

  Disciplina(this._codigo, this._descricao, this._cargaHoraria);

  int get codigo => _codigo;
  String get descricao => _descricao;
  int get cargaHoraria => _cargaHoraria;

  @override
  String toString() {
    String teste = getCargaHoraria();
    return "$_descricao ($_cargaHoraria h/a - $teste h)";
  }

  String getCargaHoraria() {
    double cargaHoraria = _cargaHoraria * 50 / 60;
    return cargaHoraria.toStringAsFixed(2);
  }

  Map<String, dynamic> getDisciplina() {
    Map<String, dynamic> disciplina = Map();
    disciplina["codigo"] = _codigo;
    disciplina["descricao"] = _descricao;
    disciplina["cargaHoraria"] = _cargaHoraria;
    return disciplina;
  }
}
