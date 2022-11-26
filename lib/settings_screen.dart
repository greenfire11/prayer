// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:prayer/api/notification_api.dart';
import 'package:prayer/main.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

import 'compass_screen2.dart';
import 'dua_text.dart';

enum Methods {
  MuslimWorldLeague,
  Egyptian,
  Karachi,
  UmmAlQura,
  Dubai,
  Qatar,
  Kuwait,
  MoonsightingCommittee,
  Singapore,
  Turkey,
  Tehran,
  NorthAmerica
}

enum Madhab2 { Shafi, Hanafi }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Methods? _met;
  late Madhab2? _mad;

  void setMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("method", method);
  }

  void setMadhab(String mad) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("madhab", mad);
  }

  void getShared() async {
    final prefs = await SharedPreferences.getInstance();
    String? method = await prefs.getString("method");
    String? mad = await prefs.getString("madhab");
    if (mad == "shafi") {
      setState(() {
        _mad = Madhab2.Shafi;
      });
    } else if (mad == "hanafi") {
      setState(() {
        _mad = Madhab2.Hanafi;
      });
    }
    print(method);
    if (method == "Muslim World League") {
      setState(() {
        _met = Methods.MuslimWorldLeague;
      });
      print("1 $_met");
    } else if (method == "Egyptian") {
      setState(() {
        _met = Methods.Egyptian;
      });
    } else if (method == "Umm al Qura") {
      setState(() {
        _met = Methods.UmmAlQura;
      });
    } else if (method == "Dubai") {
      setState(() {
        _met = Methods.Dubai;
      });
    } else if (method == "Qatar") {
      setState(() {
        _met = Methods.Qatar;
      });
    } else if (method == "Kuwait") {
      setState(() {
        _met = Methods.Kuwait;
      });
    } else if (method == "Singapore") {
      setState(() {
        _met = Methods.Singapore;
      });
    } else if (method == "Turkey") {
      setState(() {
        _met = Methods.Turkey;
      });
    } else if (method == "Tehran") {
      setState(() {
        _met = Methods.Tehran;
      });
    } else if (method == "North America") {
      setState(() {
        _met = Methods.NorthAmerica;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    getShared();
    

    super.initState();
  }

  var controller123 = SidebarXController(selectedIndex: 2, extended: false);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: Container(
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
              },
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Prayer Times Settings",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              RadioListTile<Methods>(
                                title: const Text('Muslim World League'),
                                value: Methods.MuslimWorldLeague,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Muslim World League");
                                  });
                                },
                              ),
                              RadioListTile<Methods>(
                                title: const Text('Egyptian Authority'),
                                value: Methods.Egyptian,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Egyptian");
                                  });

                                  Navigator.pop(context);
                                },
                              ),

                              /// RadioListTile<SingingCharacter>(
                              ///   title: const Text('Karachi'),
                              ///   value: SingingCharacter.Karachi,
                              ///   groupValue: _character,
                              ///   onChanged: (SingingCharacter? value) {
                              ///     setState(() {
                              ///       _character = value;
                              ///       print(_character);
                              ///     });
                              ///   },
                              /// ),
                              RadioListTile<Methods>(
                                title: const Text('Kuwaiti Authority'),
                                value: Methods.Kuwait,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Kuwait");
                                  });

                                  Navigator.pop(context);
                                },
                              ),

                              /// RadioListTile<SingingCharacter>(
                              ///   title: const Text('Moon Sighting'),
                              ///   value: SingingCharacter.MoonsightingCommittee,
                              ///   groupValue: _character,
                              ///   onChanged: (SingingCharacter? value) {
                              ///     setState(() {
                              ///       _character = value;
                              ///       print(_character);
                              ///     });
                              ///   },

                              /// ),
                              RadioListTile<Methods>(
                                title: const Text(
                                    'Islamic Society of North America'),
                                value: Methods.NorthAmerica,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("North America");
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile<Methods>(
                                title: const Text('Qatari Authority'),
                                value: Methods.Qatar,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Qatar");
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile<Methods>(
                                title: const Text('Singaporean Authority'),
                                value: Methods.Singapore,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Singapore");
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile<Methods>(
                                title: const Text(
                                    'Shia - Institute of Geophysics, University of Tehran'),
                                value: Methods.Tehran,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Tehran");
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile<Methods>(
                                title: const Text('Dubai Authority (UAE)'),
                                value: Methods.Dubai,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Dubai");
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile<Methods>(
                                title: const Text('Turkish Authority'),
                                value: Methods.Turkey,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Turkey");
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile<Methods>(
                                title: const Text('Umm Al-Qura'),
                                value: Methods.UmmAlQura,
                                groupValue: _met,
                                onChanged: (Methods? value) {
                                  setState(() {
                                    _met = value;
                                    setMethod("Umm al Qura");
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              child: Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(10, 10, 50, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calculation Method",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Please consult your religious authority for the correct calculation method to use.",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              RadioListTile<Madhab2>(
                                title: const Text('Standard Asr Method'),
                                value: Madhab2.Shafi,
                                groupValue: _mad,
                                onChanged: (Madhab2? value) {
                                  setState(() {
                                    _mad = value;
                                  });
                                  setMadhab("shafi");
                                },
                              ),
                              RadioListTile<Madhab2>(
                                title: const Text('Hanafi'),
                                value: Madhab2.Hanafi,
                                groupValue: _mad,
                                onChanged: (Madhab2? value) {
                                  setState(() {
                                    _mad = value;
                                  });
                                  setMadhab("hanafi");
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              child: Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(10, 10, 50, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Juristic Method for Asr",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _mad == Madhab2.Shafi ? "Standart Asr Method" : "Hanafi",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
