import 'dart:async';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:silicon_project/second.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageNew createState() => _FirstPageNew(); //para utilizar o "setState"
}

class _FirstPageNew extends State<FirstPage> {
  String? _numDigitado; //pode ser nulo
  late final DatabaseReference _numberRef;
  //late StreamSubscription<DatabaseEvent> _numberSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _numberRef = FirebaseDatabase.instance.ref('numero'); //objeto que será salvo no banco
    try {
      final numberSnapshot = await _numberRef.get();
      //_numDigitado = numberSnapshot.value as String;
    } catch (err) {
      //debugPrint(err.toString()); //quando achar um erro ao pegar o número salvo no banco
    }
    //verificando/esperando as mudanças no banco
    /*_numberSubscription = _numberRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _numDigitado = (event.snapshot.value ?? 0) as String;
      });
    });*/
  }

  save() async {
    await _numberRef.set(_numDigitado);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Primeira Página"),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Insira o número'),
                    content: Form(
                      //key: _formKey,
                      child: TextFormField(
                        onChanged: (value) {
                          if(mounted) {
                            setState(() {
                              _numDigitado = value.toString();
                            });
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Adicione o número',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16))
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) return null;
                          return 'Campo inválido';
                        },
                      ),
                    ),
                    actions: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                          ),
                          onPressed: () {
                            save();
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => SecondPage()));
                          },
                          icon: const Icon(Icons.save),
                          label: Text('Adicionar')
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel),
                          label: Text('Cancelar')
                      )
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.save)
          ),
        ],
      ),
    );
  }
}
