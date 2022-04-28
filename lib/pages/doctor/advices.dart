import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/routing/routing.dart';

import 'create.dart';

class AdvicesPage extends StatefulWidget {
  const AdvicesPage({Key? key}) : super(key: key);

  @override
  _AdvicesPageState createState() => _AdvicesPageState();
}

class _AdvicesPageState extends State<AdvicesPage> {
  int textLength = 0;
  TextEditingController chronicController = TextEditingController();
  TextEditingController disease = TextEditingController();

  @override
  void dispose() {
    chronicController.dispose();
    disease.dispose();
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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(Routing().createRoute(const CreateAdvice()));
                },
                icon: const Icon(Icons.add))
          ]),
      body: FirebaseAnimatedList(
        query: FirebaseDatabase.instance.reference().child('Posts'),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value;
          Map<String, dynamic> data = jsonDecode(jsonEncode(json));
          if (data['by'] == id) {
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
                            InkWell(
                                onTap: () {
                                  FirebaseDatabase.instance
                                      .ref('Posts')
                                      .child(snapshot.key.toString())
                                      .remove();
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
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
          } else {
            return Container();
          }
        },
      ),
    ));
  }
}
// ListTile(
// title: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// SizedBox(
// height: 12,
// ),
// Row(
// children: [
// Text(
// data['title'].toString(),
// style: TextStyle(fontWeight: FontWeight.w900),
// ),
// ],
// ),
// Row(
// children: [
// Text(data['description'].toString()),
// ],
// ),
// ],
// ),
// subtitle: Column(
// children: [
// SizedBox(
// child: ClipRRect(
// borderRadius: BorderRadius.circular(8.0),
// child: Image.network(data['image'],height: 200,fit: BoxFit.cover,),
// )),
// SizedBox(height: 22,),
// Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [Text(data['date'].toString().substring(0,10))],
// )
// ],
// ),
// trailing: InkWell(
// onTap: () {
// FirebaseDatabase.instance
//     .ref('Posts')
//     .child(snapshot.key.toString())
//     .remove();
// },
// child: const Icon(Icons.delete)),
// )
