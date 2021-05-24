import 'package:flutter/material.dart';
import 'package:test_vysys_app/main.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

import 'data_branch.dart';

class ScreenFour extends StatefulWidget {
  final Map data;

  ScreenFour({this.data});

  @override
  _ScreenFourState createState() => _ScreenFourState();
}

class _ScreenFourState extends State<ScreenFour> {
  //TODO nacitat casy
  Future<List<String>> futureTimesList;

  @override
  void initState() {
    super.initState();

    Map service = widget.data["service"];
    Branch branch = widget.data["branch"];
    DateTime date  = widget.data["date"];

    futureTimesList = timeList(service["publicId"], branch.publicId, date);
  }

  String selectedTime = ""; //DateTime.now();
  TextEditingController timeTextField = TextEditingController();

  selectTime(BuildContext context, AsyncSnapshot<List<String>> snapshot) async {

    if(snapshot.hasData){
      selectedTime = snapshot.data[0];
    }

    showMaterialScrollPicker(
      context: context,
      title: "Vyberte čas",
      items: snapshot.data,
      selectedValue: selectedTime,
      onChanged: (value) => setState(() {
        selectedTime = value;
        timeTextField.text = selectedTime;
      })
    );

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Čas rezervácie"),
        ),
        body: FutureBuilder<List<String>>(
          future: futureTimesList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.access_time),
                    onPressed: () => selectTime(context, snapshot),
                  )),
                  Flexible(
                      child: TextField(
                    controller: timeTextField,
                    decoration: InputDecoration(labelText: "Čas: "),
                    onTap: () => selectTime(context, snapshot),
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
