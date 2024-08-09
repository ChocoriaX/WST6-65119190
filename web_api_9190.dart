import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyUI65119190());
}

class MyUI65119190 extends StatefulWidget {
  const MyUI65119190({super.key});

  @override
  State<MyUI65119190> createState() => _MyUI65119190State();
}

class _MyUI65119190State extends State<MyUI65119190> {
  User? user;
  Result? userInfo;

  Future<void> loadData() async {
    try {
      var url = Uri.https('randomuser.me', '/api');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the response body into a JSON object
        Map<String, dynamic> json = jsonDecode(response.body);
        
        setState(() {
          user = User.fromJson(json);
          userInfo = user!.results[0];
        });

        print(
          'Name: ${userInfo!.name.title} ${userInfo!.name.first} ${userInfo!.name.last}'
        );
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget showName(Result user) {
    return ListTile(
      title: Center(
          child: Text(
            '${user.name.first} ${user.name.last}',
            style: const TextStyle(fontSize: 20.0),
          ),
      ),
      subtitle: Center(
          child: Image.network(user.picture.large)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Worksheet 6'),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: userInfo == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  showName(userInfo!),
                ],
              ),
      ),
    );
  }
}

class User {
  final List<Result> results;

  User({required this.results});

  factory User.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Result> resultList = list.map((i) => Result.fromJson(i)).toList();
    return User(results: resultList);
  }
}

class Result {
  final Name name;
  final Picture picture;

  Result({required this.name, required this.picture});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name: Name.fromJson(json['name']),
      picture: Picture.fromJson(json['picture']),
    );
  }
}

class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      title: json['title'],
      first: json['first'],
      last: json['last'],
    );
  }
}

class Picture {
  final String large;

  Picture({required this.large});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      large: json['large'],
    );
  }
}
