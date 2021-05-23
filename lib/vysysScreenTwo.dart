import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:test_vysys_app/data_branch.dart';
import 'package:test_vysys_app/main.dart';
import 'package:test_vysys_app/vysysScreenThree.dart';

class ScreenTwo extends StatefulWidget {
  final Map data;

  ScreenTwo({this.data});

  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {

  Future<List<Branch>> futureBranchList;
  Branch selectedValue = Branch();

  //
  Map selectedData = Map();

  @override
  void initState() {
    super.initState();
    String publicId = widget.data['publicId'];
    print('selected service publicId: ' + publicId);
    futureBranchList = branchList(publicId);

    //
    selectedData["service"] = widget.data;
  }


//  String selectedValue;


//  final Map dataMap = data;
//  Set servicePublicId = data['publicId'];

  @override
  Widget build(BuildContext context) {

//    List<DropdownMenuItem> items = futureBranchList.map((item) {
//      return DropdownMenuItem<Branch>(
//        child: Text(item.categoryName),
//        value: item,
//      );
//    }).toList();

//    // if list is empty, create a dummy item
//    if (items.isEmpty) {
//      items = [
//        DropdownMenuItem(
//          child: Text(_selectedPackage.categoryName),
//          value: _selectedPackage,
//        )
//      ];
//    }


    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.data['name']}"),
      ),
      body: Center(
//        child: Wrap(
//          direction: Axis.vertical,
//          children: <Widget>[
//            Text(
//              "ID: ${widget.data['id']}",
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//            ),
//            Text(
//              "qpId ${widget.data['qpId']}",
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//            ),
//            Text(
//              "custom: ${widget.data['custom']}",
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//            ),
//          ],
//        ),
//      ),
//     bottomNavigationBar: Center (
       child: FutureBuilder<List<Branch>>(
         future: futureBranchList,
         builder: (context, snapshot) {
           if (snapshot.hasData) {
             return
               SearchableDropdown.single(
                 items:  snapshot.data.map((item) {
                   return (DropdownMenuItem<Branch>(
                       child: Text(item.name),
                       value: item));
                 }).toList(),
                 value: selectedValue,
                 hint: "Vyberte pracovisko",
                 searchHint: "Vyhľadajte pracovisko",
                 onChanged: (value) {
                   setState(() {
                     selectedValue = value;

                     ///
                     print(selectedValue.toString());

                     selectedData["branch"] = selectedValue;

                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (ctx) => ScreenThree(
                               data: selectedData,
                             )));
                   });
                 }
                 ,
                 dialogBox: true,
                 isExpanded: true
               );

//                 DropDownField(
//                  value: selectedValue,
//                  required: true,
//                  strict: true,
//                  labelText: 'Pracovisko',
//                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//                  icon: Icon(Icons.location_city),
//                  items: snapshot.data.map((item) {
//                      return DropdownMenuItem<Branch>(
//                        child: Text(item.name),
//                        value: item,
//                      );
//                    }).toList(),
//                  setter: (dynamic newValue) {
//                    selectedValue = newValue;
//                  },
////                  onValueChanged: (m) {
////                     print("onChildTap -> $m");
////                     Navigator.push(
////                     context,
////                     MaterialPageRoute(
////                     builder: (ctx) => ScreenTwo(
////                     data: m,
////                     )));
////                     },
//             );
           } else if (snapshot.hasError) {
              print("${snapshot.error}");
             return Text("${snapshot.error}");
           }

           // By default, show a loading spinner.
           return Center (child: CircularProgressIndicator() );
         },
       ),
     ),
//      bottomNavigationBar: Center (
//        child: DropDownField(
//            value: cityName,
//            required: true,
//            strict: true,
//            labelText: 'Pracovisko',
//            icon: Icon(Icons.location_city),
//            items: branches,
//            setter: (dynamic newValue) {
//              cityName = newValue;
//            }
//        ),
//      ),
    );
  }
}