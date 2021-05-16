import 'package:flutter/material.dart';
import 'firstPage.dart';
import 'secondPage.dart';
import 'thirdPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

Widget currentScreen = RootPage();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        title: "Stateful App Example",
        home: Database(),
      )
  );
}

class Database extends StatelessWidget{ // Initialize the database
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ProperForm();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text("Waiting");
      },
    );
  }
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext build){
    return MaterialApp(
      initialRoute: 'Home',
      routes: {
        'Home': (context) => ProperForm()
      },
    );
  }
}


class ProperForm extends StatefulWidget {//Logic to change pages with a bottom nav bar
  @override
  _ProperFormState createState() => _ProperFormState();
}
class _ProperFormState extends State<ProperForm> {
  int selectedPage;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: PageStorage(child: currentScreen, bucket: bucket),
      bottomNavigationBar: bmnav.BottomNav(
          index: selectedPage,
          onTap: (pageIndex) {
            setState(() {
              selectedPage = pageIndex;
              if(pageIndex == 0){
                currentScreen = RootPage();
                RootPage first = currentScreen;
                first.createState().initState();
              }
              else if(pageIndex == 1){
                currentScreen = SecondPage();
                SecondPage second = currentScreen;
                second.createState().initState();
              }
              else if(pageIndex == 2){
                currentScreen = ThirdPage();
                ThirdPage third = currentScreen;
                third.createState().initState();
              }
            });
          },
          items: [
            bmnav.BottomNavItem(Icons.calendar_today, label: 'Calendar'),
            bmnav.BottomNavItem(Icons.event, label: 'Add Event'),
            bmnav.BottomNavItem(Icons.settings, label: 'Seetings'),
          ],
        ),
    );
  }
}



