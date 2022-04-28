import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdvice extends StatefulWidget {
  const CreateAdvice({Key? key}) : super(key: key);

  @override
  _CreateAdviceState createState() => _CreateAdviceState();
}

class _CreateAdviceState extends State<CreateAdvice> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  bool loading = false;
  bool loading1 = false;
  File? _imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
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
                      'Create Post',
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
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value.toString() == '') {
                            return 'Please Enter Title';
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.done,
                        controller: title,
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color: Colors.grey[900]!, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value.toString() == '') {
                            return 'Please Enter Description';
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.done,
                        controller: description,
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color: Colors.grey[900]!, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
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
                                if (_key.currentState!.validate()) {
                                  if (!picked) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('select image')));
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });
                                    uploadImagetFirebase(path).then((value) {
                                      Future.delayed(const Duration(seconds: 3), () {
                                        print(url);

                                        FirebaseDatabase.instance
                                            .ref('Posts')
                                            .push()
                                            .set({
                                          'title': title.text,
                                          'description': description.text,
                                          "image": url,
                                          "by": userId,
                                          'date': DateTime.now().toString(),
                                          'email': FirebaseAuth
                                              .instance.currentUser!.email
                                              .toString()
                                        }).then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('Post shared!')));
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.pop(context);
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
                                }
                              },
                              child: Container(
                                child: const Center(
                                  child: Text(
                                    'Post',
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
