import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<dynamic> prod = [];
  final uri = "https://dummyjson.com/products";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    print("Fetching data...");
    try {
      final response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Future.delayed(const Duration(seconds: 3));
        isLoading = false;
        setState(() {
          prod = jsonData['products'];
        });
        print("Data fetch complete");
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  List<Widget> loadImages(int index) {
    List<Widget> img = [];
    for (var i = 0; i < prod[index]['images'].length; i++) {
      Image x = Image.network(prod[index]['images'][i],
          width: 130, height: 130, fit: BoxFit.cover);
      img.add(x);
    }
    return img;
  }

  void bottomBar(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
            bottom: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: loadImages(index),
                    )),
                ListTile(
                  title: Text(prod[index]['title'],
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Text(prod[index]['description']),
                ),
                ListTile(
                  title: Text("\$" + prod[index]['price'].toDouble().toString(),
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Wrap(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(prod[index]['rating'].toString())
                    ],
                  ),
                  trailing: Wrap(
                    children: [
                      Text(prod[index]['discountPercentage'].toString() + "%"),
                      const Icon(
                        Icons.discount,
                        color: Colors.blue,
                      )
                    ],
                  ),
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Products",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : ListView.builder(
              itemCount: prod.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => bottomBar(context, index),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                            bottom: Radius.circular(20.0))),
                    elevation: 5.0,
                    margin: const EdgeInsets.all(1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(prod[index]['thumbnail']),
                        Container(
                          color: Colors.teal.withAlpha(100),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    prod[index]['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        prod[index]['price'].toString() +
                                            " USD",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(Icons.remove_red_eye_sharp)
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(prod[index]['description'])
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
