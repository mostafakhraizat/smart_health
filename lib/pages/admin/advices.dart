import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/routing/routing.dart';

class AdminAvices extends StatefulWidget {
  const AdminAvices({Key? key}) : super(key: key);

  @override
  _AdminAvicesState createState() => _AdminAvicesState();
}

class _AdminAvicesState extends State<AdminAvices> {
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
              title: const Text('Advices'),
          ),
          body: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.ref('Posts'),
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
