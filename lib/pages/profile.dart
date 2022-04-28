import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/pages/user/my_bookings.dart';
import 'package:smart_health/pages/user/my_diagnoses.dart';
import 'package:smart_health/pages/user/my_questions.dart';
import 'package:smart_health/routing/routing.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String weight = '';
  String payment = '';
  String username = 'USERANME';
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: const Color(0xffdcf3f0),
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 70,
              color: const Color(0xffdcf3f0),
              child: Row(
                children: [
                  const SizedBox(width: 22,),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 6),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 16,
                      ),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 0.51,
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('My profile',style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22
                        ),),
                        SizedBox(width: 52,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 25, 40, 40),
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Row(
                    children: const [
                      SizedBox(width: 6,),
                      Text('Information',style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18
                      ),),
                    ],
                  ),
                  const SizedBox(height: 16,),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 14),
                            child: Hero(
                              tag: 'tag',
                              child: CircleAvatar(
                                  radius: 32,
                                  foregroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBmYWNlfGVufDB8fDB8fA%3D%3D&w=1000&q=80')),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 22,top: 16,bottom: 16),
                              child: Builder(
                                  builder: (context) {
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            FirebaseDatabase database = FirebaseDatabase.instance;
                                            database.ref('Users').child('Patients').child(auth.currentUser!.uid.toString()).child('username').get().then((value) {
                                              setState(() {
                                                username = value.value.toString();
                                              });
                                            });
                                            return  Text(username,style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900
                                            ),);
                                          }
                                        ),
                                        const SizedBox(height: 8,),
                                        Text(auth.currentUser!.email.toString(),style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500
                                        ),),

                                      ],
                                    );
                                  }
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 26,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(Routing().createRoute(const MyQuestions()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                             Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Container(
                                child: const Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Center(child: Icon(Icons.question_answer),),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.indigo.withOpacity(0.2),
                                ),
                              )),
                            Padding(
                                padding: const EdgeInsets.only(left: 22,top: 16,bottom: 16),
                                child: Builder(
                                    builder: (context) {
                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const[
                                          Text('My Questions',style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500
                                          ),),

                                        ],
                                      );
                                    }
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, Routing().createRoute(MyDiagnoses()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                             Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Container(
                                child: const Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Center(child: Icon(Icons.timeline),),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.indigo.withOpacity(0.2),
                                ),
                              )),
                            Padding(
                                padding: const EdgeInsets.only(left: 22,top: 16,bottom: 16),
                                child: Builder(
                                    builder: (context) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const[
                                          Text('My Diagnoses',style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500
                                          ),),

                                        ],
                                      );
                                    }
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (c)=>const MyBookings()));

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                             Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Container(
                                child: const Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Center(child: Icon(Icons.book),),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.indigo.withOpacity(0.2),
                                ),
                              )),
                            Padding(
                                padding: const EdgeInsets.only(left: 22,top: 16,bottom: 16),
                                child: Builder(
                                    builder: (context) {
                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const[
                                          Text('My Bookings',style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500
                                          ),),

                                        ],
                                      );
                                    }
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36,),
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
            )

          ],
        ),
      ),

    ));
  }
}
