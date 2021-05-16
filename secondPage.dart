import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class SecondPage extends StatefulWidget{
  @override
  _SecondPage createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {

//Page used to add events to the calendar

  String courseTitle;
  String instructor;
  String location;
  String startTime;

  String endTime;
  final GlobalKey<FormState> _key = GlobalKey();
  final format = DateFormat("HH:mm");
  final format2 = DateFormat("yyyy-MM-dd");
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: globals.backgroundColor == false ? Colors.white : Colors.grey,
        appBar: AppBar(
          title: Text("Add Event"),
          backgroundColor: globals.colorResult == false ? Colors.red : Colors.blue,
          centerTitle: true,
        ),
        body: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            child: ListView(
              children:<Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0)
                ),
                TextFormField(
                    initialValue: "",
                    decoration: InputDecoration(
                      labelText: "Enter Course Title",
                      border: InputBorder.none
                    ),
                    onChanged:(String val){
                      setState(() {
                        courseTitle = val;
                      });
                    },
                    validator:(value){
                      if(value == null || value.isEmpty){
                        return "Please fill the field";
                      }
                      return null;
                    }
                ),
                Divider(),
                TextFormField(
                    initialValue: "",
                    decoration: InputDecoration(
                      labelText: "Enter Instructor Name",
                        border: InputBorder.none
                    ),
                    onChanged:(String val){
                      setState(() {
                        instructor = val;
                      });
                    },
                    validator:(value){
                      if(value == null || value.isEmpty){
                        return "Please fill the field";
                      }
                      return null;
                    }
                ),
                Divider(),
                TextFormField(
                    initialValue: "",
                    decoration: InputDecoration(
                      labelText: "Enter Location",
                        border: InputBorder.none

                    ),
                    onChanged:(String val){
                      setState(() {
                        location = val;
                      });
                    },
                    validator:(value){
                      if(value == null || value.isEmpty){
                        return "Please fill the field";
                      }
                      return null;
                    }
                ),
                Divider(),
                Text("Start Time"),
                DateTimeField(
                  controller: _startTimeController,
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                    },
                    validator:(value){
                      if(value == null){
                        return "Please fill the field";
                      }
                      return null;
                    }
                ),
                Divider(),
                Text("End Time"),
                DateTimeField(
                  controller: _endTimeController,
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                    validator:(value){
                      if(value == null){
                        return "Please fill the field";
                      }
                      return null;
                    }
                ),
                Divider(),
                Text("Day"),
                DateTimeField(
                  format: format2,
                  controller: _dateController,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime.utc(2021, 5, 10),
                        initialDate: currentValue ?? DateTime.utc(2021,5,10),
                        lastDate: DateTime.utc(2021, 5, 14)
                    );
                  },
                    validator:(value){
                      if(value == null){
                        return "Please fill the field";
                      }
                      return null;
                    }
                ),
                Divider(),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: (){
                    if(_key.currentState.validate()){
                      CollectionReference users = FirebaseFirestore.instance.collection('events');
                      users.doc().set(<String, dynamic>{
                        'title': courseTitle,
                        'location': location,
                        'instructor': instructor,
                        'startTime': _startTimeController.text,
                        'endTime': _endTimeController.text,
                        'date' : _dateController.text
                      }).then<void>((dynamic doc) {
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}