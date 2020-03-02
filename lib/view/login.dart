import 'dart:async';
import 'dart:convert';
import 'package:app_pistola/view/configuracao.dart';
import 'package:app_pistola/view/inicial.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //Minhas variáveis
  ProgressDialog load;
  ProgressDialog erro;
  String host;
  bool carregando = true;
  String token = "";
  Dio dio = new Dio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Minhas variáveis
    load = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false
    );
    erro = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true
    );
    verificaAuth();
    carregando = true;
    load.style(
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      message: "Aguarde...",
    );
    erro.style(
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      message: "Você esta sem internet!",
    );
    
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
                autocorrect: true,
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

  //Verifica se existe o host salvo
  void verificaHost() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String h = pref.getString("host");
    setState(() {
      host = h;
    });
  }

  //Mensagem de campos vazios
  void _showDialogVazios() {
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

  //Mensagem de erro de conexão
  void errorConnection(){
    if(load.isShowing()){
      load.hide();
    }
    erro.show();
  }

  //
  Future<Autenticate> fetchPost(String user, String password) async {
    load.show();
    //Verifica se o host já foi salvo
    if(host == null){
      //Envio o cliente para a página de configuração do host
      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Configuracao()));
    }

    //Criando a string da URL
    String url = "http://$host/auth/$user/$password";

    var data = jsonEncode({ 'login': user, 'password' : password} );
    
    try{
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          //body: body
      );
      if(response.statusCode == 200){
        print('Ok');
        //imprime a resposta aqui
        var jsonData = json.decode(response.body);
        print(jsonData);

        //Salva o Token
        //SharedPreferences pref = await SharedPreferences.getInstance();
        //pref.setString("token", 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoidGVzdGUiLCJ1c2VyaWQiOiIzIiwidXNlcm5hbWUiOiJUZXN0ZSBEZXNlbnZvbHZpbWVudG8iLCJ1c2VybWFpbCI6bnVsbCwiZXhwaXJlcyI6MTU4Mjg2NjQwM30.FO-bq8OV_dv7kDuQneat-FYDzJ4PjAvxyBabAxPkPFQ');
        //pref.setBool("auth", true);

        //Envia o usuário para a página inicial
        //Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => TelaInicial()));
      }else{
        //errorConnection();
      }
    }catch (e){
      //errorConnection();
    }
  }

  void  verificaAuth() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool ativo = pref.getBool("auth");
    if(ativo != null){
      if(ativo){
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => TelaInicial()));
      }
    }else{
      pref.setBool("auth", false);
    }
    
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