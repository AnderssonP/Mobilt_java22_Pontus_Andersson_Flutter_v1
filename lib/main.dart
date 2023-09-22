import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/second.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hund sida'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _prefs;
  String value = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadValueFromSharedPreferences(); 
  }

  Future<void> _getImage() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    if (response.statusCode == 200) {
      setState(() {
        imageUrl = json.decode(response.body)['message'];
        _prefs.setString("image", imageUrl);
      });
    } else {
      throw Exception('Failed to load random dog image');
    }
  }

  void _changeSite() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Foxpage()));
  }

  Future<void> _loadValueFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('image') ?? '';
      print(imageUrl + " Detta kom fram!!");
    });
  }

  @override
  Widget build(BuildContext context) {
    initSharedPreferences();
    return Scaffold(
      appBar: AppBar(title: const Text('Hund')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageUrl.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Image.network(imageUrl),
                  )
                : Container(),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Hämta en slumpmässig hundbild'),
            ),
            ElevatedButton(
              onPressed: _changeSite,
              child: Image.asset('lib/icons/fox.png'),
            )
          ],
        ),
      ),
    );
  }
}
