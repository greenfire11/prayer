import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;

class CityTimeScreen extends StatefulWidget {
  const CityTimeScreen({super.key, this.lat, this.lng, this.city});
  final lat;
  final lng;
  final city;

  @override
  State<CityTimeScreen> createState() => _CityTimeScreenState();
}

class _CityTimeScreenState extends State<CityTimeScreen> {
  String name = "Loading";
  List prayerNames = [
    "Fajr",
    "Sunrise",
    "Dhuhr",
    "Asr",
    "Maghrib",
    "Isha",
    "Midnight"
  ];
  List prayerTimes2 = [
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00"
  ];
  List prayerTimesO = [
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00"
  ];
  late FixedExtentScrollController scrollController;
  List<Color> firstGrad = [
    Color(0xff100e2a), //fajr
    Color(0xffeb6344),
    Color.fromARGB(255, 131, 208, 236), //sunrise
    Color(0xff4ca1dc),
    //asr
    Color(0xff8a327d),
    Color(0xff6f53a5),
    Color.fromARGB(255, 24, 0, 71), //isha
  ];
  List secondGrad = [
    Color(0xff2e2855), //fajr
    Color(0xffeaab94), //sunrise
    Color(0xffade0f2),
    Color.fromARGB(255, 137, 191, 230),
    //asr
    Color(0xffc630a4),
    Color(0xffaa9cc7),
    Color.fromARGB(255, 141, 116, 192), //isha
  ];

  List mosqueFront = [
    Colors.black, //fajr
    Color.fromARGB(255, 24, 19, 18), //sunrise
    Color.fromARGB(255, 23, 33, 54),
    Color.fromARGB(255, 23, 33, 54), //asr
    Color.fromARGB(255, 21, 23, 41),
    Color.fromARGB(255, 21, 23, 41),
    Color.fromARGB(255, 21, 23, 41), //isha
  ];
  int nextPrayer = -1;
  String nextPrayerTime = "00:00";
  late Position position;

  void getPrayerTimes({bool refresh = false}) async {
    setState(() {
      name = widget.city;
    });
    String ti = await FlutterNativeTimezone.getLocalTimezone();
    final prefs = await SharedPreferences.getInstance();
    var loc = await prefs.getStringList("location");
    final timezone = await tz.getLocation(ti);
    String timezone21 = tzmap.latLngToTimezoneString(
        double.parse(widget.lat), double.parse(widget.lng));
    final timezone2 = await tz.getLocation(timezone21);
    print("TimeZone: $timezone");
    print("TimeZone2: $timezone21");

    bool format24 = prefs.getBool("24format")!;
    if (format24 == false) {
      setState(() {
        TimeSize = 17;
        print("changed size");
      });
    }
    DateTime date = tz.TZDateTime.from(DateTime.now(), timezone);

    Coordinates coordinates =
        Coordinates(double.parse(widget.lat), double.parse(widget.lng));
    var mad = prefs.getString("madhab");
    var method = prefs.getString("method");
    CalculationParameters params = calcMethods[method];
    params.madhab = madhab[mad];
    PrayerTimes prayerTimes = PrayerTimes(coordinates, date, params);
    SunnahTimes sunnahTimes = SunnahTimes(prayerTimes);

    String fajrTime = format(tz.TZDateTime.from(prayerTimes.fajr!, timezone),
        format24: format24);
    String sunriseTime = format(
        tz.TZDateTime.from(prayerTimes.sunrise!, timezone),
        format24: format24);
    String dhuhrTime = format(tz.TZDateTime.from(prayerTimes.dhuhr!, timezone),
        format24: format24);
    String asrTime = format(tz.TZDateTime.from(prayerTimes.asr!, timezone),
        format24: format24);
    String maghribTime = format(
        tz.TZDateTime.from(prayerTimes.maghrib!, timezone),
        format24: format24);
    String ishaTime = format(tz.TZDateTime.from(prayerTimes.isha!, timezone),
        format24: format24);
    String fajrTimeafter = format(
        tz.TZDateTime.from(prayerTimes.fajrafter!, timezone),
        format24: format24);
    String midnightTime = format(
        tz.TZDateTime.from(sunnahTimes.middleOfTheNight, timezone),
        format24: format24);
    print("midnight is $midnightTime");

    String fajrTime2 = format(tz.TZDateTime.from(prayerTimes.fajr!, timezone2),
        format24: format24);
    String sunriseTime2 = format(
        tz.TZDateTime.from(prayerTimes.sunrise!, timezone2),
        format24: format24);
    String dhuhrTime2 = format(
        tz.TZDateTime.from(prayerTimes.dhuhr!, timezone2),
        format24: format24);
    String asrTime2 = format(tz.TZDateTime.from(prayerTimes.asr!, timezone2),
        format24: format24);
    String maghribTime2 = format(
        tz.TZDateTime.from(prayerTimes.maghrib!, timezone2),
        format24: format24);
    String ishaTime2 = format(tz.TZDateTime.from(prayerTimes.isha!, timezone2),
        format24: format24);
    String fajrTimeafter2 = format(
        tz.TZDateTime.from(prayerTimes.fajrafter!, timezone2),
        format24: format24);
    String midnightTime2 = format(
        tz.TZDateTime.from(sunnahTimes.middleOfTheNight, timezone2),
        format24: format24);

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
        scrollController = FixedExtentScrollController(initialItem: nextPrayer);
      }
      if (refresh == true) {
        print("THIS IS RUNNING");
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
        scrollController.animateToItem(nextPrayer,
            duration: Duration(milliseconds: 10), curve: Curves.easeIn);
        print(scrollController.selectedItem);
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
        ishaTime,
        midnightTime,
      ];
      prayerTimesO = [
        fajrTime2,
        sunriseTime2,
        dhuhrTime2,
        asrTime2,
        maghribTime2,
        ishaTime2,
        midnightTime2,
      ];
      print(prayerTimesO);
    });
    print(nextPrayer);
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
  var controller123 = SidebarXController(selectedIndex: 0, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  double TimeSize = 21;
  @override
  void initState() {
    // TODO: implement initState
    getPrayerTimes(refresh: false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              backgroundColor: Colors.transparent,
              title: Text("${widget.city}"),
              
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
              if (nextPrayer == 0 ||
                  nextPrayer == 4 ||
                  nextPrayer == 5 ||
                  nextPrayer == 6) {
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
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Next prayer",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            nextPrayerTime,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "local time",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
                  scrollController: scrollController,
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
                          Visibility(
                            visible: prayerTimes2[0] == prayerTimesO[0]
                                ? false
                                : true,
                            maintainSize: false,
                            child: Text(
                              prayerTimesO[index],
                              style: TextStyle(color: Colors.white,fontSize: TimeSize),
                            ),
                          ),
                          Text(
                            prayerTimes2[index],
                            style: TextStyle(
                                color: Colors.white, fontSize: TimeSize),
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
    );
  }
}
