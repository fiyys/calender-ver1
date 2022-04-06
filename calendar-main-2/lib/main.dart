import 'package:calendar/calendar.dart';
import 'package:calendar/event.dart';
import 'package:calendar/sp_utils.dart';
import 'package:calendar/todo_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtils().init().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Calendar",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();

  DateTime addDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber[700],
      appBar: AppBar(
        title: Text(
          'To Do List With Medicine',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber[800],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/icon.png'),
                backgroundColor: Color.fromARGB(255, 22, 22, 22),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Go to Calendar');
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new Calendar()),
                );
              },
              icon: Icon(
                Icons.calendar_month,
                size: 30,
                color: Colors.grey[700],
              ),
              label: Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[700],
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent[400],
                  onSurface: Colors.pink,
                  minimumSize: Size(250, 50)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showCupertinoDatePicker();
              },
              icon: Icon(
                Icons.add_alert_rounded,
                size: 30,
                color: Colors.grey[700],
              ),
              label: Text(
                'New To Do List',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[700],
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent[400],
                  onSurface: Colors.pink,
                  minimumSize: Size(250, 50)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Exit to App');
              },
              icon: Icon(
                Icons.exit_to_app,
                size: 30,
                color: Colors.grey[700],
              ),
              label: Text(
                'Exit',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[700],
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent[400],
                  onSurface: Colors.pink,
                  minimumSize: Size(250, 50)),
            ),
          ],
        ),
      ),
    );
  }

  void _showCupertinoDatePicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 13),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(Duration(milliseconds: 200), () {
                        _showInput();
                      });
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(fontSize: 13),
                    )),
              ],
            ),
            Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  maximumYear: DateTime.now().year + 60,
                  minimumYear: DateTime.now().year - 60,
                  onDateTimeChanged: (dateTime) {
                    print("${dateTime.year}-${dateTime.month}-${dateTime.day}");
                    addDateTime = dateTime;
                  }),
            ),
          ]);
        });
  }

  void _showInput() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Event"),
        content: TextFormField(
          controller: editingController,
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Ok"),
            onPressed: () {
              DateHistoryStorage.putHistoryListItem(
                  editingController.text, addDateTime);

              Navigator.pop(context);
              editingController.clear();
              setState(() {});
              return;
            },
          ),
        ],
      ),
    );
  }
}