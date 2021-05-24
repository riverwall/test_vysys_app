import 'package:test_vysys_app/vysysScreenOne.dart';

import 'dart:convert';
import 'package:test_vysys_app/vysysScreenTwo.dart';
import 'package:flutter/material.dart';
import 'package:test_vysys_app/dynamic_treeview.dart';

import 'package:test_vysys_app/data_agenda.dart';
import 'package:test_vysys_app/data_branch.dart';
import 'package:test_vysys_app/data_dates.dart';
import 'package:test_vysys_app/data_times.dart';
import 'package:http/http.dart' as http;

//AGENDA
Future<List<DataAgenda>> agendaList() async {

  final response =
//  await http.get(Uri.http('172.24.36.13:10039','/test/api/availableAgenda'));
  await http.get(Uri.https('java.ditec.sk','/calendar-backend/public/api/v3/servicesgroups/tree/'));
//  await http.get(Uri.http('localhost:8082','/calendar-backend/public/api/v3/servicesgroups/tree/'));
//  await Future.delayed(Duration(seconds: 2));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final parsed= jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<DataAgenda>((json)=>DataAgenda.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load DataAgenda');
  }


}

//BRANCHES
Future<List<Branch>> branchList(String serviceId) async {

  if(serviceId.isEmpty) {
    throw Exception('Cannot read branches. Service is not selected');
  }

  ///
  print("branches s parametrom " + serviceId);

  final response = await http.get(Uri.https('java.ditec.sk','/calendar-backend/public/api/v2/branches/available;servicePublicId=' + serviceId));
//  final response = await http.get(Uri.http('localhost:8082','/calendar-backend/public/api/v2/branches/available;servicePublicId=' + serviceId));
//  await Future.delayed(Duration(seconds: 2));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    final dataBranch = DataBranch.fromJson(jsonDecode(response.body));
    return dataBranch.branch;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Branch');
  }
}

//DATES
Future<List<DateTime>> dateList(String serviceId, String branchId) async {

  if(serviceId.isEmpty) {
    throw Exception('Cannot read dates. Service is not selected');
  }

  if(branchId.isEmpty) {
    throw Exception('Cannot read dates. Branch is not selected');
  }

  ///
  print("dates s parametami serviceId: " + serviceId + ", branchId: " + branchId);

  String parameters = '/calendar-backend/public/api/v1/branches/'+ branchId +'/services/'+ serviceId +'/dates/';

  final response = await http.get(Uri.https('java.ditec.sk', parameters));
//  final response = await http.get(Uri.http('localhost:8082','/calendar-backend/public/api/v2/branches/available;servicePublicId=' + serviceId));
//  await Future.delayed(Duration(seconds: 2));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    final dataDates = DataDates.fromJson(jsonDecode(response.body));
    List<String> dateString = dataDates.dates;

    //konverzia
    List<DateTime> dateList = dateString.map((e) => DateTime.parse(e)).toList();
    return dateList;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Dates');
  }
}

//TIMES
Future<List<String>> timeList(String serviceId, String branchId, DateTime date) async {

  if(serviceId.isEmpty) {
    throw Exception('Cannot read times. Service is not selected');
  }

  if(branchId.isEmpty) {
    throw Exception('Cannot read times. Branch is not selected');
  }

  if(date == null) {
    throw Exception('Cannot read times. Date is not selected');
  }

  String dateS = "${date.toLocal()}".split(' ')[0];

  ///
  print("times s parametami serviceId: " + serviceId + ", branchId: " + branchId + ", dateString: " + dateS);

//  http://{{host}}:{{port}}/calendar-backend/public/api/v1/branches/{{branchPublicId}}/services/{{servicePublicId}}/dates/{{dates}}/times/

  String parameters = '/calendar-backend/public/api/v1/branches/'+ branchId +'/services/'+ serviceId +'/dates/'+ dateS +'/times/';

  final response = await http.get(Uri.https('java.ditec.sk', parameters));
//  final response = await http.get(Uri.http('localhost:8082','/calendar-backend/public/api/v2/branches/available;servicePublicId=' + serviceId));
//  await Future.delayed(Duration(seconds: 2));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    final dataTimes = DataTimes.fromJson(jsonDecode(response.body));
    List<String> timesList = dataTimes.times;

    //konverzia
//    List<String> dateList = dateString.map((e) => DateTime.parse(e)).toList();
    return timesList;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Times');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Treeview Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<DataAgenda>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = agendaList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dynamic treeview sample"),
        ),
        drawer: Container(
          height: MediaQuery.of(context).size.height,

          child: FutureBuilder<List<DataAgenda>>(
            future: futureAlbum,
            builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DynamicTreeView(
                data: snapshot.data,
                config: Config(
                    parentTextStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    parentPaddingEdgeInsets:
                    EdgeInsets.only(left: 16, top: 0, bottom: 0)),
                onTap: (m) {
                  print("onChildTap -> $m");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => ScreenTwo(
                            data: m,
                          )));
                },
                width: 220.0,
              );
            } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
          color: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => ScreenOne()));
              },
              child: Text('Full Screen TreeView'),
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}