import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codefast - Operação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Codefast - Operação'),
        '/add': (context) => AddPostPage(),
        '/edit': (context) => EditPostPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        setState(() {
          _data = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _createData() async {
    try {
      final response = await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'title': 'Flutter HTTP CRUD',
            'body': 'This is a blog post about HTTP CRUD methods in Flutter',
            'userId': 1,
          }));

      if (response.statusCode == 201) {
        _fetchData();
      } else {
        throw Exception('Failed to create data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _updateData(int id) async {
    try {
      final response = await http.put(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'title': 'Flutter HTTP CRUD',
            'body':
                'This is an updated blog post about HTTP CRUD methods in Flutter',
          }));

      if (response.statusCode == 200) {
        _fetchData();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

      if (response.statusCode == 200) {
        _fetchData();
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _data[index];
          return ListTile(
            title: Text(data['title']),
            trailing: IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.pushNamed(context, '/edit', arguments: data);
              },
            ),
          );
        },
      ),
    );
  }
}

class AddPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Lógica para adicionar um novo post
          },
          child: Text('Add Post'),
        ),
      ),
    );
  }
}

class EditPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dynamic post = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Lógica para editar o post
          },
          child: Text('Edit Post ${post['id']}'),
        ),
      ),
    );
  }
}