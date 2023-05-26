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
        'https://teamexapi.zsoftservices.com/api/customer/get_service_list';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'DoctorName': '',
      "customer_id": userId,
    };

    // Make API request
    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));
      print(response.body);

      serviceList = ServiceList.fromJson(jsonDecode(response.body));
      print(serviceList.count);
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
          ? Center(child: const CircularProgressIndicator())
          : ListView.builder(
              itemCount: serviceList.result!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(serviceList.result![index].customerName ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text("Total : " +
                                serviceList.result![index].total.toString() ??
                            ''),
                        SizedBox(
                          height: 2,
                        ),
                        Text("Sub Total : " +
                                serviceList.result![index].subTotal
                                    .toString() ??
                            ''),
                        SizedBox(
                          height: 2,
                        ),
                        Text("Mobile Number : " +
                                serviceList.result![index].phoneNumber
                                    .toString() ??
                            ''),
                        SizedBox(
                          height: 2,
                        ),
                        Text("Address : " +
                                serviceList.result![index].address
                                    .toString() ??
                            ''),
                        SizedBox(
                          height: 2,
                        ),
                        Text("Booking Date : " +
                                serviceList.result![index].bookingDate
                                    .toString() ??
                            ''),
                        SizedBox(
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
