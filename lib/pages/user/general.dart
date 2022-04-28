import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/pages/user/result.dart';
import 'package:smart_health/routing/routing.dart';

import '../../constants/doctor.dart';

class GeneralDiagnose extends StatefulWidget {
  @override
  _GeneralDiagnoseState createState() => _GeneralDiagnoseState();

  const GeneralDiagnose(
      {Key? key, required this.diseases, required this.symptoms})
      : super(key: key);

  final List<String> diseases;
  final List<String> symptoms;
}

class _GeneralDiagnoseState extends State<GeneralDiagnose> {
  List<bool>? _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(widget.diseases.length, false);
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('General Diagnose'),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: InkWell(
                child: const Text(
                  'Diagnose',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                   showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              title: Row(
                                children: const [
                                  Expanded(child: Text('Diagnosing...')),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  CircularProgressIndicator()
                                ],
                              ),
                            );
                          },
                        )
                      ;
                   String userid = FirebaseAuth.instance.currentUser!.uid;
                   final ref = FirebaseDatabase.instance.ref('Diagnoses').child(userid.toString());
                   String pushedSymps = '';
                   String pushedDis = '';
                   for(var symp in widget.symptoms){
                     pushedSymps =symp  + ','+pushedSymps;

                   }for(var dis in widget.diseases){
                     pushedDis =dis  + ','+pushedDis;
                   }

                   ref.push().set({
                     "user":userid,
                     "date":DateTime.now().toString(),
                     "Symptoms":pushedSymps,
                     "Diseases":pushedDis,
                     'image':'no'
                   });
                   FirebaseDatabase.instance.ref('AdminDiagnoses').push().set({
                     "user":userid,
                     "date":DateTime.now().toString(),
                     "Symptoms":pushedSymps,
                     "Diseases":pushedDis,
                     'image':'no',
                     'email':FirebaseAuth.instance.currentUser!.email.toString()
                   });
                   FirebaseDatabase.instance.ref('Balance').child('amount').get().then((value) {

                     int amount = int.parse(value.value.toString());
                     amount+=50;
                     FirebaseDatabase.instance.ref('Balance').child('amount').set(amount);
                   });
                  createResult();
                },
              ),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: widget.diseases.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(widget.symptoms[index]),
              subtitle: Text(widget.diseases[index]),
              value: _isChecked![index],
              onChanged: (val) {
                setState(
                  () {
                    _isChecked![index] = val!;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
  createResult(){

    FirebaseDatabase database = FirebaseDatabase.instance;
    final clinicsRef = database.ref('Clinics');
    final doctorsRef = database.ref('doctors');


    List<Doctor> doctors=[];
    List<Clinic> clinics=[];

    clinicsRef.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        final json = child.value;
        Map<String, dynamic> data =
        jsonDecode(jsonEncode(json));

        clinics.add(Clinic(name: data['name'],location: data['location']));

        doctorsRef.onValue.listen((event) {
          for (final child in event.snapshot.children) {
            final json = child.value;

            Map<String, dynamic> data =
            jsonDecode(jsonEncode(json));
            doctors.add(Doctor(email: data['email'],name: data['address']));
            doctors.shuffle();
            clinics.shuffle();
            print('steve'+ doctors.length.toString());
            print('steve'+ clinics.length.toString());
            Future.delayed(Duration(seconds: 3),(){
              Navigator.of(context).push(Routing().createRoute(Result(doctors: doctors,clinics: clinics)));
            });
          }
        }, onError: (error) {
          // Error.
        });

      }
    }, onError: (error) {
      // Error.
    });

  }

}
