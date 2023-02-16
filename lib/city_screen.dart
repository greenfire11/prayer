import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:prayer/city_time_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _cities = [];
  dynamic _selectedCity;
  List _filteredCities = [];
  List myCities = [];
  FocusNode foc = FocusNode();
  Future<List<dynamic>> loadCityData() async {
    final cityJson = await rootBundle.loadString('assets/images/city.json');
    return json.decode(cityJson);
  }

  Future getMyCities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringCity = prefs.getStringList("myCities");
    List<int>? intProductList = stringCity?.map((i) => int.parse(i)).toList();

    setState(() {
      myCities = intProductList!;
    });
  }

  Future addCity() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> strList = myCities.map((i) => i.toString()).toList();
    await prefs.setStringList("myCities", strList);
  }

  @override
  void initState() {
    super.initState();
    loadCityData().then((cities) {
      setState(() {
        _cities = cities;
      });
    });
    getMyCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('City Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                   Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: foc,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: 'Search for a city...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (query) {
                  setState(() {
                    // filter the list of cities based on the user's query
                    _filteredCities = _cities
                        .where((city) => city['name']
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: _searchController.text != ""
                ? ListView.builder(
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(city['name']),
                        subtitle: Text(city['country']),
                        onTap: ()  {
                          var cit =
                              _cities.indexWhere((city2) => city2 == city);

                          setState(() {
                            myCities.add(cit);

                            _filteredCities = [];
                            foc.unfocus();

                            _searchController.text = "";
                          });
                          addCity();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CityTimeScreen(
                                      city: city['name'],
                                      lat: city['lat'],
                                      lng: city['lng'],
                                    )),
                          );
                        },
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: myCities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[myCities[index]];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        key: ValueKey<int>(myCities[index]),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            myCities.removeAt(index);
                          });
                          addCity();
                        },
                        child: ListTile(
                          tileColor: Colors.white,
                          
                          title: Text(city['name']),
                          subtitle: Text(city['country']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CityTimeScreen(
                                        city: city['name'],
                                        lat: city['lat'],
                                        lng: city['lng'],
                                      )),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
