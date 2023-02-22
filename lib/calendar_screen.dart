import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'main.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.lat,
    required this.lng,
  });
  final double lat;
  final double lng;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime date1 = DateTime.now();

  List prayerName = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
  List prayerTime2 = ["00:00", "00:00", "00:00", "00:00", "00:00"];
  List prayerTimesO = [
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00"
  ];
  void getPrayerTimes({bool refresh = false, required DateTime date}) async {
    String ti = await FlutterNativeTimezone.getLocalTimezone();
    final prefs = await SharedPreferences.getInstance();
    var loc = await prefs.getStringList("location");
    final timezone = await tz.getLocation(ti);
    String timezone21 = tzmap.latLngToTimezoneString(widget.lat, widget.lng);
    final timezone2 = await tz.getLocation(timezone21);

    bool format24 = prefs.getBool("24format")!;
    if (format24 == false) {
      setState(() {
        TimeSize = 17;
        print("changed size");
      });
    }

    Coordinates coordinates = Coordinates(widget.lat, widget.lng);
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
      prayerTime2 = [
        fajrTime,
        dhuhrTime,
        asrTime,
        maghribTime,
        ishaTime,
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
    });
    print(date);
  }

  double TimeSize = 21;
  @override
  void initState() {
    getPrayerTimes(date: date1);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    double height3 = height - padding.top - kToolbarHeight;
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
              child: CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  print("date: $date");
                  setState(() {
                    date1 = date;
                    getPrayerTimes(date: date);
                  });
                },
                thisMonthDayBorderColor: Colors.transparent,
                selectedDayButtonColor: Colors.blue,
                selectedDayBorderColor: Colors.blue,
                selectedDayTextStyle: TextStyle(color: Colors.black),
                weekendTextStyle: TextStyle(color: Colors.black),
                daysTextStyle: TextStyle(color: Colors.black),
                nextDaysTextStyle: TextStyle(color: Colors.grey),
                prevDaysTextStyle: TextStyle(color: Colors.grey),
                weekdayTextStyle: TextStyle(color: Colors.grey),
                weekDayFormat: WeekdayFormat.short,
                firstDayOfWeek: 0,
                showHeader: true,
                locale: Localizations.localeOf(context).toString(),
                isScrollable: true,
                weekFormat: false,
                height: 370,
                selectedDateTime: date1,
                daysHaveCircularBorder: true,
                customGridViewPhysics: AlwaysScrollableScrollPhysics(),
                markedDateWidget: Container(
                  height: 3,
                  width: 3,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(height3 / 5 * 2.8)),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            DateFormat('d MMM y').format(date1),
            style: TextStyle(color: Colors.grey, fontSize: 20),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 60,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: prayerName.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 30); // Change the height as per your need
                },
                itemBuilder: (context, index) {
                  final name = prayerName[index];
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        
                         Expanded(
                           child: Visibility(
                            visible: prayerTime2[0] == prayerTimesO[0]
                                    ? false
                                    : true,
                                maintainSize: false,
                             child: Text(
                                    prayerTimesO[index],
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: Colors.black, fontSize: 20),
                                  ),
                           ),
                         ),
                         
                            
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              prayerTime2[index],
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
