import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracao extends StatefulWidget {
  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {

  final _controllerHost =  TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaHost();
  }


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

  //Busca o host salvo
  void buscaHost() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String h = pref.getString('host');
    if(h != null){
      setState(() {
        _controllerHost.text = h;
      });
    }
  }

  void actionSalvar() async {
    String campo = _controllerHost.text;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('host', campo);
  }
}