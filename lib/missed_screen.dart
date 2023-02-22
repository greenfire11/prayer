import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:prayer/components/missed_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissedPrayerScreen extends StatefulWidget {
  const MissedPrayerScreen({super.key});

  @override
  State<MissedPrayerScreen> createState() => _MissedPrayerScreenState();
}

class _MissedPrayerScreenState extends State<MissedPrayerScreen> {
  int fajrMissed = 0;
  late int dhuhrMissed;
  late int asrMissed;
  late int maghribMissed;
  late int ishaMissed;
  late SharedPreferences prefs;
  int _value = -1; // initial value for the integer

  Future<void> _showIntegerInputDialog(
      BuildContext context, String prayername) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(prayername),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Enter the number',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _value = int.tryParse(value) ?? -1;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Done'),
              onPressed: ()  {
                if (_value != -1) {
                   setCustom("${prayername.toLowerCase()}Missed", _value);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void setCustom(String name, int num) async {
    await prefs.setInt(name, num);
    setState(() {
      name == "fajrMissed"
          ? fajrMissed = num
          : name == "dhuhrMissed"
              ? dhuhrMissed = num
              : name == "asrMissed"
                  ? asrMissed = num
                  : name == "maghribMissed"
                      ? maghribMissed = num
                      : ishaMissed = num;
    });
  }

  void setPlus(String name, int num) async {
    if (num<999) {
      await prefs.setInt(name, num + 1);
    setState(() {
      name == "fajrMissed"
          ? fajrMissed = num + 1
          : name == "dhuhrMissed"
              ? dhuhrMissed = num + 1
              : name == "asrMissed"
                  ? asrMissed = num + 1
                  : name == "maghribMissed"
                      ? maghribMissed = num + 1
                      : ishaMissed = num + 1;
    });
    }
    
  }

  void setMinus(String name, int num) async {
    if (num >= 1) {
      await prefs.setInt(name, num - 1);
      setState(() {
        name == "fajrMissed"
            ? fajrMissed = num - 1
            : name == "dhuhrMissed"
                ? dhuhrMissed = num - 1
                : name == "asrMissed"
                    ? asrMissed = num - 1
                    : name == "maghribMissed"
                        ? maghribMissed = num - 1
                        : ishaMissed = num - 1;
      });
    }
  }

  Future getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fajrMissed = prefs.getInt("fajrMissed")!;
      dhuhrMissed = prefs.getInt("dhuhrMissed")!;
      asrMissed = prefs.getInt("asrMissed")!;
      maghribMissed = prefs.getInt("maghribMissed")!;
      ishaMissed = prefs.getInt("ishaMissed")!;
    });
  }

  @override
  void initState() {
    getPrefs();

    // TODO: implement initState

    super.initState();
  }

  Widget build(BuildContext context) {
    double spaceHeight = 20;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text("Missed Prayers"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MissedContainer(
                prayerName: "Fajr",
                missedNumber: fajrMissed,
                Color1: Color(0xff100e2a),
                Color2: Color(0xff2e2855),
                onClickAction: () {
                  setPlus("fajrMissed", fajrMissed);
                },
                onClickMinus: () {
                  setMinus("fajrMissed", fajrMissed);
                },
                onClickEdit: () {
                  _showIntegerInputDialog(context, "Fajr");
                },
              ),
              SizedBox(
                height: spaceHeight,
              ),
              MissedContainer(
                prayerName: "Dhuhr",
                missedNumber: dhuhrMissed,
                Color1: Color.fromARGB(255, 131, 208, 236),
                Color2: Color(0xffade0f2),
                onClickAction: () {
                  setPlus("dhuhrMissed", dhuhrMissed);
                },
                onClickMinus: () {
                  setMinus("dhuhrMissed", dhuhrMissed);
                },
                onClickEdit: () {
                  _showIntegerInputDialog(context, "Dhuhr");
                },
              ),
              SizedBox(
                height: spaceHeight,
              ),
              MissedContainer(
                prayerName: "Asr",
                missedNumber: asrMissed,
                Color1: Color(0xff4ca1dc),
                Color2: Color.fromARGB(255, 137, 191, 230),
                onClickAction: () {
                  setPlus("asrMissed", asrMissed);
                },
                onClickMinus: () {
                  setMinus("asrMissed", asrMissed);
                },
                onClickEdit: () {
                  _showIntegerInputDialog(context, "Asr");
                },
              ),
              SizedBox(
                height: spaceHeight,
              ),
              MissedContainer(
                prayerName: "Maghrib",
                missedNumber: maghribMissed,
                Color1: Color(0xff8a327d),
                Color2: Color(0xffc630a4),
                onClickAction: () {
                  setPlus("maghribMissed", maghribMissed);
                },
                onClickMinus: () {
                  setMinus("maghribMissed", maghribMissed);
                },
                onClickEdit: () {
                  _showIntegerInputDialog(context, "Maghrib");
                },
              ),
              SizedBox(
                height: spaceHeight,
              ),
              MissedContainer(
                prayerName: "Isha",
                missedNumber: ishaMissed,
                Color1: Color(0xff6f53a5),
                Color2: Color(0xffaa9cc7),
                onClickAction: () {
                  setPlus("ishaMissed", ishaMissed);
                },
                onClickMinus: () {
                  setMinus("ishaMissed", ishaMissed);
                },
                onClickEdit: () {
                  _showIntegerInputDialog(context, "Isha");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
