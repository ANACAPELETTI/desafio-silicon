import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageNew createState() => _SecondPageNew(); //para utilizar o "setState"
}

class _SecondPageNew extends State<SecondPage> {
  String? _numDigitado; //pode ser nulo
  late final DatabaseReference _numberRef;
  late StreamSubscription<DatabaseEvent> _numberSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _numberRef = FirebaseDatabase.instance.ref('numero'); //objeto que será salvo no banco
    try {
      final numberSnapshot = await _numberRef.get();
      _numDigitado = numberSnapshot.value as String;
    } catch (err) {
      //debugPrint(err.toString()); //quando achar um erro ao pegar o número salvo no banco
    }
    //verificando/esperando as mudanças no banco
    _numberSubscription = _numberRef.onValue.listen((DatabaseEvent event) {
      if(mounted) {
        setState(() {
          _numDigitado = (event.snapshot.value ?? "Valor não encontrado") as String;
        });
      }
    });
  }
  
  save() async {
    //await _numberRef.set(ServerValue.increment(1.0));
    //await _numberRef.set(_numDigitado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Página"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_numDigitado ?? "Valor não encontrado",
                style: TextStyle(
                  fontSize: 40
                )),
          ],
        ),
      ),
    );
  }
}
