import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/pages/doctor/doctor_home.dart';
import 'package:smart_health/pages/logins/register.dart';

import '../../main.dart';
import '../../routing/routing.dart';
import '../user/home_user.dart';

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isLoading = false;
  bool obsecure = true;
  Color primary = const Color(0xff41d9a5);
  GlobalKey<FormState> key = GlobalKey();
  bool loading = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: null,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (a) => const WelcomeView()));
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
                            'Login',
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
                      height: 80,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Welcome',
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
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22)),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline),
                          Container(
                            padding: const EdgeInsets.only(left: 6),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22)),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline),
                          Container(
                            padding: const EdgeInsets.only(left: 6),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              controller: _password,
                              obscureText: obsecure,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        obsecure = !obsecure;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('show'),
                                      ],
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        if (key.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            final email = _email.text;
                            final password = _password.text;

                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password)
                                .then((value) {
                              setState(() {
                                loading = false;
                              });
                              final User? user = auth.currentUser;
                              FirebaseDatabase database =
                                  FirebaseDatabase.instance;
                              database
                                  .ref('Users')
                                  .child('Patients')
                                  .child(user!.uid.toString())
                                  .get()
                                  .then((value) {
                                final result = value.value;
                                if(result !=null){
                                 Navigator.of(context).push(Routing().createRoute(const UserHomePage()));
                                }else{
                                  database
                                      .ref('Doctors')
                                      .child(user.uid.toString())
                                      .get().then((value){
                                        if(value.value!=null){
                                          Navigator.of(context).push(Routing().createRoute(const DoctorHome()));
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to login, please try again')));
                                        }
                                  });
                                }
                              }).onError((error, stackTrace) {
                                print(error);
                              });
                            });
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            setState(() {
                              loading = false;
                            });
                            showAlertDialog(BuildContext context) {
                              // set up the button
                              Widget okButton = TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
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
                        }
                      },
                      child: Container(
                        child: Center(
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Mulish'),
                                ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: primary),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(),
                    const Text(
                      "Don't have an account",
                      style: TextStyle(fontFamily: 'Mulish'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .push(Routing().createRoute(const RegisterView()));
                      },
                      child: Container(
                        child: const Center(
                          child: Text(
                            'CREATE AN ACCOUNT',
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
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
