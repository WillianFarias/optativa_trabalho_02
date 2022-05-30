import 'package:flutter/material.dart';
import 'package:trabalho_willian_farias/model/Disciplina.dart';
import 'dart:convert';
import 'package:trabalho_willian_farias/persistence/DisciplinaArquivo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? _ultimoRemovido;
  int? _ultimoRemovidoPos;

  DisciplinaArquivo disciplinaArquivo = DisciplinaArquivo();
  List _disciplinaList = [];

  TextEditingController _disciplinaController = TextEditingController();
  TextEditingController _cargaHorariaController = TextEditingController();
  TextEditingController _codigoController = TextEditingController();

  //Carrega disciplinas
  @override
  void initState() {
    super.initState();
    disciplinaArquivo.readDisciplina().then((dado) {
      setState(() {
        _disciplinaList = json.decode(dado);
      });
    });
  }

  void _inserir() {
    setState(() {
      _disciplinaList.insert(
          0,
          new Disciplina(
              int.parse(_codigoController.text),
              _disciplinaController.text,
              int.parse(_cargaHorariaController.text)));
    });
    disciplinaArquivo.saveDisciplina(_disciplinaList);
    _limparFormulario();
  }

  _limparFormulario() {
    _disciplinaController.text = "";
    _cargaHorariaController.text = "";
    _codigoController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Disciplinas"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _limparFormulario,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _codigoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Código',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _disciplinaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Disciplina',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _cargaHorariaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Carga horária',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _inserir,
            child: Text("Inserir"),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _disciplinaList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  margin: EdgeInsets.all(2.0),
                  color: _disciplinaList[index].cargaHoraria >= 40
                      ? Colors.blue[400]
                      : _disciplinaList[index].cargaHoraria >= 30
                          ? Colors.blue[100]
                          : Colors.grey,
                  child: Center(
                    child: Text(
                      "${_disciplinaList[index]}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_disciplinaList[index]["nome"]),
        value: true,
        secondary: CircleAvatar(
          child: Icon(
              _disciplinaList[index]["concluida"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _disciplinaList[index]["concluida"] = true;
            disciplinaArquivo.saveDisciplina(_disciplinaList);
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _ultimoRemovido = Map.from(_disciplinaList[index]);
          _ultimoRemovidoPos = index;
          _disciplinaList.removeAt(index);
          disciplinaArquivo.saveDisciplina(_disciplinaList);
          final snack = SnackBar(
            content:
                Text("Disciplina \"${_ultimoRemovido!["nome"]}\"removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _disciplinaList.insert(
                        _ultimoRemovidoPos!, _ultimoRemovido);
                    disciplinaArquivo.saveDisciplina(_disciplinaList);
                  });
                }),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
  }
}
