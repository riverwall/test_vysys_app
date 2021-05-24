import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:test_vysys_app/main.dart';
import 'package:test_vysys_app/vysysScreenFour.dart';

import 'data_branch.dart';

class ScreenThree extends StatefulWidget {
  final Map data;

  ScreenThree({this.data});

  @override
  _ScreenThreeState createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  //TODO nacitat datumy
  Future<List<DateTime>> futureDatesList;

  @override
  void initState() {
    super.initState();

    Map service = widget.data["service"];
    Branch branch = widget.data["branch"];

    futureDatesList = dateList(service["publicId"], branch.publicId);
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController dateTextField = TextEditingController();

  bool containsDay(DateTime selectedDate, List<DateTime> dateList) {
    for (var i = 0; i < dateList.length; i++) {
      if (dateList[i].compareTo(selectedDate) == 0) {
        return true;
      }
    }

    return false;
  }

  selectDate(
      BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: snapshot.data[0],
        firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2),
//                  selectableDayPredicate: (DateTime val) => snapshot.data.contains(val) ? true : false
        selectableDayPredicate: (DateTime day) =>
            containsDay(day, snapshot.data));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateTextField.text = "${selectedDate.toLocal()}".split(' ')[0];

        //TODO docasne
        nextScreen();
      });
  }

  nextScreen(){
    widget.data['date'] = selectedDate;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => ScreenFour(
              data: widget.data,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dátum rezervácie"),
        ),
        body: FutureBuilder<List<DateTime>>(
          future: futureDatesList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.date_range),
                    onPressed: () => selectDate(context, snapshot),
                  )),
                  Flexible(
                      child: TextField(
                    controller: dateTextField,
                    decoration: InputDecoration(labelText: "Dátum: "),
                    onTap: () => selectDate(context, snapshot),
                  )),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
