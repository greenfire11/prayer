// ignore_for_file: prefer_const_constructors

import 'dart:math' as math;

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

import 'dua_text.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CompassScreenState createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  bool _hasPermissions = false;
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;

  var _qibla = 0.0;

  void getQibla() async {
    final prefs = await SharedPreferences.getInstance();
    var lat = prefs.getStringList("location")![0];
    var long = prefs.getStringList("location")![1];
    setState(() {
      _qibla = Qibla.qibla(Coordinates(double.parse(lat), double.parse(long)));
    });
  }

  @override
  void initState() {
    super.initState();
    getQibla();
    _fetchPermissionStatus();
  }

  @override
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var controller123=SidebarXController(selectedIndex: 1, extended: false);
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: SidebarX(
            theme: const SidebarXTheme(
                textStyle: TextStyle(color: Colors.white),
                iconTheme: IconThemeData(
                  color: Colors.white,
                  size: 20,
                ),
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 45, 45, 45))),
            extendedTheme: const SidebarXTheme(
              width: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
              ),
            ),
            controller: controller123,
            items: [
              SidebarXItem(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                    setState(() {
                      controller123=SidebarXController(selectedIndex: 1, extended: false);
                    });
                  }),
              SidebarXItem(
                icon: Icons.explore,
                label: 'Qibla',
                onTap: () {},
              ),
              /// SidebarXItem(
              ///     icon: Icons.menu_book,
              ///     label: "Dua",
              ///     onTap: () {
              ///       Navigator.pop(context);
              ///       Navigator.push(
              ///         context,
              ///         MaterialPageRoute(builder: (context) => DuaText()),
              ///       );
              ///       setState(() {
              ///         controller123=SidebarXController(selectedIndex: 1, extended: false);
              ///       });
              ///     })
            ],
          ),
          key: _key,
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            leading: Container(
              child: IconButton(
                icon: Icon(Icons.menu),
                color: Colors.black,
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
              ),
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Qibla Compass",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Container(
                child: IconButton(
                  icon: Icon(Icons.refresh_rounded),
                  color: Colors.black,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          body: Builder(builder: (context) {
            if (_hasPermissions) {
              return Column(
                children: <Widget>[
                  Text(""),
                  Expanded(child: _buildCompass()),
                ],
              );
            } else {
              return _buildPermissionSheet();
            }
          }),
        ),
      ),
    );
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: Text('Read Value'),
            onPressed: () async {
              final CompassEvent tmp = await FlutterCompass.events!.first;
              setState(() {
                _lastRead = tmp;
                _lastReadAt = DateTime.now();
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$_lastRead fdahfd',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '$_lastReadAt',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message

        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              direction.round() < 0
                  ? (360 + direction.round()).toString() + "°"
                  : direction.round().toString() + "°",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: (direction * (math.pi / 180) * -1),
                      child: Image.asset(
                        'assets/images/cadrant.png',
                        color: Colors.black,
                        scale: 1.1,
                      ),
                    ),
                    Transform.rotate(
                      angle: (direction * (math.pi / 180) * -1),
                      child: Image.asset(
                        'assets/images/needle_compass.png',
                        scale: 1.1,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text("Qibla:" + _qibla.round().toString())
          ],
        );
      },
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          ElevatedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }
}
