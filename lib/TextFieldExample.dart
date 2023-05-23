import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  String? _currentAddress;
  Position? _currentPosition;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _getCurrentPosition();
  }

  Future<void> initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _controller1.text = _preferences.getString('text1') ?? '';
    _controller2.text = _preferences.getString('text2') ?? '';
    _controller3.text = _preferences.getString('text3') ?? '';
    _controller4.text = _preferences.getString('text4') ?? '';
    _controller5.text = _preferences.getString('text5') ?? '';
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
          print(position);
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
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

  Future<void> _sendDetails() async {
    setState(() {
      _isLoading = true;
    });



    int userId=_preferences.getInt("id")??1;
    // Define API endpoint and request body
    String apiUrl = 'https://teamexapi.zsoftservices.com/api/Account/addvisit';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'DoctorName':'',
      'HospitalName': '',
      "Address1":"test",
      "Address2":"test",
      "Latitude":_currentPosition!.latitude,
      "Longitude":_currentPosition!.longitude,
      "DoctorMobileNo":"test",
      "HospitalMobileNo":"test",
      "HospitalLandLine":"test",
      "Remarks":"test",
      "Description":"test",
      "EmployeeId":userId,
    };

    // Make API request
    try {
      var response = await http.post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(body));
      print(response.body);

      if (response.statusCode == 200) {
        // Login successful, navigate to next screen
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextFieldExample()));
      } else {
        // Login failed, display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Details'),
            content: const Text('Please make sure fill all the details'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again later.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
                _sendDetails();
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
