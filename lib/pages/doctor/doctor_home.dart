import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/main.dart';
import 'package:smart_health/pages/admin/symptoms.dart';
import 'package:smart_health/pages/doctor/replies.dart';

import '../../constants/constants.dart';
import '../../routing/routing.dart';
import 'advices.dart';
class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  Future<User> getUser()async{
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
                          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                            return const Text(
                              'Hi' ", Doctor!" ,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Mulish'),
                            );
                          },),
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
                        color: Colors.grey,fontFamily: 'Mulish'),
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: const[
                      Text(
                        "",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Mulish'),
                      ),
                      Text(
                        "Have a good day!",
                        style: TextStyle(
                            color: Constants.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,fontFamily: 'Mulish'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  "Actions",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,fontFamily: 'Mulish'),
                ),
                const SizedBox(height: 38,),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(Routing().createRoute(const Replies()));

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
                                  Expanded(child: Text('Questions')),
                                  SizedBox(width: 12,),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                  SizedBox(width: 12,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22,),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(Routing().createRoute(const SymptomsPage()));
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
                                  SizedBox(width: 12,),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                  SizedBox(width: 12,),
                                ],
                              ),
                            ),
                          ),
                        ),const SizedBox(height: 22,),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(Routing().createRoute(const AdvicesPage()));
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
                                  Expanded(child: Text('Advices')),
                                  SizedBox(width: 12,),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                  SizedBox(width: 12,),

                                ],
                              ),
                            ),
                          ),
                        ),const SizedBox(height: 22,),


                        const SizedBox(height: 22,),
                        InkWell(
                          onTap: (){
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).push(MaterialPageRoute(builder: (c)=>const WelcomeView()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                            elevation: 1,
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: const[
                                  Expanded(child: Text('Sign out')),
                                  SizedBox(width: 12,),
                                  Icon(Icons.logout,color: Colors.red,),
                                  SizedBox(width: 12,),
                                ],
                              ),
                            ),
                          ),
                        ),const SizedBox(height: 22,),


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