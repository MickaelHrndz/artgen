import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:artgen/painter.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'model.dart';

void main() => runApp(ArtGenApp());

class ArtGenApp extends StatelessWidget {

  final String title = 'artgen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  // Is the settings menu open
  bool settings = false;
  
  // Farris Painter parameters
  static FarrisParams farrisParams = FarrisParams();

  // List of painters wrapped in functions to recreate instances of them
  static final Map<String, Function> paintersFunctions = {
    "Farris": () => FarrisPainter(farrisParams.a, farrisParams.b),
    "Points": () => PointsPainter(), 
    "Lines": () => LinesPainter(), 
    "Shadows": () => ShadowsPainter(), 
    "Triangles": () => TrianglesPainter(),
    "Ovals": () => OvalsPainter(), 
  };

  // List of current painters
  static final List<RecordablePainter> painters = paintersFunctions.values.map(
    (painter) => painter() as RecordablePainter).toList();

  // List of streams each corresponding to a painter
  List<Observable> streams = List.generate(painters.length, (i) => Observable(null));

  // Tab controller for the TabBarView
  TabController _tabController;

  // Default text style
  TextStyle textStyle(context) => TextStyle(color: Theme.of(context).primaryColor, fontSize: 18);

  // Returns a tab with a properly styled title
  Tab tab(String title) => Tab(child: Text(title, style: TextStyle(color: Theme.of(context).primaryColor)));

  // Returns a row of two +/- buttons and a number input
  Row numberRow(int value, Function add) { 
    Function addTo = (val) {
      add(val);
      refreshPainter();
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          mini: true,
          child: Icon(Icons.remove),
          onPressed: () => addTo(-1),
        ),
        SizedBox(
          width: 70,
          child: TextFormField(
            style: textStyle(context),
            textAlign: TextAlign.center,
            controller: TextEditingController(text: value.toString()),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) => addTo(int.parse(val) - value)
          ),
        ),
        FloatingActionButton(
          mini: true,
          child: Icon(Icons.add),
          onPressed: () => addTo(1),
        ),
      ],
    );
  }

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

  // Refresh the painter of the currently selected tab
  refreshPainter() => setState(() {
    // Recreate the current painter
    painters[_tabController.index] = paintersFunctions.values.elementAt(_tabController.index)();

    // Notifies its stream
    streams[_tabController.index].value = null;
  });

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller
    _tabController = TabController(vsync: this, length: 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: FlatButton(
          onPressed: () => setState(() => settings = !settings),
          child: Icon(Icons.settings, color: settings ? Colors.deepPurple[300] : Theme.of(context).primaryColor,),),
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).primaryColor),),
        centerTitle: true,
        actions: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Builder(
              builder: (context) => FlatButton(
                padding: EdgeInsets.all(0),
                child: Icon(Icons.save, color: Theme.of(context).primaryColor,),
                onPressed: () async {
                  var res = await painters[_tabController.index].saveImage();
                  if(res != "") {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text("Image saved in the phone storage.", textAlign: TextAlign.center,),
                    ));
                  }
                }
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        icon: Icon(Icons.refresh),
        label: Text("Refresh"),
        onPressed: () {
          if(_tabController.index == 0) farrisParams.randomize();
          refreshPainter();
        }
      ),
      bottomNavigationBar: TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: [
          for(var name in paintersFunctions.keys)
            tab(name)
        ]
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // for loop to access corresponding streams and painters
              for(var i = 0; i < painters.length; i++)
                Stack(
                  children: [
                    StreamBuilder(
                      stream: streams[i].value,
                      builder: (context, snap) => tabView(painters[i])
                    ),
                    i == 0 ? AnimatedContainer(
                      color: Theme.of(context).scaffoldBackgroundColor.withAlpha(200),
                      height: settings ? 174 : 0,
                      padding: EdgeInsets.all(8),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                      child: Observer(
                        builder: (context) => Column(
                          children: <Widget>[
                              Text("a", style: textStyle(context)),
                              numberRow(farrisParams.a, (val) => farrisParams.addToA(val)),
                              SizedBox(height: 16,),
                              Text("b", style: textStyle(context)),
                              numberRow(farrisParams.b, (val) => farrisParams.addToB(val))
                          ]
                        )),
                      ) : SizedBox()
                  ]
                )
            ]
          ),
        ]
      ));
  }
}
