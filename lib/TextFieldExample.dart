import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TextFieldExample extends StatefulWidget {
  const TextFieldExample({super.key});

  @override
  _TextFieldExampleState createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();
  final TextEditingController _controller7 = TextEditingController();
  final TextEditingController _controller8 = TextEditingController();
  final TextEditingController _controller9 = TextEditingController();
  late SharedPreferences _preferences;
  String? _currentAddress;
  Position? _currentPosition;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
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
          content: Text(
              'Location services are disabled. Please enable the services')));
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
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
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
    _controller6.dispose();
    _controller7.dispose();
    _controller8.dispose();
    _controller9.dispose();
    super.dispose();
  }

  Future<void> _sendDetails() async {
    print("lat --> ${_currentPosition!.latitude}");
    print("lon --> ${_currentPosition!.longitude}");

    setState(() {
      _isLoading = true;
    });
    int userId = _preferences.getInt("id") ?? 1;

    String apiUrl = 'https://star.zsoftservices.com/api/AppAPI/addvisit';

    Map<String, String> headers = {'Content-Type': 'application/json'};

    print(_controller1);

    Map<String, dynamic> body = {
      'DoctorName': _controller1.text,
      'HospitalName': _controller2.text,
      "Address1": _controller3.text,
      "Address2": _controller4.text,
      "Latitude": _currentPosition!.latitude.toString(),
      "Longitude": _currentPosition!.longitude.toString(),
      "DoctorMobileNo": _controller5.text,
      "HospitalMobileNo": _controller6.text,
      "HospitalLandLine": _controller7.text,
      "Remarks": _controller9.text,
      "Description": _controller8.text,
      "EmployeeId": userId,
    };

    print(body);

    // Make API request
    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));
      print(response.body);

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(
        //   msg: "This is Center Short Toast",
        // );
        _controller1.clear();
        _controller2.clear();
        _controller3.clear();
        _controller4.clear();
        _controller5.clear();
        _controller6.clear();
        _controller7.clear();
        _controller8.clear();
        _controller9.clear();
        // Login successful, navigate to next screen
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextFieldExample()));
      } else {
        // Login failed, display error message
      }
    } catch (error) {
      print(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('TextFields Example')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Doctor name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Doctor Name',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _controller2,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Hospital name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hospital Name',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Address';
                    }
                    return null;
                  },
                  controller: _controller3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address 1',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Address 2';
                    }
                    return null;
                  },
                  controller: _controller4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address 2',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Doctor Mobile No';
                    }
                    return null;
                  },
                  controller: _controller5,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Doctor Mobile No',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  /*validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Hospital Mobile No';
                    }
                    return null;
                  },*/
                  keyboardType: TextInputType.number,

                  controller: _controller6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hospital Mobile No',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                 /* validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Hospital Landline No';
                    }
                    return null;
                  },*/
                  controller: _controller6,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hospital Landline No',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                  controller: _controller7,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  /*validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Remarks';
                    }
                    return null;
                  },*/
                  controller: _controller8,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Remarks',
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _sendDetails();
                      _preferences.setString('Doctor Name', _controller1.text);
                      _preferences.setString('Hospital Name', _controller2.text);
                      _preferences.setString('Address 1', _controller3.text);
                      _preferences.setString('Address 2', _controller4.text);
                      _preferences.setString('Doctor Mobile No', _controller5.text);
                      _preferences.setString('Hospital Mobile No', _controller6.text);
                      _preferences.setString(
                          'Hospital Landline No', _controller9.text);
                      _preferences.setString('Description', _controller7.text);
                      _preferences.setString('Remarks', _controller8.text);
                    }

                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: const Text('Submit'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
