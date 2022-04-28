import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateClinic extends StatefulWidget {
  const CreateClinic({Key? key, this.email, this.password, this.role})
      : super(key: key);
  final email, password, role;

  @override
  State<CreateClinic> createState() => _CreateClinicState();
}

class _CreateClinicState extends State<CreateClinic> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final _gender = [
    "Male",
    "Female",
  ];
  late final TextEditingController clinicName;
  late final TextEditingController major;
  late final TextEditingController working_hours;
  late final TextEditingController description;
  late final TextEditingController location;

  @override
  void initState() {
    clinicName = TextEditingController();
    major = TextEditingController();
    working_hours = TextEditingController();
    description = TextEditingController();
    location = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    clinicName.dispose();
    major.dispose();
    working_hours.dispose();
    location.dispose();
    description.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: null,
          body: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: const Icon(
                              Icons.arrow_back_ios,
                            ),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.51,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        const Text(
                          'Create Clinic, Hospital',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'Mulish'),
                        ),
                        Container(
                          child: const Text(''),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.51,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Field Required';
                          } else {
                            return null;
                          }
                        },
                        controller: clinicName,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xffF6FFFC),
                          prefixIcon: Icon(Icons.account_circle_sharp),
                          enabledBorder: OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          hintText: "Clinic Name",
                        )),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Field Required';
                                } else {
                                  return null;
                                }
                              },
                              controller: major,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF6FFFC),
                                prefixIcon: Icon(Icons.info),
                                enabledBorder: OutlineInputBorder(

                                    // width: 0.0 produces a thin "hairline" border

                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                hintText: "Major",
                              )),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Field Required';
                                } else {
                                  return null;
                                }
                              },
                              controller: working_hours,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF6FFFC),
                                prefixIcon: Icon(Icons.timelapse_rounded),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                hintText: "Working hours",
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Field Required';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              controller: description,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF6FFFC),
                                prefixIcon: Icon(Icons.info_outline),
                                enabledBorder: OutlineInputBorder(

                                    // width: 0.0 produces a thin "hairline" border

                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                hintText: "Description",
                              )),
                        ),
                        const SizedBox(width: 25),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: TextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Field Required';
                          } else {
                            return null;
                          }
                        },
                        controller: location,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xffF6FFFC),
                          prefixIcon: Icon(Icons.location_on),
                          enabledBorder: OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          hintText: "Location",
                        )),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, bottom: 25, right: 25, left: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xff61D27C), Color(0xff3DDAAA)]),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            try {
                              if (key.currentState!.validate()) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  final data = {
                                    'major': major.text,
                                    'name': clinicName.text,
                                    'hours': working_hours.text,
                                    'description': description.text,
                                    "location": location.text
                                  };
                                  FirebaseDatabase.instance
                                      .ref('Clinics')
                                      .push()
                                      .set(data).then((value) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added')));
                                        Navigator.pop(context);

                                  }).onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error' + error.toString())));

                                  });
                                });
                              }
                            } on FirebaseAuthException catch (e) {
                              showAlertDialog(BuildContext context) {
                                // set up the button
                                Widget okButton = TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );

                                // set up the AlertDialog
                                AlertDialog alert = AlertDialog(
                                  title: const Text("Login Error"),
                                  content: Text(e.code),
                                  actions: [
                                    okButton,
                                  ],
                                );

                                // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              }

                              showAlertDialog(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: !loading
                                ? const Text(
                                    "Create",
                                    style: TextStyle(
                                        fontFamily: 'Mulish',
                                        color: Colors.white),
                                  )
                                : const CircularProgressIndicator(),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
