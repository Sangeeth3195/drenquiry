import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'model/ServiceList.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen();

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late SharedPreferences _preferences;

  ServiceList serviceList = ServiceList();
  bool _isLoading = false;

  Future<void> _sendDetails() async {
    _preferences = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });

    int userId = _preferences.getInt("id") ?? 1;
    // Define API endpoint and request body
    String apiUrl =
        'https://star.zsoftservices.com/api/AppAPI/getvisitDetails';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "EmployeeId": userId,
    };

    // Make API request
    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));
      print(response.body);

      serviceList = ServiceList.fromJson(jsonDecode(response.body));

    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _sendDetails();
  }

  Future<void> initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: serviceList.result == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: serviceList.result!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    // leading: const Icon(Icons.person),
                    title: Text("Doc Name : ${serviceList.result![index].doctorName}" ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 2,
                        ),
                        Text("Hospital Name : ${serviceList.result![index].hospitalName}" ??
                            ''),
                        const SizedBox(
                          height: 2,
                        ),
                        Text("Address 1 : ${serviceList.result![index].address1}" ??
                            ''),
                        const SizedBox(
                          height: 2,
                        ),
                        Text("Address 2 : ${serviceList.result![index].address2}" ??
                            ''),
                        const SizedBox(
                          height: 2,
                        ),
                        Text("Doc Mob No : ${serviceList.result![index].doctorMobileNo}" ??
                            ''),
                        const SizedBox(
                          height: 2,
                        ),
                        Text("Hosp Mob No : ${serviceList.result![index].hospitalMobileNo}" ??
                            ''),
                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle user tap
                    },
                  ),
                );
              },
            ),
    );
  }
}
