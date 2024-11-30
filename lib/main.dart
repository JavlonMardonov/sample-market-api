import 'dart:convert';
import 'dart:ui';

import 'package:dars_4/product.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchApiData();
  }

  Future<void> fetchApiData() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Birnima",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(3.0),
                  child: Container(
                    color: Colors.grey[400],
                    height: 1.0,
                  )),
              toolbarHeight: 30,
            ),
            drawer: Drawer(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(products[index]['title']),
                    trailing: CircleAvatar(
                      backgroundImage: NetworkImage(products[index]['image']),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                              productId: products[index]['id']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            body: products.isEmpty
                ? Center(child: Lottie.asset("assets/animations/loading.json"))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var product in products)
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                        productId: product['id']),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                            child: Image.network(
                                          product['image'],
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )),
                                        const SizedBox(height: 10),
                                        Text(
                                          product['title'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('\$${product['price']}'),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                      ],
                    ),
                  )));
  }
}
