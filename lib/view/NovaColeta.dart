import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovaColeta extends StatefulWidget {
  @override
  _NovaColetaState createState() => _NovaColetaState();
}

class _NovaColetaState extends State<NovaColeta> {

  DateTime value = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            ],
          ),
        ),
      ),
    );
  }
}
