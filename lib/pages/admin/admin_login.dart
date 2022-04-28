import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_health/pages/admin/admin_home.dart';

import '../../main.dart';
class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isLoading = false;
  bool obsecure = true;
  Color primary = const Color(0xff41d9a5);
  GlobalKey<FormState> key = GlobalKey();
  bool loading = false;
  String username = '';
  String password = '';
  @override
  void initState() {
    FirebaseDatabase.instance.ref('admin').child('username').get().then((value) {
      setState(() {
        username = value.value.toString();
      });
      print(username);
    });FirebaseDatabase.instance.ref('admin').child('password').get().then((value) {
      setState(() {
        password = value.value.toString();
      });
    });
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
                            'Admin Login',
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
                          
                            if(_email.text == username && _password.text==password){
                              setState(() {
                                loading=false;
                              });
                              Navigator.of(context).push(MaterialPageRoute(builder: (s)=>const AdminHome()));
                            }else{

                              setState(() {
                                loading=false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text('Wrong emal or password')));
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


                  ],
                ),
              ),
            ),
          )),
    );
  }
}
