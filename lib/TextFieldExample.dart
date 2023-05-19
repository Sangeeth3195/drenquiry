import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextFieldExample extends StatefulWidget {
  @override
  _TextFieldExampleState createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _controller1.text = _preferences.getString('text1') ?? '';
    _controller2.text = _preferences.getString('text2') ?? '';
    _controller3.text = _preferences.getString('text3') ?? '';
    _controller4.text = _preferences.getString('text4') ?? '';
    _controller5.text = _preferences.getString('text5') ?? '';
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TextFields Example')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller1,
              decoration: InputDecoration(labelText: 'Text Field 1'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _controller2,
              decoration: InputDecoration(labelText: 'Text Field 2'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _controller3,
              decoration: InputDecoration(labelText: 'Text Field 3'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _controller4,
              decoration: InputDecoration(labelText: 'Text Field 4'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _controller5,
              decoration: InputDecoration(labelText: 'Text Field 5'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _preferences.setString('text1', _controller1.text);
                _preferences.setString('text2', _controller2.text);
                _preferences.setString('text3', _controller3.text);
                _preferences.setString('text4', _controller4.text);
                _preferences.setString('text5', _controller5.text);

                // Clear the text fields
                _controller1.clear();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
