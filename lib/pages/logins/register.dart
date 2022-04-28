import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/pages/logins/login_page.dart';

import '../../routing/routing.dart';
import 'add_info.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  String role = '';

  @override
  Widget build(BuildContext context) {
    Color primary = const Color(0xff41d9a5);

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Form(
          key: key,
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
                      'Register',
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Mulish'),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
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
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xffF6FFFC),
                      prefixIcon: Icon(Icons.account_circle_sharp),
                      enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0.0),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      hintText: 'Enter Email',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Field Required';
                      } else {
                        return null;
                      }
                    },
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xffF6FFFC),
                      prefixIcon: Icon(Icons.lock),
                      enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0.0),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      hintText: 'Enter password',
                    )),
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 22,
                  ),
                  Text(' Role')
                ],
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Color(0xfff47b0a),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Center(
                          child: Icon(
                        Icons.grade,
                        color: Colors.white,
                        size: 22,
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('Doctor'),
                  ],
                ),
                leading: Radio<String>(
                  activeColor: Colors.red,
                  value: 'Doctor',
                  groupValue: role,
                  onChanged: (value) {
                    setState(() {
                      role = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Color(0xffeb4796),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Center(
                          child: Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 22,
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('Patient'),
                  ],
                ),
                leading: Radio<String>(
                  activeColor: Colors.red,
                  value: 'Patient',
                  groupValue: role,
                  onChanged: (value) {
                    setState(() {
                      role = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  try {
                    final email = _email.text;
                    final password = _password.text;
                    if (key.currentState!.validate()) {
                      if (role == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please choose role')));
                      }else{
                        Navigator.of(context).push(Routing().createRoute(
                            AddInfo(email: email, password: password,role:role)));
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
                        title: const Text(
                          "Register Error",
                          style: TextStyle(fontFamily: 'Mulish'),
                        ),
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
                child: Container(
                  child: Center(
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25), color: primary),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 50,
                ),
              ),
              const SizedBox(height: 25),
              const SizedBox(height: 25),
              const Divider(),
              const Text(
                "Do have an account",
                style: TextStyle(fontFamily: 'Mulish'),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(Routing().createRoute(const LoginView()));
                },
                child: Container(
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Mulish'),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
