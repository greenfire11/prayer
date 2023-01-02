// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:prayer/compass_screen.dart';
import 'package:prayer/dua_text.dart';
import 'package:prayer/settings_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api/notification_api.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'compass_screen2.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

String format(date) {
  return DateFormat.Hm().format(date);
}

final calcMethods = {
  "Muslim World League": CalculationMethod.MuslimWorldLeague(),
  "Egyptian": CalculationMethod.Egyptian(),
  "Umm al Qura": CalculationMethod.UmmAlQura(),
  "Dubai": CalculationMethod.Dubai(),
  "Qatar": CalculationMethod.Qatar(),
  "Kuwait": CalculationMethod.Kuwait(),
  "Singapore": CalculationMethod.Singapore(),
  "Turkey": CalculationMethod.Turkey(),
  "Tehran": CalculationMethod.Tehran(),
  "North America": CalculationMethod.NorthAmerica(),
};

final madhab = {"shafi": Madhab.Shafi, "hanafi": Madhab.Hanafi};

List<DateTime> getDataDay(addDay, lat, long, ti, mad, method) {
  final timezone = tz.getLocation(ti);
  DateTime date = new tz.TZDateTime.from(
      DateTime.now().add(Duration(days: addDay)), timezone);

  Coordinates coordinates =
      new Coordinates(double.parse(lat), double.parse(long));
  CalculationParameters params = calcMethods[method];
  params.madhab = madhab[mad];
  PrayerTimes prayerTimes = new PrayerTimes(coordinates, date, params);
  String next =
      prayerTimes.nextPrayer(date: DateTime.now().add(Duration(hours: 0)));

  DateTime one = tz.TZDateTime.from(prayerTimes.fajr!, timezone);
  DateTime two = tz.TZDateTime.from(prayerTimes.sunrise!, timezone);
  DateTime three = tz.TZDateTime.from(prayerTimes.dhuhr!, timezone);
  DateTime four = tz.TZDateTime.from(prayerTimes.asr!, timezone);
  DateTime five = tz.TZDateTime.from(prayerTimes.maghrib!, timezone);
  DateTime six = tz.TZDateTime.from(prayerTimes.isha!, timezone);

  return [
    one,
    two,
    three,
    four,
    five,
    six,
  ];
}

void createNoti(lat, long, ti, mad, method) async {
  for (int i = 2; i < 8; i++) {
    var dataOfPrayer = getDataDay(i - 1, lat, long, ti, mad, method);
    for (int n = 1; n < 6; n++) {
      if (n == 1) {
        await NotificationApi.showScheduledNotification(
          id: (i - 1) * 5 + n,
          title: "Fajr Time",
          body: format(dataOfPrayer[0]),
          scheduledDate: dataOfPrayer[0],
        );
      } else if (n == 2) {
        await NotificationApi.showScheduledNotification(
          id: (i - 1) * 5 + n,
          title: "Dhuhr Time",
          body: format(dataOfPrayer[2]),
          scheduledDate: dataOfPrayer[2],
        );
      } else if (n == 3) {
        await NotificationApi.showScheduledNotification(
          id: (i - 1) * 5 + n,
          title: "Asr Time",
          body: format(dataOfPrayer[3]),
          scheduledDate: dataOfPrayer[3],
        );
      } else if (n == 4) {
        await NotificationApi.showScheduledNotification(
          id: (i - 1) * 5 + n,
          title: "Maghrib Time",
          body: format(dataOfPrayer[4]),
          scheduledDate: dataOfPrayer[4],
        );
      } else if (n == 5) {
        await NotificationApi.showScheduledNotification(
          id: (i - 1) * 5 + n,
          title: "Isha Time",
          body: format(dataOfPrayer[5]),
          scheduledDate: dataOfPrayer[5],
        );
      }
    }
  }
}

String getNext(lat, long, ti, mad, method) {
  final timezone = tz.getLocation(ti);
  DateTime date = new tz.TZDateTime.from(DateTime.now(), timezone);

  Coordinates coordinates =
      new Coordinates(double.parse(lat), double.parse(long));
  CalculationParameters params = calcMethods[method];
  params.madhab = madhab[mad];
  PrayerTimes prayerTimes = new PrayerTimes(coordinates, date, params);
  String next =
      prayerTimes.nextPrayer(date: DateTime.now().add(Duration(hours: 0)));
  return next;
}

const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
const simplePeriodic1HourTask =
    "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simplePeriodicTask:
        tz.initializeTimeZones();
        String ti = await FlutterNativeTimezone.getLocalTimezone();
        final prefs = await SharedPreferences.getInstance();
        var lat = prefs.getStringList("location")![0];
        var long = prefs.getStringList("location")![1];
        var mad = prefs.getString("madhab");
        var method = prefs.getString("method");
        var today = getDataDay(0, lat, long, ti, mad, method);
        DateTime fajr1 = today[0];
        DateTime dhuhr1 = today[2];
        DateTime asr1 = today[3];
        DateTime maghrib1 = today[4];
        DateTime isha1 = today[5];
        String next = getNext(lat, long, ti, mad, method);
        print(next);
        if (1 != 2) {
          if (next == "fajr") {
            await NotificationApi.showScheduledNotification(
              id: 1,
              title: "Fajr Time",
              body: format(fajr1),
              scheduledDate: fajr1,
            );
            prefs.setString("nextNoti", "fajr");
            await NotificationApi.showScheduledNotification(
              id: 2,
              title: "Dhuhr Time",
              body: format(dhuhr1),
              scheduledDate: dhuhr1,
            );
            await NotificationApi.showScheduledNotification(
              id: 3,
              title: "Asr Time",
              body: format(asr1),
              scheduledDate: asr1,
            );
            await NotificationApi.showScheduledNotification(
              id: 4,
              title: "Maghrib Time",
              body: format(maghrib1),
              scheduledDate: maghrib1,
            );
            await NotificationApi.showScheduledNotification(
              id: 5,
              title: "Isha Time",
              body: format(isha1),
              scheduledDate: isha1,
            );
          } else if (next == "dhuhr") {
            await NotificationApi.showScheduledNotification(
              id: 2,
              title: "Dhuhr Time",
              body: format(dhuhr1),
              scheduledDate: dhuhr1,
            );
            prefs.setString("nextNoti", "dhuhr");
            await NotificationApi.showScheduledNotification(
              id: 3,
              title: "Asr Time",
              body: format(asr1),
              scheduledDate: asr1,
            );
            await NotificationApi.showScheduledNotification(
              id: 4,
              title: "Maghrib Time",
              body: format(maghrib1),
              scheduledDate: maghrib1,
            );
            await NotificationApi.showScheduledNotification(
              id: 5,
              title: "Isha Time",
              body: format(isha1),
              scheduledDate: isha1,
            );
          } else if (next == "asr") {
            print("asr runing");
            await NotificationApi.showScheduledNotification(
              id: 3,
              title: "Asr Time",
              body: format(asr1),
              scheduledDate: asr1,
            );
            print(asr1.toString());
            prefs.setString("nextNoti", "asr");
            await NotificationApi.showScheduledNotification(
              id: 4,
              title: "Maghrib Time",
              body: format(maghrib1),
              scheduledDate: maghrib1,
            );
            await NotificationApi.showScheduledNotification(
              id: 5,
              title: "Isha Time",
              body: format(isha1),
              scheduledDate: isha1,
            );
          } else if (next == "maghrib") {
            print("maghrib ran");
            await NotificationApi.showScheduledNotification(
                id: 4,
                title: "Maghrib Time",
                body: format(maghrib1),
                scheduledDate: maghrib1,
                payload: maghrib1.toString());
            prefs.setString("nextNoti", "maghrib");
            await NotificationApi.showScheduledNotification(
              id: 5,
              title: "Isha Time",
              body: format(isha1),
              scheduledDate: isha1,
            );
          } else if (next == "isha") {
            await NotificationApi.showScheduledNotification(
              id: 5,
              title: "Isha Time",
              body: format(isha1),
              scheduledDate: isha1,
            );
            prefs.setString("nextNoti", "isha");
          } else if (next == "fajrafter") {
            prefs.setString("nextNoti", "fajrafter");
          }
          createNoti(lat, long, ti, mad, method);
        }

        print("simple task was run");

        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory? tempDir = await getTemporaryDirectory();
        String? tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}

void initTimeZone() {
  tz.initializeTimeZones();
}

late Position position2;
void determinePosition2() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  position2 = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList("location",
      [position2.latitude.toString(), position2.longitude.toString()]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationApi.init();
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  String ti = await FlutterNativeTimezone.getLocalTimezone();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('location') == false) {
    prefs.setStringList('location', <String>["46.180370", "6.095370"]);

    await Permission.locationWhenInUse.request();
  }
  if (prefs.containsKey('method') == false) {
    prefs.setString("method", "Tehran");
    prefs.setString("madhab", "shafi");
  }
  var lat = prefs.getStringList("location")![0];
  var long = prefs.getStringList("location")![1];
  var mad = prefs.getString("madhab");
  var method = prefs.getString("method");
  if (prefs.containsKey("nextNoti") == false) {
    var today = getDataDay(0, lat, long, ti, mad, method);
    DateTime fajr1 = today[0];
    DateTime dhuhr1 = today[2];
    DateTime asr1 = today[3];
    DateTime maghrib1 = today[4];
    String next = getNext(lat, long, ti, mad, method);
    DateTime isha1 = today[5];

    if (next == "fajr") {
      await NotificationApi.showScheduledNotification(
        id: 1,
        title: "Fajr Time",
        body: format(fajr1),
        scheduledDate: fajr1,
      );
      prefs.setString("nextNoti", "fajr");
      await NotificationApi.showScheduledNotification(
        id: 2,
        title: "Dhuhr Time",
        body: format(dhuhr1),
        scheduledDate: dhuhr1,
      );
      await NotificationApi.showScheduledNotification(
        id: 3,
        title: "Asr Time",
        body: format(asr1),
        scheduledDate: asr1,
      );
      await NotificationApi.showScheduledNotification(
        id: 4,
        title: "Maghrib Time",
        body: format(maghrib1),
        scheduledDate: maghrib1,
      );
      await NotificationApi.showScheduledNotification(
        id: 5,
        title: "Isha Time",
        body: format(isha1),
        scheduledDate: isha1,
      );
    } else if (next == "dhuhr") {
      await NotificationApi.showScheduledNotification(
        id: 2,
        title: "Dhuhr Time",
        body: format(dhuhr1),
        scheduledDate: dhuhr1,
      );
      prefs.setString("nextNoti", "dhuhr");
      await NotificationApi.showScheduledNotification(
        id: 3,
        title: "Asr Time",
        body: format(asr1),
        scheduledDate: asr1,
      );
      await NotificationApi.showScheduledNotification(
        id: 4,
        title: "Maghrib Time",
        body: format(maghrib1),
        scheduledDate: maghrib1,
      );
      await NotificationApi.showScheduledNotification(
        id: 5,
        title: "Isha Time",
        body: format(isha1),
        scheduledDate: isha1,
      );
    } else if (next == "asr") {
      print("asr runing");
      await NotificationApi.showScheduledNotification(
        id: 3,
        title: "Asr Time",
        body: format(asr1),
        scheduledDate: asr1,
      );
      print(asr1.toString());
      prefs.setString("nextNoti", "asr");
      await NotificationApi.showScheduledNotification(
        id: 4,
        title: "Maghrib Time",
        body: format(maghrib1),
        scheduledDate: maghrib1,
      );
      await NotificationApi.showScheduledNotification(
        id: 5,
        title: "Isha Time",
        body: format(isha1),
        scheduledDate: isha1,
      );
    } else if (next == "maghrib") {
      print("maghrib ran");
      await NotificationApi.showScheduledNotification(
          id: 4,
          title: "Maghrib Time",
          body: format(maghrib1),
          scheduledDate: maghrib1,
          payload: maghrib1.toString());
      prefs.setString("nextNoti", "maghrib");
      await NotificationApi.showScheduledNotification(
        id: 5,
        title: "Isha Time",
        body: format(isha1),
        scheduledDate: isha1,
      );
    } else if (next == "isha") {
      await NotificationApi.showScheduledNotification(
        id: 5,
        title: "Isha Time",
        body: format(isha1),
        scheduledDate: isha1,
      );
      prefs.setString("nextNoti", "isha");
    } else if (next == "fajrafter") {
      prefs.setString("nextNoti", "fajrafter");
    }
    createNoti(lat, long, ti, mad, method);
  }

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  Workmanager().registerPeriodicTask(
    "Notfi",
    simplePeriodicTask,
    initialDelay: Duration(seconds: 0),
    frequency: Duration(hours: 1),
    constraints: Constraints(
      // connected or metered mark the task as requiring internet
      networkType: NetworkType.connected,
      // require external power
      requiresCharging: false,
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
  var pendingNotificationRequests2 =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  for (int i = 0; i < pendingNotificationRequests2.length; i++) {
    print(pendingNotificationRequests2[i].body.toString() + "dsjhf");
  }

  print(prefs.getString("nextNoti"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = "Loading";
  List prayerNames = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"];
  List prayerTimes2 = ["00:00", "00:00", "00:00", "00:00", "00:00", "00:00"];
  List<Color> firstGrad = [
    Color(0xff100e2a), //fajr
    Color(0xffeb6344),
    Color.fromARGB(255, 131, 208, 236), //sunrise
    Color(0xff4ca1dc),
    //asr
    Color(0xff8a327d),
    Color(0xff6f53a5), //isha
  ];
  List secondGrad = [
    Color(0xff2e2855), //fajr
    Color(0xffeaab94), //sunrise
    Color(0xffade0f2),
    Color.fromARGB(255, 137, 191, 230),
    //asr
    Color(0xffc630a4),
    Color(0xffaa9cc7), //isha
  ];

  List mosqueFront = [
    Colors.black, //fajr
    Color.fromARGB(255, 24, 19, 18), //sunrise
    Color.fromARGB(255, 23, 33, 54),
    Color.fromARGB(255, 23, 33, 54), //asr
    Color.fromARGB(255, 21, 23, 41),
    Color.fromARGB(255, 21, 23, 41), //isha
  ];
  int nextPrayer = -1;
  String nextPrayerTime = "00:00";
  late Position position;
  void _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("location",
        [position.latitude.toString(), position.longitude.toString()]);
  }

  void getPrayerTimes({bool refresh = false}) async {
    String ti = await FlutterNativeTimezone.getLocalTimezone();
    final prefs = await SharedPreferences.getInstance();
    var loc = prefs.getStringList("location");
    final timezone = tz.getLocation(ti);
    DateTime date = tz.TZDateTime.from(DateTime.now(), timezone);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(loc![0]),
        double.parse(loc![1]),
      );
      setState(() {
        name = placemarks.first.locality.toString();
      });
    } catch (e) {
      setState(() {
        name = "No internet";
        nextPrayer = 0;
      });
    }

    Coordinates coordinates =
        Coordinates(double.parse(loc![0]), double.parse(loc![1]));
    var mad = prefs.getString("madhab");
    var method = prefs.getString("method");
    CalculationParameters params = calcMethods[method];
    params.madhab = madhab[mad];
    PrayerTimes prayerTimes = PrayerTimes(coordinates, date, params);

    String fajrTime = format(tz.TZDateTime.from(prayerTimes.fajr!, timezone));
    String sunriseTime =
        format(tz.TZDateTime.from(prayerTimes.sunrise!, timezone));
    String dhuhrTime = format(tz.TZDateTime.from(prayerTimes.dhuhr!, timezone));
    String asrTime = format(tz.TZDateTime.from(prayerTimes.asr!, timezone));
    String maghribTime =
        format(tz.TZDateTime.from(prayerTimes.maghrib!, timezone));
    String ishaTime = format(tz.TZDateTime.from(prayerTimes.isha!, timezone));
    String fajrTimeafter =
        format(tz.TZDateTime.from(prayerTimes.fajrafter!, timezone));

    setState(() {
      String next = prayerTimes.nextPrayer();
      if (refresh == false) {
        nextPrayer = next == "fajrafter"
            ? 0
            : next == "fajr"
                ? 0
                : next == "dhuhr"
                    ? 2
                    : next == "asr"
                        ? 3
                        : next == "maghrib"
                            ? 4
                            : next == "isha"
                                ? 5
                                : 0;
      }

      nextPrayerTime = next == "fajrafter"
          ? fajrTimeafter
          : next == "fajr"
              ? fajrTime
              : next == "dhuhr"
                  ? dhuhrTime
                  : next == "asr"
                      ? asrTime
                      : next == "maghrib"
                          ? maghribTime
                          : next == "isha"
                              ? ishaTime
                              : fajrTime;
      prayerTimes2 = [
        fajrTime,
        sunriseTime,
        dhuhrTime,
        asrTime,
        maghribTime,
        ishaTime
      ];
    });
    print(nextPrayer);
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrayerTimes(refresh: false);

    super.initState();
  }

  AppBar appbar = AppBar(
    centerTitle: true,
    leading: Container(
      child: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {},
      ),
    ),
    backgroundColor: Colors.transparent,
    title: Text("Next prayer time"),
    actions: [
      Container(
        child: IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () {},
        ),
      ),
    ],
  );
  var controller123 = SidebarXController(selectedIndex: 0, extended: false);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _key,
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
            SidebarXItem(icon: Icons.home, label: 'Home'),
            SidebarXItem(
              icon: Icons.explore,
              label: 'Qibla',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompassScreen2()),
                );
                setState(() {
                  controller123 =
                      SidebarXController(selectedIndex: 0, extended: false);
                });
              },
            ),
            SidebarXItem(
              icon: Icons.settings,
              label: "Settings",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
                setState(() {
                  controller123 =
                      SidebarXController(selectedIndex: 0, extended: false);
                });
              },
            ),

            /// SidebarXItem(
            ///   icon: Icons.menu_book,
            ///   label: "Dua",
            ///   onTap: () {
            ///     Navigator.pop(context);
            ///     Navigator.push(
            ///       context,
            ///       MaterialPageRoute(builder: (context) => DuaText()),
            ///     );
            ///     setState(() {
            ///       controller123 =
            ///           SidebarXController(selectedIndex: 0, extended: false);
            ///     });
            ///   },
            /// ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                firstGrad[nextPrayer],
                secondGrad[nextPrayer],
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              AppBar(
                centerTitle: true,
                leading: Container(
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _key.currentState!.openDrawer();
                    },
                  ),
                ),
                backgroundColor: Colors.transparent,
                title: Text("Next prayer time"),
                actions: [
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.refresh_rounded),
                      onPressed: () {
                        _determinePosition();
                        getPrayerTimes(refresh: true);
                      },
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/images/mosques_background.svg',
                alignment: Alignment.bottomCenter,
                width: (MediaQuery.of(context).size.width),
                height: MediaQuery.of(context).size.height,
                color: Color.fromARGB(255, 29, 25, 52),
              ),
              Container(
                  child: (() {
                if (nextPrayer == 0 || nextPrayer == 4 || nextPrayer == 5) {
                  return Stack(
                    children: [
                      Align(
                        child: Image.asset("assets/images/moon.png"),
                        alignment: Alignment.center,
                      ),
                      Align(
                        child: SizedBox(
                          child: Image.asset("assets/images/moon_b.png"),
                          height: 133,
                        ),
                        alignment: Alignment.center,
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SvgPicture.asset(
                      'assets/images/assr_sun_detail.svg',
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width),
                      height: MediaQuery.of(context).size.height,
                    ),
                  );
                }
              }())),
              SvgPicture.asset(
                'assets/images/mosques_foreground2.svg',
                alignment: Alignment.bottomCenter,
                width: (MediaQuery.of(context).size.width),
                height: MediaQuery.of(context).size.height,
                color: mosqueFront[nextPrayer],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: appbar.preferredSize.height + 50,
                      ),
                      Text(
                        "$name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        nextPrayerTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 65,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 216,
                  color: Colors.transparent,
                  child: CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 0.75,
                    diameterRatio: 3,
                    useMagnifier: true,
                    itemExtent: 50,
                    scrollController: FixedExtentScrollController(
                        initialItem: nextPrayer != -1 ? nextPrayer : 0),
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) async {
                      setState(() {
                        nextPrayer = selectedItem;
                      });

                      print(nextPrayer);
                    },
                    children:
                        List<Widget>.generate(prayerNames.length, (int index) {
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              prayerNames[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              prayerTimes2[index],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
