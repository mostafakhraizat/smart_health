import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_health/pages/user/result.dart';

import '../../constants/doctor.dart';
import '../../routing/routing.dart';
import 'covid_result.dart';

class XRay extends StatefulWidget {
  const XRay({Key? key}) : super(key: key);

  @override
  _XRayState createState() => _XRayState();
}

class _XRayState extends State<XRay> {
  final GlobalKey<FormState> _key = GlobalKey();
  bool loading = false;
  bool loading1 = false;
  File? _imageFile;

  final picker = ImagePicker();
  bool picked = false;
  String path = '';

  Future<String> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
      picked = true;
    });
    return pickedFile!.path;
  }

  String userId = FirebaseAuth.instance.currentUser!.uid.toString();
  String url = '';

  Future<String> uploadImagetFirebase(String imagePath) async {
    await FirebaseStorage.instance
        .ref(imagePath)
        .putFile(File(imagePath))
        .then((taskSnapshot) {
      print("task done");

      if (taskSnapshot.state == TaskState.success) {
        FirebaseStorage.instance.ref(imagePath).getDownloadURL().then((value) {
          setState(() {
            url = value;
          });
        }).onError((onError, s) {
          print('steve errorr');
        });
      }
    });
    return url;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Create XRay diagnose',
                          style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  Form(
                      key: _key,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 22,
                          ),
                          InkWell(
                            onTap: () async {
                              pickImage().then((value) {
                                setState(() {
                                  path = value;
                                  loading1=true;
                                });
                                print(path);
                              });
                            },
                            child: Container(
                              child:  Center(
                                child: Text(
                                  !loading1?'Select image':'edit selected image',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Mulish'),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.greenAccent),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 42,
                          ),
                          !loading
                              ? InkWell(
                            onTap: () async {
                                if (!picked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('select image')));
                                } else {
                                  setState(() {
                                    loading = true;
                                  });
                                  String userid = FirebaseAuth.instance.currentUser!.uid.toString();
                                  uploadImagetFirebase(path).then((value) {
                                    Future.delayed(const Duration(seconds: 3), () {
                                      print(url);

                                      FirebaseDatabase.instance.ref('Balance').child('amount').get().then((value) {
                                        int amount = int.parse(value.value.toString());
                                        amount+=50;
                                        FirebaseDatabase.instance.ref('Balance').child('amount').set(amount);
                                      });

                                      FirebaseDatabase.instance
                                          .ref('Diagnoses').child(userid)
                                          .push()
                                          .set({
                                        "Diseases": 'no',
                                        "Symptoms": userId,
                                        'date': DateTime.now().toString(),
                                        'image':url,
                                        'user':userid
                                      }).then((value) {

                                        FirebaseDatabase.instance.ref('AdminDiagnoses').push().set({
                                          "Diseases": 'no',
                                          "Symptoms": userId,
                                          'date': DateTime.now().toString(),
                                          'image':url,
                                          'user':userid,
                                          'email':FirebaseAuth.instance.currentUser!.email.toString()
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content:
                                            Text('Diagnose Completed!')));
                                        setState(() {
                                          loading = false;
                                        });
                                        createResult();
                                      });
                                    });
                                  }).onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Oups, something went wrong, please try again')));
                                  });
                                }
                                // uploadImageToFirebase(context);
                            },
                            child: Container(
                              child: const Center(
                                child: Text(
                                  'Diagnose',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Mulish'),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.blueAccent),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                            ),
                          )
                              : const CircularProgressIndicator(),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
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
            Future.delayed(Duration(seconds: 0),(){
              Navigator.of(context).push(Routing().createRoute(CovidResult(doctors: doctors,clinics: clinics)));
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



// }
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return AlertDialog(
// title: Text(
// 'Ask ' + data['username'] + " a question",
// style: const TextStyle(
// color: Colors.black,
// fontWeight: FontWeight.w700,
// fontSize: 14),
// ),

// ),
// actions: [
// TextButton(
// onPressed: () {
// Navigator.pop(context);
// },
// child: const Text('cancel'),
// ),
// TextButton(
// onPressed: () async{
// int balance = 0;
//
// if (_key.currentState!.validate()) {
// FirebaseDatabase database =
// FirebaseDatabase.instance;
//
//
// Navigator.of(context).push(Routing()
//     .createRoute(PayQuestion(
// question: controller.text,
// data: data,
// balance: balance)));
// }
// },
// child: const Text('Proceed'),
// ),
// ],
// );
// },
// );
}
