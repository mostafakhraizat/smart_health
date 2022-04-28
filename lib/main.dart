import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_health/pages/admin/admin_login.dart';
import 'package:smart_health/pages/logins/login_page.dart';
import 'package:smart_health/pages/logins/register.dart';
import 'package:smart_health/routing/routing.dart';
import 'constants/sms.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeView(),
    );
  }
}


class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);
  
  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {

  @override
  void initState() {
    super.initState();
  }
  Color primary = const Color(0xff41d9a5);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(
                  height: 182,
                ),


                const SizedBox(
                  height: 22,
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Smart",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32,fontFamily: 'Mulish'),
                    ),
                    Text(
                      " Health",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primary,
                          fontSize: 32,fontFamily: 'Mulish'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 56,
                ),
                Text(
                  "Join Us!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontSize: 22,fontFamily: 'Mulish'),
                ),
                const SizedBox(
                  height: 26,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(Routing().createRoute(const LoginView()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xff5ed381),
                            Color(0xff3ddaab),
                          ]),
                          borderRadius: BorderRadius.circular(22)
                      ),
                      child: const Center(child: Text('Login',style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,fontFamily: 'Mulish'
                      ),),),
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(Routing().createRoute((const RegisterView())));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: const Center(child: Text('Sign Up',style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,fontFamily: 'Mulish'
                      ),),),
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                  const Divider(),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(Routing().createRoute((const AdminLogin())));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: const Center(child: Text('Admin Login',style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,fontFamily: 'Mulish'
                      ),),),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
