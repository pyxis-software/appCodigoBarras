import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Configuracao extends StatefulWidget {
  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {

  final _controllerHost =  TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Configuração'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                autocorrect: true,
                showCursor: true,
                controller: _controllerHost,
                keyboardType: TextInputType.text,
                style: new TextStyle(color: Colors.redAccent, fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Host",
                  labelStyle: TextStyle(color: Colors.red)
                ),
              ),
              Divider( height: 20),
              ButtonTheme(
                height: 60.0,
                child: RaisedButton(
                  onPressed: () => actionSalvar(),
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void actionSalvar(){
    print("Salva");
  }
}