import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_pistola/view/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //Minhas variáveis
  String host;
  bool carregando = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Minhas variáveis
    carregando = true;
    load(carregando);
    verificaHost();
  }

  final _controllerUser =  TextEditingController();
  final _controllerPassword =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Login'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.tune),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Configuracao()),);
              },
            ),
          ],
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
                controller: _controllerUser,
                keyboardType: TextInputType.text,
                style: new TextStyle(color: Colors.redAccent, fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Usuário",
                  labelStyle: TextStyle(color: Colors.red)
                ),
              ),
              Divider(),
              TextFormField(
                obscureText: true,
                controller: _controllerPassword,
                keyboardType: TextInputType.text,
                style: new TextStyle(color: Colors.redAccent, fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(color: Colors.red)
                ),
              ),
              Divider(height: 30.0),
              ButtonTheme(
                height: 60.0,
                child: RaisedButton(
                  onPressed: () => actionLogin(),
                  child: Text(
                    "Entrar",
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

  void actionLogin(){
    String user = _controllerUser.text;
    String password = _controllerPassword.text;
    if(user != "" && password != ""){
      Future<Autenticate> aut = fetchPost(user, password);
    }else{
      print('vazios');
      _showDialogVazios();
    }
  }

  //Load da página
  void load(bool ativo){
  }

  //Verifica se existe o host salvo
  void verificaHost() async{
    //Sharepreferences
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    String h = pref.getString("host");
    setState(() {
      host = h;
    });
  }
  //Mensagem de campos vazios
  void _showDialogVazios() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: new Text("Usuário ou senha incorreta!",
            style: TextStyle(fontSize: 25, color: Colors.redAccent)),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

  Future<Autenticate> fetchPost(String user, String password) async {
    String url = 'http://'+host +'/auth/'+ user +'/'+ password;

    Map<String, String> headers = new Map<String, String>();
    headers['Content-Type'] = "application/json";
    headers['Accept'] = "application/json";
    headers['Authorization'] = "Bearer e068ae3b97a36f345a398a0d41d9f603bf9c96db1950035e52ec930a42b4";
    print(url);
    final response = await http.get(url,
      headers: headers,
    );
    final responseJson = json.decode(response.body);
    print(responseJson);

    return Autenticate.fromJson(responseJson);
  }
}

class Autenticate {
  final int userId;
  final int id;
  final String title;
  final String body;

  Autenticate({this.userId, this.id, this.title, this.body});

  factory Autenticate.fromJson(Map<String, dynamic> json) {
    return Autenticate(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}