import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/constants/constants.dart';
import 'package:smart_health/pages/user/result.dart';
import 'package:smart_health/pages/user/xray.dart';

import '../../constants/doctor.dart';
import '../../routing/routing.dart';
import '../profile.dart';
import 'asd.dart';
import 'book.dart';
import 'explore.dart';
import 'general.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  void initState() {
    getUser();
    // TODO: implement initState
    getList();
    super.initState();
  }

  FirebaseDatabase database = FirebaseDatabase.instance;
  List<String> symptoms = [];
  List<String> diseases = [];

  Future getList() async {
    final ref = database.ref('Data').child('Symp');
    ref.onValue.listen((event) {
      symptoms.clear();
      diseases.clear();
      for (final child in event.snapshot.children) {
        Map<String, dynamic> data = jsonDecode(jsonEncode(child.value));
        symptoms.add(data['symptome']);
        diseases.add(data['disease']);
      }
    }, onError: (error) {
      // Error.
    });
    return '';
  }

  Future<User> getUser() async {
    return FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning';
      }
      if (hour < 17) {
        return 'Good ' 'Afternoon';
      }
      return 'Good ' 'Evening';
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    double height = MediaQuery.of(context).size.height;
    int _selectedIndex = 0;
    return SafeArea(
      child: Scaffold(
          appBar: null,
          body: _selectedIndex == 0
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      Routing().createRoute(const Profile()));
                                },
                                child: const Hero(
                                  tag: 'tag',
                                  child: CircleAvatar(
                                      radius: 32,
                                      foregroundImage: NetworkImage(
                                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBmYWNlfGVufDB8fDB8fA%3D%3D&w=1000&q=80')),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: (){

                          },
                          child: Text(
                            greeting(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontFamily: 'Mulish'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children:  [
                            Text(
                              "",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mulish'),
                            ),
                            Text(
                              "Have healthy day!",
                              style: TextStyle(
                                  color: Constants.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mulish'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(Routing().createRoute(XRay()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  elevation: 1,
                                  color: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: const [
                                        Expanded(child: Text('X-Ray Covid Diagnose')),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              InkWell(
                                onTap: () {
                                  print(diseases.length);
                                  print(symptoms.length);
                                  Navigator.push(
                                      context,
                                      Routing().createRoute(GeneralDiagnose(
                                        diseases: diseases,
                                        symptoms: symptoms,
                                      )));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  elevation: 1,
                                  color: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                            child: Text('General Diagnose')),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(Routing().createRoute(const Ask()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  elevation: 1,
                                  color: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: const [
                                        Expanded(child: Text('Search Doctors')),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(Routing()
                                      .createRoute(const BookClinic()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  elevation: 1,
                                  color: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                            child: Text(
                                                'Book Hospital or clinic')),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      Routing().createRoute(const Explore()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  elevation: 1,
                                  color: Colors.white,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: const [
                                        Expanded(child: Text('Explore Posts')),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Text('asd')),
    );
  }

}
