import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';


class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  int textLength = 0;
  TextEditingController chronicController = TextEditingController();
  String doctor = "" ;

  @override
  void dispose() {
    chronicController.dispose();
    super.dispose();
  }
  final query = FirebaseDatabase.instance.reference().child('bookedClinics').child(FirebaseAuth.instance.currentUser!.uid.toString());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: const Text('My Bookings'),
          ),
          body: FirebaseAnimatedList(
            query: query,
            itemBuilder: (context, snapshot, animation, index) {
              print(query.key);
              final json = snapshot.value;
              Map<String, dynamic> data = jsonDecode(jsonEncode(json));
              return Card(
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),),
                elevation: 1,
                color: Colors.blue.withOpacity(0.1),
                child: RoundedExpansionTile(
                  trailing: const Icon(Icons.arrow_drop_down),
                  title: Row(
                    children: [
                      Text(data['name']),
                      const SizedBox(
                        width: 22,
                      ),
                      const Text('|'),
                      const SizedBox(
                        width: 22,
                      ),
                      Builder(builder: (context) {
                        return Text(data['location'].toString());
                      }),
                    ],
                  ),
                  children: [
                    ListTile(
                      title: Builder(
                          builder: (context) {

                            return Row(
                              children: [
                                const Icon(Icons.timelapse_rounded),
                                const SizedBox(width: 12,),
                                Text("Booked On:  " +  data['bookedOn'].toString().substring(0, 10)),
                              ],
                            );
                          }
                      ),
                    )
                  ],
                ),
              );

            },
          ),
        ));
  }
}
