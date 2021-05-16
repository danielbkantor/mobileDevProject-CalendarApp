import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class RootPage extends StatefulWidget {
  @override
  _RootPage createState() => _RootPage();
}

class _RootPage extends State<RootPage> {

  Future<void> changeCalendar(String title, String location, String instructor, String startTime, String endTime, String date, var _key) async {//Method used to update and delete events from the calenddar

    String newTitle = title;
    String newLocation = location;
    String newInstructor = instructor;
    TextEditingController _startTimeController = TextEditingController()..text = startTime;
    TextEditingController _endTimeController = TextEditingController()..text = endTime;
    TextEditingController _dateController = TextEditingController()..text = date;
    final format = DateFormat("HH:mm");
    final format2 = DateFormat("yyyy-MM-dd");

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: "Enter New Title"
                  ),
                  onChanged: (value){
                    newTitle = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Enter New Location"
                  ),
                  onChanged: (value){
                    newLocation = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Enter New Instructor"
                  ),
                  onChanged: (value){
                    newInstructor = value;
                  },
                ),
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
                ),
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
                ),
                Text("Day"),
                DateTimeField(
                  format: format2,
                  controller: _dateController,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime.utc(2021, 5, 10),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime.utc(2021, 5, 14)
                    );
                  },
                ),
              ],
            ),
          ),

          actions: <Widget>[

            TextButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),


            TextButton(
              child: Text("Modify"),
              onPressed: () {

                CollectionReference events = FirebaseFirestore.instance.collection('events');
                events.doc(_key).set(<String, dynamic> {

                  'title': newTitle,
                  'location': newLocation,
                  'instructor': newInstructor,
                  'startTime': _startTimeController.text,
                  'endTime': _endTimeController.text,
                  'date' : _dateController.text

                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:Text("Delete"),
              onPressed: (){
                CollectionReference events = FirebaseFirestore.instance.collection('events');
                events.doc(_key).delete();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Color returnColor(){//method to generate random color
      return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);
    }

    CalendarController _controller = CalendarController();
    CollectionReference events = FirebaseFirestore.instance.collection('events');
    Map<DateTime, List<dynamic>> dateGrouping;
    DateTime startDate = DateTime.utc(2021,5,12);

    void getDateGrouping(events){//Method used to group the events in a map with the date as a key
      dateGrouping = {};
      events.forEach((event) {
        DateTime formatDate = DateTime.parse(event["date"]);
        DateTime date = DateTime.utc(formatDate.year, formatDate.month, formatDate.day);
        if (dateGrouping[date] == null){
          dateGrouping[date] = [];
        }
        dateGrouping[date].add(event);
      });
    }

    return Scaffold(
        backgroundColor: globals.backgroundColor == false ? Colors.white : Colors.grey,
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: globals.colorResult == false ? Colors.red : Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
            children:<Widget>[
              Padding(
                  padding: EdgeInsets.all(5.0)
              ),
              StreamBuilder<QuerySnapshot>(
                stream: events.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return new Text('Loading...');
                    default:
                      final events = snapshot.data.docs;
                      getDateGrouping(events);
                      List<dynamic> displayDates = dateGrouping[startDate] ?? [];
                      return Column(
                        children: [
                          Card(
                              child: TableCalendar(
                                calendarController: _controller,
                                startDay: DateTime.utc(2021, 5, 10),
                                endDay: DateTime.utc(2021, 5, 14),
                                events: dateGrouping,
                                initialCalendarFormat: CalendarFormat.week,
                                initialSelectedDay: DateTime(2021,5,12),
                                daysOfWeekStyle: DaysOfWeekStyle(
                                  dowTextBuilder: globals.calendarFormat == false ? (date, locale) => DateFormat.E(locale).format(date): (date, locale) => DateFormat.E(locale).format(date)[0],
                                ),
                                headerStyle: HeaderStyle(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent[100],
                                    )
                                ),
                                onDaySelected: (dates, event, param){
                                  setState(() {
                                    startDate = _controller.selectedDay;
                                  });
                                },
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.all(2.0)
                          ),
                          ListView(
                          shrinkWrap: true,
                          children: displayDates
                              .asMap()
                              .map((index, value) => MapEntry(
                              index,
                              Stack(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(47)
                                  ),
                                  Container(
                                    height: 85,
                                    width: 3000,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: returnColor(),
                                          width: 4.0
                                        )
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        changeCalendar(value["title"],value["location"],value["instructor"], value["startTime"], value["endTime"], value["date"], value.id);
                                      },
                                      child: ListTile(
                                        title: Text("${value["title"]}", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                        subtitle:Text("Location: ${value["location"]}\nInstructor: ${value["instructor"]}\n${value["startTime"]} - ${value["endTime"]}"),
                                        trailing: Icon(Icons.event),
                                      ),
                                    ),
                                  )
                                ],
                              )
                          )
                          ).values.toList()
                      ),
                        ],
                      );
                  }
                },
              ),

            ],
          )
      )
    );
  }
}

