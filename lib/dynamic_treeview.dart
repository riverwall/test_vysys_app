library dynamic_treeview;

import 'package:flutter/material.dart';
import 'package:test_vysys_app/data_agenda.dart';

//The MIT License (MIT)

//Copyright (c) 2019 Thangrobul Infimate

//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//documentation files (the "Software"), to deal in the Software without restriction, including without limitation
//the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

///Callback when child/parent is tapped . Map data will contain {String 'id',String 'parent_id',String 'title',Map 'extra'}
typedef OnTap = Function(Map data);

///A tree view that supports indefinite category/subcategory lists with horizontal and vertical scrolling
class DynamicTreeView extends StatefulWidget {
  ///DynamicTreeView will be build based on this.Create a model class and implement [DataAgenda]
  final List<DataAgenda> data;

  ///Called when DynamicTreeView parent or children gets tapped.
  ///Map will contain the following keys :
  ///id , parent_id , title , extra
  final OnTap onTap;

  ///The width of DynamicTreeView
  final double width;

  ///Configuration object for [DynamicTreeView]
  final Config config;
  DynamicTreeView({
    @required this.data,
    this.config = const Config(),
    this.onTap,
    this.width = 220.0,
  }) : assert(data != null);

  @override
  _DynamicTreeViewOriState createState() => _DynamicTreeViewOriState();
}

class _DynamicTreeViewOriState extends State<DynamicTreeView> {
  List<ParentWidget> treeView;
  ChildTapListener _childTapListener = ChildTapListener(null);

  @override
  void initState() {
    _buildTreeView();
    _childTapListener.addListener(childTapListener);
    super.initState();
  }

  void childTapListener() {
    if (widget.onTap != null) {
      var k = _childTapListener.getMapValue();
      widget.onTap(k);
    }
  }

  @override
  void dispose() {
    _childTapListener.removeListener(childTapListener);
    _childTapListener.dispose();
    super.dispose();
  }

  _buildTreeView() {

    //TODO - sortovanie
//    var k = widget.data.where((data) {
//      return data.services != null;
//    })
//        .map((data) {
//      return data.id;
//    })
//        .toSet()
//        .toList()
//      ..sort((i, j) => i.compareTo(j));

    var k = widget.data.where((data) {
      return data.services != null;
    });

    var widgets = List<ParentWidget>();
    k.forEach((f) {
      ParentWidget p = buildWidget(f);
      if (p != null) widgets.add(p);
    });
    setState(() {
      treeView = widgets;
    });
  }

  ParentWidget buildWidget(DataAgenda data) {
    var childrenData = data.services;

    //TODO
//    BaseData d =
//    widget.data.firstWhere((d) => d.getId() == parentId.toString());
//    if (name == null) {
//      name = d.getTitle();
//    }

    var p = ParentWidget(
      baseData: data,

        //TODO tap pre agendy vypnuty
//      onTap: widget.onTap,
      config: widget.config,
      children: _buildChildren(childrenData),
      key: ObjectKey({
        'id': '${data.id}',
        'prefix': '${data.prefix}',
        'internalName': '${data.internalName}',
        'externalName': '${data.externalName}'
      }),
    );
    return p;
  }

  _buildChildren(List<Services> data) {
    var cW = List<Widget>();
    for (var k in data) {
        cW.add(ListTile(
          onTap: () {
            widget?.onTap({
              'id': '${k.id}',
              'publicId': '${k.publicId}',
              'name': '${k.name}',
              'qpId': '${k.qpId}',
              'custom': '${k.custom}'
            });
          },
          contentPadding: widget.config.childrenPaddingEdgeInsets,
          title: Text(
            "${k.name}",
            style: widget.config.childrenTextStyle,
          ),
        ));
      }
    return cW;
  }

  //TODO
//  List<BaseData> _getChildrenFromParent(String parentId) {
//    return widget.data
//        .where((data) => data.getParentId() == parentId.toString())
//        .toList();
//  }

  @override
  Widget build(BuildContext context) {
    return treeView != null
        ? SingleChildScrollView(
      child: Container(
        width: widget.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: treeView,
          ),
          physics: BouncingScrollPhysics(),
        ),
      ),
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
    )
        : Container();
  }
}

class ChildWidget extends StatefulWidget {
  final List<Widget> children;
  final bool shouldExpand;
  final Config config;
  ChildWidget({this.children, this.config, this.shouldExpand = false});

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> sizeAnimation;
  AnimationController expandController;

  @override
  void didUpdateWidget(ChildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldExpand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  void prepareAnimation() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation curve =
    CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
    sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: sizeAnimation,
      axisAlignment: -1.0,
      child: Column(
        children: _buildChildren(),
      ),
    );
  }

  _buildChildren() {
    return widget.children.map((c) {
      // return c;
      return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: widget.config.childrenPaddingEdgeInsets,
            child: c,
          ));
    }).toList();
  }
}

class ParentWidget extends StatefulWidget {
  final List<Widget> children;
  final DataAgenda baseData;
  final Config config;
  final OnTap onTap;
  ParentWidget({
    this.baseData,
    this.onTap,
    this.children,
    this.config,
    Key key,
  }) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>
    with SingleTickerProviderStateMixin {
  bool shouldExpand = false;
  Animation<double> sizeAnimation;
  AnimationController expandController;

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
  }

  @override
  void initState() {
    prepareAnimation();
    super.initState();
  }

  void prepareAnimation() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation curve =
    CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
    sizeAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          onTap: () {
            var map = Map<String, dynamic>();
            map['id'] = widget.baseData.id;
            map['internalName'] = widget.baseData.internalName;
            map['externalName'] = widget.baseData.externalName;
            map['services'] = widget.baseData.services;
            if (widget.onTap != null) widget.onTap(map);
          },
          title: Text(widget.baseData.internalName,
              style: widget.config.parentTextStyle),
          contentPadding: widget.config.parentPaddingEdgeInsets,
          trailing: IconButton(
            onPressed: () {
              setState(() {
                shouldExpand = !shouldExpand;
              });
              if (shouldExpand) {
                expandController.forward();
              } else {
                expandController.reverse();
              }
            },
            icon: RotationTransition(
              turns: sizeAnimation,
              child: widget.config.arrowIcon,
            ),
          ),
        ),
        ChildWidget(
          children: widget.children,
          config: widget.config,
          shouldExpand: shouldExpand,
        )
      ],
    );
  }
}

///A singleton Child tap listener
class ChildTapListener extends ValueNotifier<Map<String, dynamic>> {
  /* static final ChildTapListener _instance = ChildTapListener.internal();
  factory ChildTapListener() => _instance;
  ChildTapListener.internal() : super(null); */
  Map<String, dynamic> mapValue;

  ChildTapListener(Map<String, dynamic> value) : super(value);

  // ChildTapListener() : super(null);

  void addMapValue(Map map) {
    this.mapValue = map;
    notifyListeners();
  }

  Map getMapValue() {
    return this.mapValue;
  }
}

///Dynamic TreeView will construct treeview based on parent-child relationship.So, its important to
///override getParentId() and getId() with proper values.
//abstract class BaseData {
//  ///id of this data
//  String getId();
//
//  /// parentId of a child
//  String getParentId();
//
//  /// Text displayed on the parent/child tile
//  String getTitle();
//
//  ///Any extra data you want to get when tapped on children
//  Map<String, dynamic> getExtraData();
//}

class Config {
  final TextStyle parentTextStyle;
  final TextStyle childrenTextStyle;
  final EdgeInsets childrenPaddingEdgeInsets;
  final EdgeInsets parentPaddingEdgeInsets;

  ///Animated icon when tile collapse/expand
  final Widget arrowIcon;

  //TODO
//  ///the rootid of a treeview.This is needed to fetch all the immediate child of root
//  ///Default is 1
//  final String rootId;

  const Config(
      {this.parentTextStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        this.parentPaddingEdgeInsets = const EdgeInsets.all(6.0),
        this.childrenTextStyle = const TextStyle(color: Colors.black),
        this.childrenPaddingEdgeInsets =
        const EdgeInsets.only(left: 15.0, top: 0, bottom: 0),
        this.arrowIcon = const Icon(Icons.keyboard_arrow_down)});
}