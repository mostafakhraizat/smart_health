import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:smart_health/main.dart';
import 'package:smart_health/pages/admin/questions.dart';
import 'package:smart_health/pages/admin/symptoms.dart';

import '../../constants/constants.dart';
import '../../routing/routing.dart';
import 'advices.dart';
import 'bookings.dart';
import 'clinics.dart';
import 'diagnoses.dart';
import 'doctors_requests.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Future<User> getUser() async {
    return FirebaseAuth.instance.currentUser!;
  }

  @override
  void initState() {
    getBalance();
    // TODO: implement initState
    super.initState();
  }
  ValueNotifier<String> a = ValueNotifier('');

  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<String> getBalance() async {
    final ref = database.ref('Balance').child('amount');
    ref.get().then((value) {
      print(value.value);
      setState(() {
        a.value=value.value.toString();
      });
    });
    return a.value;
  }

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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          appBar: null,
          body: _selectedIndex == 0
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: FutureBuilder(
                                future: getUser(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<User> snapshot) {
                                  return const Text(
                                    'Hi' ", Admin!",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Mulish'),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          greeting(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              fontFamily: 'Mulish'),
                        ),
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: const [
                            Text(
                              "",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mulish'),
                            ),
                            Text(
                              "Have a good day!",
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
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        elevation: 1,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(child: Text('Balance')),
                              SizedBox(
                                width: 12,
                              ),
                              FutureBuilder(
                                  future: getBalance(),
                                  builder: (context, snapshot) {
                                    return Text(
                                        snapshot.data.toString() + " \$");
                                  }),
                              SizedBox(
                                width: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Text(
                        "Actions",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Mulish'),
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22)),
                                elevation: 1,
                                color: Colors.white,
                                child: RoundedExpansionTile(
                                  trailing: const Icon(Icons.arrow_drop_down),
                                  title: Row(
                                    children: const [
                                      Text(
                                        "Reports",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Mulish'),
                                      ),
                                      SizedBox(width: 6),
                                    ],
                                  ),
                                  children: [
                                     ListTile(
                                      onTap: (){
                                        Navigator.of(context).push(Routing().createRoute(AdminAvices()));
                                      },
                                      title: const Text('Advices'),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_outlined),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(context, Routing().createRoute(QuestionsAdmin()));
                                      },
                                      title: const Text('Questions'),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_outlined),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(context, Routing().createRoute(AdminBookings()));

                                      },
                                      title: const Text('Bookings'),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_outlined),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(context, Routing().createRoute(AdminDiagnoses()));

                                      },
                                      title: const Text('Diagnoses'),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_outlined),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(Routing()
                                      .createRoute(const SymptomsPage()));
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
                                        Expanded(child: Text('Symptoms')),
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
                                      .createRoute(const DoctorRequests()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  elevation: 1,
                                  color: Colors.white,
                                  child: RoundedExpansionTile(
                                    trailing: const Icon(Icons.arrow_drop_down),
                                    title: Row(
                                      children: const [
                                        Text(
                                          "Clinics, doctors...",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Mulish'),
                                        ),
                                        SizedBox(width: 6),
                                      ],
                                    ),
                                    children: [
                                      const ListTile(
                                        title: Text('Doctors'),
                                        trailing: Icon(
                                            Icons.arrow_forward_ios_outlined),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(Routing()
                                              .createRoute(
                                                  const ClinicsPage()));
                                        },
                                        title: const Text('Clinics, Hospitals'),
                                        trailing: const Icon(
                                            Icons.arrow_forward_ios_outlined),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (c) => const WelcomeView()));
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
                                        Expanded(child: Text('Sign out')),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                        ),
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
