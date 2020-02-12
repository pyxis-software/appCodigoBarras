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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bool load = true;
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
    print(user);
    String password = _controllerPassword.text;
    Future<Autenticate> aut = fetchPost(user, password);
  }

  //Load da página
  

  //Verifica se existe o host salvo
  void verificaHost(){
    //Sharepreferences
    
    SharedPreferences pref = await
  }
}

Future<Autenticate> fetchPost(String user, String password) async {
  String url = 'http://destakpe.gsisoft.com.br/auth/'+ user +'/'+ password;
  final response = await http.get(url,
    headers: {
      HttpHeaders.authorizationHeader: "e068ae3b97a36f345a398a0d41d9f603bf9c96db1950035e52ec930a42b4"}
  );
  final responseJson = json.decode(response.body);
  print(responseJson);

  return Autenticate.fromJson(responseJson);
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