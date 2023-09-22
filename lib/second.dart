import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Foxpage extends StatefulWidget {
  @override
  _CatpageState createState() => _CatpageState();
}

class _CatpageState extends State<Foxpage> {
  String imageUrl = '';

  Future<void> _getImage() async {
  final response = await http.get(Uri.parse('https://randomfox.ca/floof'));

  if (response.statusCode == 200) {
    setState(() {
      imageUrl = json.decode(response.body)['image'];
      print("img" + imageUrl);
    });
  } else {
    throw Exception('Failed to load random fox image');
  }
}


  @override
  void initState() {
    super.initState();
    _getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Räv'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                ElevatedButton(
              onPressed: _getImage,
              child: Text('Hämta en slumpmässig rävbild'),
                )
          ],
        ),
      ),
    );
  }
}
