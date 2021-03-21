import 'package:test_vysys_app/vysysScreenOne.dart';

import 'dart:convert';
import 'package:test_vysys_app/vysysScreenTwo.dart';
import 'package:flutter/material.dart';
import 'package:test_vysys_app/dynamic_treeview.dart';

import 'package:test_vysys_app/data_agenda.dart';
import 'package:http/http.dart' as http;

Future<List<DataAgenda>> fetchAlbum() async {
  final response =
//  await http.get(Uri.http('172.24.36.13:10039','/test/api/availableAgenda'));
  await http.get(Uri.https('java.ditec.sk','/calendar-backend/public/api/v3/servicesgroups/tree/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final parsed= jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<DataAgenda>((json)=>DataAgenda.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
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
    futureAlbum = fetchAlbum();
  }

//  List<DataAgenda> getData(){
//    List<DataAgenda> data;
//
//    futureAlbum.then((futureData){
//      data = futureData;
//    });
//    return data;
//  }

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