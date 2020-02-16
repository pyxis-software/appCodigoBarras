import 'dart:async';
import 'package:app_pistola/view/configuracao.dart';
import 'package:app_pistola/view/inicial.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    verificaAuth();
    carregando = true;
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Verifique a sua conexão",
          style: TextStyle(fontSize: 25, color: Colors.redAccent)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Sair"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Configurações"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //
  Future<Autenticate> fetchPost(String user, String password) async {

    //Verifica se o host já foi salvo
    if(host == null){
      //Envio o cliente para a página de configuração do host
      Navigator.push(context,  MaterialPageRoute(builder: (context) => Configuracao()));
    }else{

    }

    String url = 'http://destakpe.gsisoft.com.br/auth/teste/123456';
    Dio dio = new Dio();
    dio.options.headers = {
      'Authorization': 'Basic e068ae3b97a36f345a398a0d41d9f603bf9c96db1950035e52ec930a42b4',
      'Content-Type' : 'application/json',
      'Accept': 'application/json',
    };
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioError e) async {
        errorConnection();
      }
    ));

    try{
      Response response = await dio.get(url);
      if(response.statusCode == 200){
        print('Ok');
        //imprime a resposta aqui
        print(response.toString());

        //Salva o Token
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("token", 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoidGVzdGUiLCJ1c2VyaWQiOiIzIiwidXNlcm5hbWUiOiJUZXN0ZSBEZXNlbnZvbHZpbWVudG8iLCJ1c2VybWFpbCI6bnVsbCwiZXhwaXJlcyI6MTU4MTYzODQxNn0.bwFb0hlQmCuSyG0OfYklaqDLU1vKmn0qoa4-DjtApoQ');
        pref.setBool("auth", true);

        //Envia o usuário para a página inicial
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => TelaInicial()));
      }else{
        errorConnection();
      }
    }catch (e){
      errorConnection();
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