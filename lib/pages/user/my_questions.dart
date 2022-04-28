import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';


class MyQuestions extends StatefulWidget {
  const MyQuestions({Key? key}) : super(key: key);

  @override
  _MyQuestionsState createState() => _MyQuestionsState();
}

class _MyQuestionsState extends State<MyQuestions> {
  int textLength = 0;
  TextEditingController chronicController = TextEditingController();
  String doctor = "" ;

  @override
  void dispose() {
    chronicController.dispose();
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
          if(data['sender'] == FirebaseAuth.instance.currentUser!.uid.toString()){
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
                  ListTile(
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
                  ListTile(
                    onTap: () {
                    },
                    title:  Text('Reply: '+data['reply']),
                  )
                ],
              ),
            );
          }else{
          return  Container();
          }

        },
      ),
    ));
  }
}
