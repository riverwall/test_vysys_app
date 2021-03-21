import 'package:test_vysys_app/vysysScreenTwo.dart';
import 'package:flutter/material.dart';
import 'package:test_vysys_app/dynamic_treeview.dart';
import 'package:test_vysys_app/data_agenda.dart';
import 'package:test_vysys_app/main.dart';

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  Future<List<DataAgenda>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Screen One"),
        ),
        body: FutureBuilder<List<DataAgenda>>(
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
              width: MediaQuery.of(context).size.width,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
      ),
    );
  }
}

