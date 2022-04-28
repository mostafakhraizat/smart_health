import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  int textLength = 0;

  @override
  void dispose() {
    super.dispose();
  }

  String id = FirebaseAuth.instance.currentUser!.uid;

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
              title: const Text('Advices'),
              actions: const [
              ]),
          body: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.reference().child('Posts'),
            itemBuilder: (context, snapshot, animation, index) {
              final json = snapshot.value;
              Map<String, dynamic> data = jsonDecode(jsonEncode(json));
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(data['title'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900))),

                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(data['description'].toString()),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      data['image'],
                                      height: 200,
                                      width: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              const SizedBox(
                                height: 22,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("BY: " + data['email'].toString(),style: const TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w900),),
                                  Text("  at,  :" + data['date'].toString().substring(0, 10))
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
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

