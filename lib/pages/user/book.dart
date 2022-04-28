import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/pages/user/pay_book.dart';
import 'package:smart_health/routing/routing.dart';


class BookClinic extends StatefulWidget {
  const BookClinic({Key? key}) : super(key: key);

  @override
  _BookClinicState createState() => _BookClinicState();
}

class _BookClinicState extends State<BookClinic> {
  int textLength = 0;
  TextEditingController chronicController = TextEditingController();

  @override
  void dispose() {
    chronicController.dispose();
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
              title: const Text('Clinics and hospitals'),
              actions: const [
              ]),
          body: FirebaseAnimatedList(
            query:
            FirebaseDatabase.instance.reference().child('Clinics'),
            itemBuilder: (context, snapshot, animation, index) {
              final json = snapshot.value;
              Map<String, dynamic> data =
              jsonDecode(jsonEncode(json));
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
                            Navigator.of(context).push(Routing().createRoute(PayBook(data: data,)));
                          },
                          child: const Icon(Icons.add),),
                      title: Text(data['name'] + "  ,  Location: " + data['location'])
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
