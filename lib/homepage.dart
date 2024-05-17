import 'package:codefast/data/http/http_client.dart';
import 'package:codefast/data/repositories/torneio_repository.dart';
import 'package:codefast/data/store/torneio_store.dart';
import 'package:codefast/operacao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TorneioStore store =
      TorneioStore(repository: TorneioRepository(client: HttpClient()));

  @override
  void initState() {
    super.initState();
    store.getTorneios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torneios em andamento'),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([store.isLoading]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: store.state.value.length,
              itemBuilder: (_, index) {
                final item = store.state.value[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OperacaoTorneio(torneio: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Cor de fundo do container
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      item.titulo,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Future<void> _fetchData() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('http://localhost:5165/torneio'));

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _data = jsonDecode(response.body);
  //       });

  //       print(_data);
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> _createData() async {
  //   try {
  //     final response = await http.post(
  //         Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, dynamic>{
  //           'title': 'Flutter HTTP CRUD',
  //           'body': 'This is a blog post about HTTP CRUD methods in Flutter',
  //           'userId': 1,
  //         }));

  //     if (response.statusCode == 201) {
  //       _fetchData();
  //     } else {
  //       throw Exception('Failed to create data');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> _updateData(int id) async {
  //   try {
  //     final response = await http.put(
  //         Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, dynamic>{
  //           'title': 'Flutter HTTP CRUD',
  //           'body':
  //               'This is an updated blog post about HTTP CRUD methods in Flutter',
  //         }));

  //     if (response.statusCode == 200) {
  //       _fetchData();
  //     } else {
  //       throw Exception('Failed to update data');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> _deleteData(int id) async {
  //   try {
  //     final response = await http
  //         .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

  //     if (response.statusCode == 200) {
  //       _fetchData();
  //     } else {
  //       throw Exception('Failed to delete data');
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }
}
