import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rest_api_get_method2/model/model.dart';
import 'package:http/http.dart' as http;

class GetMethod2 extends StatefulWidget {
  const GetMethod2({super.key});

  @override
  State<GetMethod2> createState() => _GetMethod2State();
}

class _GetMethod2State extends State<GetMethod2> {
  List<PhotosModel> photosList = [];

  Future<List<PhotosModel>> getPhotos() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    if (response.statusCode == 200) {
      // Decode the response body
      var data = jsonDecode(response.body) as List;

      // Update the state variable directly
      photosList = data.map((photoData) => PhotosModel.fromJson(photoData)).toList();

      return photosList;
    } else {
      // Throw an exception if the response was not successful
      throw Exception("Failed to load photos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          "Example two",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<PhotosModel>>(
        future: getPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No photos found'));
          } else {
            return Card(
              elevation: 2,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final photo = snapshot.data![index];
                  return ListTile(
                    leading: Image.network(photo.thumbnailUrl),
                    title: Text(photo.title),
                    subtitle: Text('ID: ${photo.id}'),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}



