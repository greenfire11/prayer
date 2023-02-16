// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:prayer/api/notification_api.dart';
import 'package:prayer/main.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:app_settings/app_settings.dart';
import 'compass_screen2.dart';
import 'dua_text.dart';
import 'package:info_popup/info_popup.dart';

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
  @override
  void initState() {
    // TODO: implement initState

    getShared();
    getf24();

    super.initState();
  }

  var controller123 = SidebarXController(selectedIndex: 2, extended: false);
  late Methods? _met;
  late Madhab2? _mad;
  late bool format24;

  void getf24() async {
    final prefs = await SharedPreferences.getInstance();
    bool? f24 = await prefs.getBool("24format");
    setState(() {
      format24 = f24!;
    });
  }

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Calculation Method",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  InfoPopupWidget(
                    contentTitle:
                        'Please consult your religious authority for the correct calculation method to use.',
                    arrowTheme: InfoPopupArrowTheme(
                      color: Colors.grey,
                    ),
                    child: Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                await showDialog(
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

                                  Navigator.pop(context);
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
                                    print(_met);
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
                setState(() {
                  _met = _met;
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _met == Methods.MuslimWorldLeague
                          ? "Muslim World League"
                          : _met == Methods.NorthAmerica
                              ? "Noth America"
                              : _met == Methods.UmmAlQura
                                  ? "Umm Al-Qura":_met==Methods.Tehran?
                                  "Shia - Institute of Geophysics, Tehran"
                                  : _met.toString().split(".")[1],
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Asr Juristic Method",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                await showDialog(
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
                                  Navigator.pop(context);
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
                setState(() {
                  _mad = _mad;
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _mad == Madhab2.Shafi ? "Standard Asr Method" : "Hanafi",
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Time Format",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "24 Hour Format",
                    style: TextStyle(fontSize: 15),
                  ),
                  Switch(
                      value: format24,
                      onChanged: (value) async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("24format", value);
                        getf24();
                      })
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Notifications",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                AppSettings.openNotificationSettings();
              },
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Open settings",
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
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
