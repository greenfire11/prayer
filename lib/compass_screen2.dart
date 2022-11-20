import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'compass_view.dart';

class CompassScreen2 extends StatefulWidget {
  const CompassScreen2({super.key});

  @override
  State<CompassScreen2> createState() => _CompassScreen2State();
}

class _CompassScreen2State extends State<CompassScreen2> {
  double? _bearing = 121;

  void getQibla() async {
    final prefs = await SharedPreferences.getInstance();
    var lat = prefs.getStringList("location")![0];
    var long = prefs.getStringList("location")![1];
    setState(() {
      _bearing =
          Qibla.qibla(Coordinates(double.parse(lat), double.parse(long)));
    });
  }

  void _setBearing(double heading) {
    setState(() {
      _bearing = heading;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getQibla();
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final heading = snapshot.data?.heading ?? 0;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${heading.ceil()}°",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
              SizedBox(height: 40,),
              Align(
                alignment: const Alignment(0, -0.2),
                child: CompassView(
                  bearing: _bearing,
                  heading: heading,
                ),
              ),
              SizedBox(height: 50,),
              Text("Qibla is ${_bearing!.ceil()}°",style: TextStyle(color: Colors.white),)
            ],
          ),
        );
      },
    );
  }
}
