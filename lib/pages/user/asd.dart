import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/pages/user/ask_question.dart';
import 'package:smart_health/routing/routing.dart';

class Ask extends StatefulWidget {
  const Ask({Key? key}) : super(key: key);

  @override
  _AskState createState() => _AskState();
}

class _AskState extends State<Ask> {
  final GlobalKey<FormState> _key = GlobalKey();
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String user = '';
  int found = 0;
  GlobalKey<FormState> key = GlobalKey();
  String id = '', nationality = '', fullname = '', place = '';
  FirebaseDatabase database = FirebaseDatabase.instance;
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Recommended doctors'),
      ),
      body: FirebaseAnimatedList(
        query: FirebaseDatabase.instance.reference().child('Doctors'),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value;
          Map<String, dynamic> data = jsonDecode(jsonEncode(json));
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  trailing: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Ask ' + data['username'] + " a question",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                            content: Form(
                              key: _key,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.toString() == '') {
                                    return 'Please Enter Question';
                                  } else {
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.done,
                                controller: controller,
                                onChanged: (value) {},
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Question',
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
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
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('cancel'),
                              ),
                              TextButton(
                                onPressed: () async{
                                  int balance = 0;

                                  if (_key.currentState!.validate()) {
                                    print(data);
                                    FirebaseDatabase database =
                                        FirebaseDatabase.instance;
                                    Navigator.of(context).push(Routing()
                                        .createRoute(PayQuestion(
                                            question: controller.text,
                                            data: data,
                                            balance: balance)));
                                  }
                                },
                                child: const Text('Proceed'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Ask',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xfff47b0a).withOpacity(0.8)),
                    ),
                  ),
                  title: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            color: Color(0xfff47b0a),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                            child: Icon(
                          Icons.grade,
                          color: Colors.white,
                          size: 22,
                        )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(data['username']),
                    ],
                  ),
                  leading: Text((index + 1).toString()),
                ),
              ),
              const Divider()
            ],
          );
        },
      ),
    ));
  }

  Future<void> getDrugs(id) async {
    final ref = database.reference().child('UserData').child(id).child('Notes');
    ref.get().then((value) {
      final snapshot = value.children.iterator;
      number = 0;
      setState(() {
        while (snapshot.moveNext()) {
          number++;
        }
      });
    });
  }
}
