import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';


class DoctorRequests extends StatefulWidget {
  const DoctorRequests({Key? key}) : super(key: key);

  @override
  _DoctorRequestsState createState() => _DoctorRequestsState();
}

class _DoctorRequestsState extends State<DoctorRequests> {
  int textLength = 0;
  TextEditingController chronicController = TextEditingController();

  @override
  void dispose() {
    chronicController.dispose();
    super.dispose();
  }
  bool loading = false;
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
              title: const Text('Doctors requests'),
              ),
          body: FirebaseAnimatedList(
            query:
            FirebaseDatabase.instance.reference().child('DoctorRequests'),
            itemBuilder: (context, snapshot, animation, index) {
              final json = snapshot.value;
              Map<String, dynamic> data =
              jsonDecode(jsonEncode(json));

            return  Card(
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),),
                elevation: 1,
                color: Colors.blue.withOpacity(0.1),
                child: RoundedExpansionTile(
                  trailing: const Icon(Icons.arrow_drop_down),
                  title: Row(
                    children: [
                      Text(data['username'].toString()),
                      const SizedBox(
                        width: 22,
                      ),
                      const Text('|'),
                      const SizedBox(
                        width: 22,
                      ),
                      Builder(builder: (context) {
                        return Text(data['date'].toString().substring(0, 10).toString());
                      }),
                    ],
                  ),
                  children: [
                    ListTile(
                      title: Builder(
                          builder: (context) {
                            // FirebaseDatabase.instance.ref('Doctors').child(docId).child('username').get().then((value) {
                            //   setState(() {
                            //     doctor = value.value.toString();
                            //   });
                            //   print(doctor);
                            // });
                            return Row(
                              children: [
                                Text('Email: ' + data['email']),
                              ],
                            );
                          }
                      ),
                    ),
                    ListTile(
                      trailing: !loading?Container(
                        width: 200,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                FirebaseDatabase.instance.ref('DoctorRequests').child(snapshot.key.toString()).remove();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.red[100]
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Reject'),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){

                                FirebaseAuth.instance.createUserWithEmailAndPassword(email: data['email'], password: data['password']).then((value) {
                                });
                                Future.delayed(const Duration(seconds: 2),(){

                                  final xdata = {
                                    'weight':data['weight'],
                                    'address':data['address'],
                                    'bithdate':data['bithdate'],
                                    'date':data['date'],
                                    'email':data['email'],
                                    'username':data['username'],
                                    'password':data['password'],
                                    'uid':FirebaseAuth.instance.currentUser!.uid,
                                  };


                                  FirebaseDatabase.instance.ref('Doctors').child(FirebaseAuth.instance.currentUser!.uid).set(xdata).then((value) {
                                    FirebaseDatabase.instance.ref('DoctorRequests').child(snapshot.key.toString()).remove();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accepted Successfully!')));
                                  });


                                  FirebaseDatabase.instance.ref('doctors').push().set(xdata).then((value) {
                                  });

                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.green[100]
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Accept'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):const CircularProgressIndicator(),
                      title:  Text('Address: '+data['address'].toString()),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
