import 'package:flutter/material.dart';
import 'package:keisannki_app/test_screen/test_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<int>> _menuItems = List();
  int _numberOfQuestion = 0;

  @override
  void initState() {
    super.initState();
    setMenuState();
    _numberOfQuestion = _menuItems[0].value;
  }

  void setMenuState() {
    _menuItems.add(DropdownMenuItem(
      value: 5,
      child: Text('5'),
    ));
    _menuItems.add(DropdownMenuItem(
      value: 10,
      child: Text('10'),
    ));
    _menuItems.add(DropdownMenuItem(
      value: 20,
      child: Text('20'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/image_title.png')),
            SizedBox(height: 30),
            Text('問題数を選択して「スタート」ボタンを押して下さい'),
            SizedBox(height: 70),
            DropdownButton(
                style: TextStyle(fontSize: 20),
                items: _menuItems,
                value: _numberOfQuestion,
                onChanged: (Value) {
                  setState(() {
                    _numberOfQuestion = Value;
                  });
                }),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 20),
                child: RaisedButton.icon(
                  onPressed: () {
                    startTestScreen();
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  label: Text('スタート'),
                  icon: Icon(Icons.skip_next),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void startTestScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TestScreen(
                numberOfQuestions: _numberOfQuestion,
              )),
    );
  }
}
