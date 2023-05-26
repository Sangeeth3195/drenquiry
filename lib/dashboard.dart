import 'dart:convert';

import 'package:dr_enquiry/UserListScreen.dart';
import 'package:dr_enquiry/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'TextFieldExample.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _TextFieldExampleState createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<Dashboard> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  late SharedPreferences _preferences;
  String? _currentAddress;
  Position? _currentPosition;
  int _currentIndex = 0;
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
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
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
    super.dispose();
  }

  Future<void> _sendDetails() async {
    setState(() {
      _isLoading = true;
    });

    int userId = _preferences.getInt("id") ?? 1;
    // Define API endpoint and request body
    String apiUrl = 'https://teamexapi.zsoftservices.com/api/Account/addvisit';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'DoctorName': '',
      'HospitalName': '',
      "Address1": "test",
      "Address2": "test",
      "Latitude": _currentPosition!.latitude,
      "Longitude": _currentPosition!.longitude,
      "DoctorMobileNo": "test",
      "HospitalMobileNo": "test",
      "HospitalLandLine": "test",
      "Remarks": "test",
      "Description": "test",
      "EmployeeId": userId,
    };

    // Make API request
    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        // Login successful, navigate to next screen
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextFieldExample()));
      } else {
        // Login failed, display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Details'),
            content: const Text('Please make sure fill all the details'),
            actions: [
              TextButton(
                child: const Text('OK'),
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
          title: const Text('Error'),
          content: const Text('An error occurred. Please try again later.'),
          actions: [
            TextButton(
              child: const Text('OK'),
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
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(tabContent[_currentIndex].title),
            actions: [
              IconButton(onPressed: () async{
                 SharedPreferences _preferences=     await SharedPreferences.getInstance();
                 _preferences.clear();
                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                     LoginScreen()), (Route<dynamic> route) => false);
                 }, icon: Icon(Icons.add))
            ],
          ),
          body: tabContent[_currentIndex].content,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(
                () {
                  _currentIndex = index;
                },
              );
            }, // new
            currentIndex: _currentIndex, // new
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.add_comment_outlined),
                label: 'Add Visit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                label: 'Visit Details',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TabContent {
  String title;
  Widget content;

  TabContent({required this.title, required this.content});
}

List<TabContent> tabContent = [
  TabContent(
    title: 'Add Visit',
    content: TextFieldExample(),
  ),
  TabContent(
    title: 'Visit Details',
    content: UserListScreen(),
  )
];
