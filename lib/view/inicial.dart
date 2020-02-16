import 'package:app_pistola/view/NovaColeta.dart';
import 'package:app_pistola/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Bem Vindo!'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                actionExit();
              },
            ),
          ]
        ),
      ),
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Menu'),
          actions: <Widget>[
            // action button
            
          ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ButtonTheme(
                height: 40.0,
                child: RaisedButton(
                  onPressed: () =>{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NovaColeta()))
                  },
                  child: Text(
                    "Nova Coleta",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.redAccent,
                ),
              ),
              ButtonTheme(
                height: 40.0,
                child: RaisedButton(
                  onPressed: () =>{print("Ok")},
                  child: Text(
                    "Excluir Coleta",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.redAccent,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              ButtonTheme(
                height: 40.0,
                child: RaisedButton(
                  onPressed: () =>{print("Ok")},
                  child: Text(
                    "Coletar Dados",
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


  /*FUNCTIONS*/
  void actionExit(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Deseja mesmo sair?",
          style: TextStyle(fontSize: 25, color: Colors.redAccent)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Sair"),
              onPressed: () {
                Navigator.of(context).pop();
                exit();
              },
            ),
          ],
        );
      },
    );
  }

  //Exit
  void exit() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("auth", false);
    pref.setString("token", null);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }
  /*FUNCTIONS*/
}