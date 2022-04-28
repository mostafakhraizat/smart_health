import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:smart_health/constants/doctor.dart';
import 'package:smart_health/pages/user/home_user.dart';

class Result extends StatefulWidget {
  const Result({Key? key,required this.doctors,required this.clinics}) : super(key: key);
  final List<Doctor> doctors;
  final List<Clinic> clinics;
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  List<String> heartesults = [
    'No issues',
    'try visiting a Cardiac clinic',
  ];

  List<String> covidResults = [
    'positive',
    '90% positive',
    '70% positive',
    'negative',
  ];

  List<String> mentalResults = [
    'Your Mental health is good',
    'You mabye facing some life problems, try taking a rest',
    'Take a rest'
  ];

  List<String> nutritionResults = [
    'Lack in protein',
    'Lack in vitamins',
    'Lack in carbohydrates',
    'Need some sleep',
  ];
  int heart = 0;
  int covid = 0;
  int nutrition = 0;
  int mental = 0;

  @override
  void initState() {
    if (DateTime.now().microsecond & 7 == 0) {
      heart = 0;
      covid = 0;
      nutrition = 0;
      mental = 0;
    } else if (DateTime.now().microsecond & 2 == 0) {
      heart = 1;
      covid = 1;
      nutrition = 1;
      mental = 1;
    } else if (DateTime.now().microsecond & 3 == 0) {
      heart = 0;
      covid = 3;
      nutrition = 2;
      mental = 2;
    } else {
      heart = 1;
      covid = 0;
      nutrition = 3;
      mental = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: const Text('Results'),
                  automaticallyImplyLeading: true,
                  leading: IconButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserHomePage()));
                    },
                    icon: const Icon(Icons.arrow_back),
                  )
                ),
                body: SingleChildScrollView(
                    child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Your General Diagnose results:',
                      style: TextStyle(fontSize: 22, color: Colors.grey),
                    )
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 2,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'My Heart',
                                            style: TextStyle(
                                                color: Colors.pink,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                heartesults.elementAt(heart)),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                          )
                                        ],
                                      ))))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 2,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Mental Health',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(mentalResults
                                                .elementAt(mental)),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Icon(
                                            Icons.timeline,
                                            color: Colors.green,
                                          )
                                        ],
                                      ))))),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 2,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Covid-19',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                covidResults.elementAt(covid)),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Icon(
                                            Icons.coronavirus,
                                            color: Colors.blue,
                                          )
                                        ],
                                      ))))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 2,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Nutrition',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(nutritionResults
                                                .elementAt(nutrition)),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Icon(
                                            Icons.fastfood,
                                            color: Colors.indigo,
                                          )
                                        ],
                                      ))))),

                    ],
                  ),
                      Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Recommendations',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      Divider(),
                      Card(
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),),
                        elevation: 1,
                        color: Colors.grey[100],
                        child: RoundedExpansionTile(
                          trailing: const Icon(Icons.arrow_drop_down),
                          title: Row(
                            children: [
                              Text('Clinics'),
                              const SizedBox(
                                width: 22,
                              ),
                              const SizedBox(
                                width: 22,
                              ),

                            ],
                          ),
                          children: [
                            ListTile(
                              title: Builder(
                                  builder: (context) {
                                    return Row(
                                      children:  [
                                        Row(
                                          children: [
                                            Icon(Icons.collections_bookmark_rounded),
                                            SizedBox(width: 12,),

                                            Text(widget.clinics.elementAt(0).name.toString()),
                                          ],
                                        ),
                                        SizedBox(width: 42,),
                                        Builder(builder: (context) {
                                          return Row(
                                            children: [
                                              Icon(Icons.location_on),
                                              SizedBox(width: 12,),

                                              Text(widget.clinics.elementAt(0).location.toString()),
                                            ],
                                          );
                                        }),
                                      ],
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),Divider(),
                      Card(
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),),
                        elevation: 1,
                        color: Colors.grey[100],
                        child: RoundedExpansionTile(
                          trailing: const Icon(Icons.arrow_drop_down),
                          title: Row(
                            children: [
                              Text('Doctors'),

                            ],
                          ),
                          children: [
                            ListTile(
                              title: Builder(
                                  builder: (context) {
                                    return Row(
                                      children:  [
                                        Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(width: 12,),

                                            Text(widget.doctors.elementAt(0).name.toString()),
                                          ],
                                        ),
                                        SizedBox(width: 42,),
                                        Builder(builder: (context) {
                                          return Row(
                                            children: [
                                              Icon(Icons.location_on),
                                              SizedBox(width: 12,),

                                              Text(widget.doctors.elementAt(0).name.toString()),
                                            ],
                                          );
                                        }),
                                      ],
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])))));
  }
}
