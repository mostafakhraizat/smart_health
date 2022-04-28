import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';


class Replies extends StatefulWidget {
  const Replies({Key? key}) : super(key: key);

  @override
  _RepliesState createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  final GlobalKey<FormState> _key = GlobalKey();
  FirebaseDatabase database = FirebaseDatabase.instance;
  int textLength = 0;
  TextEditingController chronicController = TextEditingController();
  String doctor = "" ;
  TextEditingController disease = TextEditingController();

  @override
  void dispose() {
    chronicController.dispose();
    disease.dispose();
    super.dispose();
  }

  final query = FirebaseDatabase.instance.reference().child('Questions');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: const Text('My Questions'),
          ),
          body: FirebaseAnimatedList(
            query: query,
            itemBuilder: (context, snapshot, animation, index) {
              final json = snapshot.value;
              Map<String, dynamic> data = jsonDecode(jsonEncode(json));
              final auth = FirebaseAuth.instance;
              String uid = auth.currentUser!.uid.toString();


              if(data['reciever'] == uid){
                return Card(
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),),
                  elevation: 1,
                  color: Colors.blue.withOpacity(0.1),
                  child: RoundedExpansionTile(
                    trailing: const Icon(Icons.arrow_drop_down),
                    title: Row(
                      children: [
                        Text(data['question']),
                        const SizedBox(
                          width: 22,
                        ),
                        const Text('|'),
                        const SizedBox(
                          width: 22,
                        ),
                        Builder(builder: (context) {
                          return Text(data['date'].toString().substring(0, 10));
                        }),
                      ],
                    ),
                    children: [
                      ListTile  (
                        title: Builder(
                            builder: (context) {
                              String docId =  data['reciever'];
                              FirebaseDatabase.instance.ref('Doctors').child(docId).child('username').get().then((value) {
                                setState(() {
                                  doctor = value.value.toString();
                                });
                                print(doctor);
                              });
                              return Row(
                                children: [
                                  Text('Doctor: ' + doctor),
                                ],
                              );
                            }
                        ),
                      ),
                      ListTile  (
                        trailing: const Icon(Icons.reply),
                        onTap: () {
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
                                              return 'Enter Reply';
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
                                            hintText: 'Reply',
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
                                       
                                        FirebaseDatabase database =
                                            FirebaseDatabase.instance;
                                        database
                                            .ref('Questions')
                                            .child(snapshot.key.toString())
                                            .child('reply')
                                            .set(chronicController.text);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Reply'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        title:  Text('Reply: '+data['reply']),
                      )
                    ],
                  ),
                );
              }
              else{
                return Container();
              }
            }
          )
        ));
  }
}
