import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:artgen/painter.dart';

import 'package:rxdart/rxdart.dart';

void main() => runApp(ArtGenApp());

class ArtGenApp extends StatelessWidget {

  final String title = 'artgen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ArtGenPage(title: title),
    );
  }
}

class ArtGenPage extends StatefulWidget {
  ArtGenPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ArtGenPageState createState() => _ArtGenPageState();
}

class _ArtGenPageState extends State<ArtGenPage> with SingleTickerProviderStateMixin {

  // Scaffold key used to display snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of painters wrapped in functions to recreate instances of them
  static final List<Function> paintersFunctions = [
    () => PointsPainter(), 
    () => LinesPainter(), 
    () => ShadowsPainter(), 
    () => OvalsPainter(), 
    () => TrianglesPainter()
  ];

  // List of current painters
  static final List<RecordablePainter> painters = paintersFunctions.map(
    (painter) => painter() as RecordablePainter).toList();

  // List of streams each corresponding to a painter
  List<PublishSubject> streams = List.generate(painters.length, (i) => PublishSubject<Null>());

  // Tab controller for the TabBarView
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  // Returns a tab with a properly styled title
  Tab tab(String title) => Tab(child: Text(title, style: TextStyle(color: Theme.of(context).primaryColor)));

  // Returns a centered CustomPaint with the passed painter
  Widget tabView(RecordablePainter painter) =>
    Center(
      child: CustomPaint(
        painter: painter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
        )
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("artgen", style: TextStyle(color: Theme.of(context).primaryColor),),
        actions: <Widget>[
          FlatButton.icon(
            label: Text("Save", style: TextStyle(color: Theme.of(context).primaryColor)),
            icon: Icon(Icons.save, color: Theme.of(context).primaryColor,),
            onPressed: () async {
              var res = await painters[_tabController.index].saveImage();
              if(res != "") {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Text("Image saved to the gallery.", textAlign: TextAlign.center,),
                ));
              }
            }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        icon: Icon(Icons.refresh),
        label: Text("Refresh"),
        onPressed: () {
          setState(() { // Recreate the current painter and notifies its stream
            painters[_tabController.index] = paintersFunctions[_tabController.index]();
            streams[_tabController.index].add(null);
          });
        }
      ),
      bottomNavigationBar: TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: [
          tab("Points"),
          tab("Lines"),
          tab("Shadows"),
          tab("Ovals"),
          tab("Triangles"),
          
        ]
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // for loop to access corresponding streams and painters
          for(var i = 0; i < painters.length; i++)
            StreamBuilder(
              stream: streams[i],
              builder: (context, snap) => tabView(painters[i])
            )
        ],
      ));
  }
}
