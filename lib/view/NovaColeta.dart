import 'package:app_pistola/view/login.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovaColeta extends StatefulWidget {
  @override
  _NovaColetaState createState() => _NovaColetaState();
}

class _NovaColetaState extends State<NovaColeta> {

  DateTime value = DateTime.now();
  ProgressDialog load;
  String token;
  String host;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      );
    load.style(
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      message: "Aguarde..."
    );
    verificaHost();
    getLojas();
  }
  @override
  Widget build(BuildContext context) {

    final format = DateFormat("dd/MM/yyyy");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Nova Coleta"),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Data da coleta"),
              DateTimeField(
                format: format,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                onChanged: (date) => setState(() {
                  value = date;
                }),
                onSaved: (date) => setState(() {
                  value = date;
                }),
              ),
              Divider(),
              Text("Loja"),
              DropdownButton(
                items: <DropdownMenuItem>[
                  DropdownMenuItem(
                    child: Text("Um"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Dois"),
                    value: 2,
                  )
                ],
                onChanged: (value) {},
                )
            ],
          ),
        ),
      ),
    );
  }

  /*BUSCANDO O TOKEN*/
  void getToken() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String t = pref.getString("token");
    if(token != null){
      setState(() {
        token = t;
      });
    }else{
      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Login()));
    }
  }
  
  /*BUSCANDO O HOST*/
  void verificaHost() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String h = pref.getString("host");
    setState(() {
      host = h;
    });
  }

  /*BUSCANDO AS LOJAS*/
  void getLojas() async{
    //Load
    load.show();
    //Buscando o token
    getToken();
    Dio dio = new Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    String url = "https://destakpe.gsisoft.com.br/rest.php?class=LojaRestService&method=getLojas";
    print(url);
    try{
      var response = await dio.get(url);
      if(response.statusCode == 200){
        print(response.toString());
      }else{
        print("Erro");
      }
    }catch (e){

    }
    
  }
}
