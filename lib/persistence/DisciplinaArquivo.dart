import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class DisciplinaArquivo {
  Future<File> _criarArquivo() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/disciplina.json");
  }

  Future<String> readDisciplina() async {
    try {
      final file = await _criarArquivo();
      return file.readAsString();
    } catch (e) {
      return "Erro ao ler arquivo";
    }
  }

  Future<File> saveDisciplina(List atividadeList) async {
    String data = json.encode(atividadeList);
    final file = await _criarArquivo();
    return file.writeAsString(data);
  }
}
