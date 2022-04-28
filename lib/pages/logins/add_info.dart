import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../user/primary_page.dart';

class AddInfo extends StatefulWidget {
  const AddInfo({Key? key, this.email, this.password, this.role})
      : super(key: key);
  final email, password, role;

  @override
  State<AddInfo> createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
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
  late final TextEditingController _username;
  late final TextEditingController _birthday;
  late final TextEditingController _Genger;
  late final TextEditingController _weight;
  late final TextEditingController _length;
  late final TextEditingController _address;

  @override
  void initState() {
    _username = TextEditingController();
    _birthday = TextEditingController();
    _Genger = TextEditingController();
    _weight = TextEditingController();
    _length = TextEditingController();
    _address = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _birthday.dispose();
    _Genger.dispose();
    _weight.dispose();
    _length.dispose();
    _address.dispose();
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
                          'Add Info',
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
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          fontFamily: 'Mulish'),
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
                        controller: _username,
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
                          hintText: "User Name",
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
                              readOnly: true,
                              onTap: () async {
                                await _selectDate(context);
                                _birthday.text =
                                    "${selectedDate.toLocal()}".split(' ')[0];
                              },
                              controller: _birthday,
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
                                hintText: "Birthday",
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
                              readOnly: true,
                              controller: _Genger,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    _Genger.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return _gender.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          child: Text(value), value: value);
                                    }).toList();
                                  },
                                ),
                                filled: true,
                                fillColor: const Color(0xffF6FFFC),
                                prefixIcon:
                                    const Icon(Icons.account_circle_sharp),
                                enabledBorder: const OutlineInputBorder(

                                    // width: 0.0 produces a thin "hairline" border

                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                hintText: "Gender",
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
                              keyboardType: TextInputType.number,
                              controller: _weight,
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
                                hintText: "Weight",
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
                              keyboardType: TextInputType.number,
                              controller: _length,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF6FFFC),
                                prefixIcon: Icon(Icons.account_circle_sharp),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                hintText: "Length",
                              )),
                        ),
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
                        controller: _address,
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
                          hintText: "Address",
                        )),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, bottom: 25, right: 25, left: 25),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xff61D27C),
                            Color(0xff3DDAAA)
                          ]),
                          borderRadius: BorderRadius.circular(18.0),
                          ),
                      child: InkWell(

                          onTap: () async {
                            setState(() {
                              loading=true;
                            });
                            try {
                              if (key.currentState!.validate()) {
                                if(widget.role=="Patient"){
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  auth
                                      .createUserWithEmailAndPassword(
                                      email: widget.email,
                                      password: widget.password)
                                      .then((value) {
                                    Future.delayed(const Duration(seconds: 4),(){
                                      final data = {
                                        'email': widget.email,
                                        'role': widget.role,
                                        'username': _username.text,
                                        'gender': _Genger.text,
                                        'birthdate': _birthday.text,
                                        'weight': _weight.text,
                                        'length': _length.text,
                                        'address': _address.text,
                                        "uid":auth.currentUser!.uid
                                      };

                                      FirebaseDatabase database = FirebaseDatabase.instance;
                                       database.ref('Users').child("Patients").child(auth.currentUser!.uid).set(data).then((value) {
                                          setState(() {
                                            loading=false;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Successfully creating account!')));
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                  const PrimaryPage()));
                                        });




                                    });
                                  });
                                }

                                else{
                                  final data = {
                                    'email': widget.email,
                                    'username': _username.text,
                                    'gender': _Genger.text,
                                    'birthdate': _birthday.text,
                                    'weight': _weight.text,
                                    'length': _length.text,
                                    'address': _address.text,
                                    'date':DateTime.now().toString(),
                                    'password':widget.password
                                  };
                                  FirebaseDatabase.instance.ref('DoctorRequests').push().set(data).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request sent to admins, wait them for accept')));
                                    Navigator.of(context).pop();
                                  });
                                  setState(() {
                                    loading = false;
                                  });

                                }

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
                            child: !loading? const Text(
                              "Complete your registeration",
                              style: TextStyle(fontFamily: 'Mulish',color: Colors.white),
                            ):const CircularProgressIndicator(),
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
