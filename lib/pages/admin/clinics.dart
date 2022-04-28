import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/routing/routing.dart';

import 'create_clinic/create_clinic.dart';

class ClinicsPage extends StatefulWidget {
  const ClinicsPage({Key? key}) : super(key: key);

  @override
  _ClinicsPageState createState() => _ClinicsPageState();
}

class _ClinicsPageState extends State<ClinicsPage> {
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
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(Routing().createRoute(const CreateClinic()));
                    },
                    icon: const Icon(Icons.add))
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
                            FirebaseDatabase.instance.ref('Clinics').child(snapshot.key.toString()).remove();
                          },
                          child: const Icon(Icons.delete)),
                      title: Text(data['name']),
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
