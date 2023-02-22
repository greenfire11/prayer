import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissedContainer extends StatelessWidget {
  MissedContainer({
    super.key,
    this.prayerName,
    this.missedNumber,
    this.Color1,
    this.Color2,
    required this.onClickAction,
    required this.onClickMinus,
    required this.onClickEdit,
  });
  final prayerName;
  final missedNumber;
  final Color1;
  final Color2;
  Function onClickAction;
  Function onClickMinus;
  Function onClickEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
                  onClickEdit();
                },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
            colors: [
              Color1,
              Color2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$prayerName",
              style: TextStyle(
                  color: Colors.white, fontSize: 33, fontWeight: FontWeight.w700),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    onClickMinus();
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "$missedNumber",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    onClickAction();
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
