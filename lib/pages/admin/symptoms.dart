import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({Key? key}) : super(key: key);

  @override
  _SymptomsPageState createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  int textLength = 0;
  TextEditingController chronicController = TextEditingController();
  TextEditingController disease = TextEditingController();

  @override
  void dispose() {
    chronicController.dispose();
    disease.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Text('Symptoms'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Add Symptom',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        content: Form(
                          key: _key,
                          child: SizedBox(
                            height: 130,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty || value.toString() == '') {
                                      return 'Enter Symptom name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  textInputAction: TextInputAction.done,
                                  controller: chronicController,
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.emailAddress,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: 'Symptom',
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey[900]!, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22,),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty || value.toString() == '') {
                                      return 'Enter Disease name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  textInputAction: TextInputAction.done,
                                  controller: disease,
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: 'Disease',
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey[900]!, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                final data ={
                                  "symptome":chronicController.text.toString(),
                                  "disease":disease.text.toString()
                                };
                                FirebaseDatabase database =
                                    FirebaseDatabase.instance;
                                database
                                    .ref('Data')
                                    .child('Symp')
                                    .push()
                                    .set(data);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add))
          ]),
      body: FirebaseAnimatedList(
        query:
            FirebaseDatabase.instance.reference().child('Data').child('Symp'),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value;
          Map<String, dynamic> data = jsonDecode(jsonEncode(json));

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  trailing: InkWell(
                      onTap: (){
                        FirebaseDatabase.instance.ref('Data').child('Symp').child(snapshot.key.toString()).remove();
                      },
                      child: const Icon(Icons.delete)),
                  title: Text(data['symptome'].toString()),
                  subtitle: Text(data['disease'].toString()),
                ),
              ),
              const Divider()
            ],
          );
        },
      ),
    ));
  }
}
