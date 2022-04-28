import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool a = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final prefs = SharedPreferences.getInstance();
  bool openWithScanner = false;
  bool allowPushNotifications = false;


  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }


  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      openWithScanner = prefs.getBool("openWithScanner")!;
      allowPushNotifications = prefs.getBool("allowPushNotifications")!;
    });
  }

  Color primary = const Color(0xffdaf2ef);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: primary,
            appBar: null,
            body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                    future: getSharedPrefs(),
                    builder: (context, snapshot) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        border: Border.all(
                                            color: Colors.black54, style: BorderStyle.solid)),
                                    child: const Icon(
                                      Icons.settings,
                                      color: Colors.black,
                                      size: 26,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            const SizedBox(height: 20,),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Common',style: TextStyle(fontFamily: 'Mulish'),),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12)),
                                  color: Colors.white
                              ),
                              child: Column(
                                children: const [
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Account',style: TextStyle(fontFamily: 'Mulish'),),
                            ),

                            const SizedBox(height: 8,),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12)),
                                  color: Colors.white
                              ),
                              child: auth.currentUser != null?Column(
                                children: [
                                  ListTile(
                                    subtitle: Text(auth.currentUser!.email.toString()),
                                    title:const Text('Email',style: TextStyle(fontFamily: 'Mulish'),),
                                    leading:Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                            color: Color(0xffeb4796),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: const Icon(Icons.email,color: Colors.white,)),
                                    trailing:const Icon(Icons.arrow_forward_ios_outlined),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    title: const Text('Logout',style: TextStyle(fontFamily: 'Mulish'),),
                                    leading:Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff0038ff),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: const Icon(Icons.logout,color: Colors.white,)),
                                    trailing:const Icon(Icons.arrow_forward_ios_outlined),
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (conte)=>const WelcomeView()));
                                      setState(() {
                                        auth.signOut();
                                      });
                                    },
                                  ),

                                ],
                              ):Column(
                                children: const [
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Notifications',style: TextStyle(fontFamily: 'Mulish'),),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12)),
                                  color: Colors.white
                              ),
                              child: Column(
                                children: const [
                                ],
                              ),
                            ),
                            const SizedBox(height: 100,)
                          ],
                        ),
                      );
                    }



                )



            )

        )

    );
  }
}
