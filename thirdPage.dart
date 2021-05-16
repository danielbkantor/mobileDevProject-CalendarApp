import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

class ThirdPage extends StatefulWidget{
  @override
  _ThirdPage createState() => _ThirdPage();
}

class _ThirdPage extends State<ThirdPage> {
  bool switchOneResult;
  bool switchTwoResult;
  bool switchThreeResult;
  bool switched;
  bool switchedTwo;
  bool switchedThree;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Methods used to set and get the values stored in shared preferences

  Future<void> setAppBarColor() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("color", switchedTwo);
  }

  Future<void> _setBackGroundColor() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("bcolor", switched);
  }

  Future<void> setCalendarFormat() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("calFormat", switchedThree);
  }

  Future<void> setSwitchOne() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("switchOne", switched);
  }

  Future<void> setSwitchTwo() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("switchTwo", switchedTwo);
  }

  Future<void> setSwitchThree() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("switchThree", switchedThree);
  }

  getBoolColor() async{
    final SharedPreferences prefs = await _prefs;
    globals.colorResult = prefs.getBool("color") ?? false;
  }

  getBackgroundColor() async{
    final SharedPreferences prefs = await _prefs;
    globals.backgroundColor = prefs.getBool("bcolor") ?? false;
  }

  getCalendarFormat() async{
    final SharedPreferences prefs = await _prefs;
    globals.calendarFormat = prefs.getBool("calFormat") ?? false;
  }

  getSwitchOne() async{
    final SharedPreferences prefs = await _prefs;
    switchOneResult = prefs.getBool("switchOne") ?? false;
    return switchOneResult;
  }

  getSwitchTwo() async{
    final SharedPreferences prefs = await _prefs;
    switchTwoResult = prefs.getBool("switchTwo") ?? false;
    return switchTwoResult;
  }

  getSwitchThree() async{
    final SharedPreferences prefs = await _prefs;
    switchThreeResult = prefs.getBool("switchThree") ?? false;
    return switchThreeResult;
  }

  @override
  Widget build(BuildContext context){
    getSwitchOne();
    getSwitchTwo();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: globals.backgroundColor == false ? Colors.white : Colors.grey,
        appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: globals.colorResult == false ? Colors.red : Colors.blue,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children:<Widget>[
              FutureBuilder(
                  future: getSwitchOne(),
                  builder: (context, projectSnap){
                    if(projectSnap.hasError)
                      return new Text('Error: ${projectSnap.error}');
                    switch (projectSnap.connectionState) {
                      case ConnectionState.waiting: return new Text('Loading...');
                      default:
                        return SwitchListTile(
                          title: Text("Dark Mode"),
                          subtitle: Text("On is grey - Off is white"),
                          value: projectSnap.data,
                          onChanged: (value) {
                            setState(() {
                              switched = value;
                              setSwitchOne();
                              _setBackGroundColor();
                              getBackgroundColor();
                            });
                            },
                        );
                    }
                  }
              ),

              FutureBuilder(
                  future: getSwitchTwo(),
                  builder: (context, projectSnap) {
                    if (projectSnap.hasError)
                      return new Text('Error: ${projectSnap.error}');
                    switch (projectSnap.connectionState) {
                      case ConnectionState.waiting: return new Text('Loading...');
                      default:
                        return SwitchListTile(
                          title: Text("Change App Color"),
                          subtitle: Text("On is blue - Off is red"),
                          value: projectSnap.data,
                          onChanged: (value) {
                            setState(() {
                              switchedTwo = value;
                              setSwitchTwo();
                              setAppBarColor();
                              getBoolColor();
                            });
                          },
                        );
                    }
                  }
                  ),
              FutureBuilder(
                  future: getSwitchThree(),
                  builder: (context, projectSnap) {
                    if (projectSnap.hasError)
                      return new Text('Error: ${projectSnap.error}');
                    switch (projectSnap.connectionState) {
                      case ConnectionState.waiting: return new Text('Loading...');
                      default:
                        return SwitchListTile(
                          title: Text("Change Calendar Format"),
                          subtitle: Text("On is shortened - Off is full words"),
                          value: projectSnap.data,
                          onChanged: (value) {
                            setState(() {
                              switchedThree = value;
                              setSwitchThree();
                              setCalendarFormat();
                              getCalendarFormat();
                            });
                          },
                        );
                    }
                  }
              ),
            ],
          )

        ),
      ),
    );
  }
}