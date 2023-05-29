import 'dart:convert';
import 'package:dr_enquiry/TextFieldExample.dart';
import 'package:dr_enquiry/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  late SharedPreferences _preferences;

  Future<void> _login() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    // Define API endpoint and request body
    String apiUrl = 'https://teamexapi.zsoftservices.com/api/customer/login';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {
      'phone_with_code': '+91$username',
      'password': password,
      "fcm_token": "test"
    };

    // Make API request
    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _preferences.setInt('id', data['result']['id']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Dashboard()));
      } else {
        // Login failed, display error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: const Text('Invalid username or password.'),
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
      print(error.toString());
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
  void initState() {
    // TODO: implement initState
    super.initState();
    if (kDebugMode) {
      _usernameController.text = '8344716194';
      _passwordController.text = '123';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 150.0),
                Image.asset('assets/star.png', height: 150, width: 150),
                const SizedBox(height: 50.0),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Container(
                        height: 45,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () {
                            _login();
                          },
                        )),
              ],
            )));
  }
}
