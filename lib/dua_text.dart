// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dua_data.dart';

class DuaText extends StatefulWidget {
  const DuaText({super.key});

  @override
  State<DuaText> createState() => _DuaTextState();
}

class _DuaTextState extends State<DuaText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              Text(DuaData.maghribArabic[index],style: TextStyle(fontSize: 23),),
              
              Text(DuaData.maghribEnglish[index],style: TextStyle(fontSize: 23),textAlign: TextAlign.center,),
              SizedBox(height: 20,),
            ],
          ),
        );
      },
      itemCount: DuaData.maghribArabic.length,
      padding: EdgeInsets.only(top: 50),
      ),
      
    );
  }
}
